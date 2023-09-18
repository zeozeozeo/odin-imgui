import json
import typing
import ast
import math
import argparse

# TODO:
# - Align comments
#		ImGui has nicely aligned comments, and we just dump them with no special
#		indentation. Fixing this would increase readability, especially in cases
#		with inline tables spanning multiple lines (see: comments on `Font` struct)
# - Get rid of any special handling of values
#		There are many cases where we override or disable different structs/enums etc.
#		This is done for a variety of reasons. We should continuously try to fix these where possible.
# - Use enum value field
#		A recent change in dear_bindings allows knowing the exact evaluated value of enum fields.
#		This might be very good for some enums which can't be written as flags
#		See: https://github.com/dearimgui/dear_bindings/blob/main/docs/Changelog.txt
# - Check for IMGUI_DISABLE_OBSOLETE_FUNCTIONS

# HELPERS
def write_line(file: typing.IO, line: str = "", indent = 0):
	file.writelines(["\t" * indent, line, "\n"])

def strip_prefix_optional(prefix: str, string: str) -> str:
	if string.startswith(prefix):
		return string.removeprefix(prefix)
	else:
		return None

def strip_prefix(prefix: str, string: str) -> str:
	stripped = strip_prefix_optional(prefix, string)
	assert stripped != None, f'"{string}" did not start with "{prefix}"'
	return stripped

def str_to_int(string: str):
	try:
		return ast.literal_eval(string)
	except Exception:
		return None

# Try to evaluate in any way. If this doesn't return None then it should be
# safe to use the value in the source.
def try_eval(string: str):
	if string.startswith("1<<"):
		return 1 << try_eval(string.removeprefix("1<<"))

	return str_to_int(string)

_disallowed_identifiers = [
	"in", # Odin keyword
	"c", # Shadows import "core:c"
]

def make_identifier_valid(ident: str) -> str:
	if str_to_int(ident[0]) != None:
		return "_" + ident

	for keyword in _disallowed_identifiers:
		if ident == keyword:
			return "_" + ident

	return ident

# Try stripping prefixes from the list, returns tuple of [prefix, remainder]
def strip_list(name: str, prefix_list: typing.List[str]) -> typing.List[str]:
	for prefix in prefix_list:
		if name.startswith(prefix):
			return [prefix, name.removeprefix(prefix)]

	return ["", name]

# Check if name has an override from `overrides`, and apply it if so
def apply_override(name: str, overrides: typing.Dict[str, str]) -> str:
	if name in overrides: return overrides[name]
	else: return name

_imgui_prefixes = [
	"ImGui",
	"Im",
]

_imgui_namespaced_prefixes = [
	["ImVector_", "Vector"],
	["ImGuiStorage_", "Storage"],
]

def strip_imgui_branding(name: str) -> str:
	for namespaced_prefix in _imgui_namespaced_prefixes:
		if name.startswith(namespaced_prefix[0]):
			remainder = name.removeprefix(namespaced_prefix[0])
			return namespaced_prefix[1] + "_" + strip_imgui_branding(remainder)

	for prefix in _imgui_prefixes:
		if name.startswith(prefix):
			return name.removeprefix(prefix)

	return name

_type_aliases = {
	"float": "f32",
	"double": "f64",

	"long_long": "c.longlong",
	"unsigned_long_long": "c.ulonglong",
	"int": "c.int",
	"unsigned_int": "c.uint",
	"short": "c.short",
	"unsigned_short": "c.ushort",
	"char": "c.char",
	"unsigned_char": "c.uchar",

	"ImS8": "i8",
	"ImU8": "u8",
	"ImS16": "i16",
	"ImU16": "u16",
	"ImS32": "i32",
	"ImU32": "u32",
	"ImS64": "i64",
	"ImU64": "u64",

	"size_t": "c.size_t",
	"bool": "c.bool",

	"va_list": "libc.va_list",
}

_pointer_aliases = {
	"char": "cstring",
	"void": "rawptr",
}

def make_type_odiney(type_str: str) -> str:
	if type_str in _type_aliases:
		return _type_aliases[type_str]

	return strip_imgui_branding(type_str)

# Returns named type if kind is builtin or user.
def peek_named_type(type_desc) -> str:
	if   type_desc["kind"] == "Builtin": return type_desc["builtin_type"]
	elif type_desc["kind"] == "User": return type_desc["name"]
	else: return None

def parse_type2(type_dict, in_function=False) -> str:
	if "type_details" in type_dict:
		details = type_dict["type_details"]
		assert(details["flavour"] == "function_pointer")

		return function_to_string(details)

	return parse_type_desc(type_dict["description"], in_function)

# TODO[TS]: Clean this up a bit
def parse_type_desc(type_desc, in_function=False) -> str:
	match type_desc["kind"]:
		case "Builtin":
			return make_type_odiney(type_desc["builtin_type"])

		case "User":
			return make_type_odiney(type_desc["name"])

		case "Pointer":
			named_type = peek_named_type(type_desc["inner_type"])
			if named_type != None:
				if named_type in _pointer_aliases:
					return _pointer_aliases[named_type]

			return "^" + parse_type_desc(type_desc["inner_type"], in_function)

		case "Array":
			array_bounds = get_array_count(type_desc["bounds"])
			array_str = None
			if in_function:
				if array_bounds == "None": # TODO[TS]: Workaround for https://github.com/dearimgui/dear_bindings/issues/41
					array_str = f'[^]' # Pointer decay
				else:
					array_str = f'^[{array_bounds}]'
			else:
				if array_bounds == "None":
					raise "This should never happen!"
				else:
					array_str = f'[{array_bounds}]'

			assert array_str != None

			return array_str + parse_type_desc(type_desc["inner_type"], in_function)

		case kind:
			raise Exception(f'Unhandled type kind "{kind}"')

# Try to parse a string containing an imgui enum, and convert it to an odin imgui enum
def try_convert_enum_literal(name: str) -> str:
	if not name.startswith("ImGui"): return None
	name = name.removeprefix("ImGui")

	dot_index = name.find("_")
	if dot_index == -1: return None

	return name.replace("_", ".", 1)

IM_DRAWLIST_TEX_LINES_WIDTH_MAX = 63
IM_UNICODE_CODEPOINT_MAX = 0xFFFF

_imgui_bounds_value_overrides = {
	# The original value had to be removed (search for it to see why). Luckily this is equivalent
	"ImGuiKey_KeysData_SIZE": "Key.COUNT",
	# These are all resolvable using the data we have, but doing this for now.
	# TODO:
	"32+1": "33",
	"IM_DRAWLIST_TEX_LINES_WIDTH_MAX+1": str(int(IM_DRAWLIST_TEX_LINES_WIDTH_MAX+1)),
	"(IM_UNICODE_CODEPOINT_MAX +1)/4096/8": str(int((IM_UNICODE_CODEPOINT_MAX +1)/4096/8)),
}

# Get array count for name. If not array, returns None
def get_array_count(bounds_value) -> str:
	if str_to_int(bounds_value) != None: return bounds_value

	if bounds_value in _imgui_bounds_value_overrides:
		return _imgui_bounds_value_overrides[bounds_value]

	if bounds_value == "None":
		return "None" # https://github.com/dearimgui/dear_bindings/issues/41

	enum_value = try_convert_enum_literal(bounds_value)
	if enum_value != None:
		return enum_value

	print(f'Couldn\'t parse array bounds "{bounds_value}"')

	return None

def write_section(file: typing.IO, section_name: str):
	write_line(file)
	write_line(file, "////////////////////////////////////////////////////////////")
	write_line(file, "// " + section_name.upper())
	write_line(file, "////////////////////////////////////////////////////////////")
	write_line(file)

# Writes a line with associated comments.
# `comment_parent` should be an item from the json file which might have a "comments" field.
def write_line_with_comments(file: typing.IO, str: str, comment_parent, indent = 0):
	comment = comment_parent.get("comments", {})
	for preceding_comment in comment.get("preceding", []):
		write_line(file, preceding_comment, indent)

	attached_comment = ""
	if "attached" in comment:
		attached_comment = " " + comment["attached"]

	write_line(file, str + attached_comment, indent)

# HEADER
def write_header(file: typing.IO):
	write_line(file, """package imgui

import "core:c"

CHECKVERSION :: proc() {
	DebugCheckVersionAndDataLayout(VERSION, size_of(IO), size_of(Style), size_of(Vec2), size_of(Vec4), size_of(DrawVert), size_of(DrawIdx))
}
""")

# DEFINES

_imgui_define_prefixes = [
	"IMGUI_",
	"IM_",
]

# Defines have special prefixes
def define_strip_prefix(name: str) -> str:
	for prefix in _imgui_define_prefixes:
		if name.startswith(prefix):
			return name.removeprefix(prefix)

	return name

_imgui_define_include = [
	"IMGUI_VERSION",
	"IMGUI_VERSION_NUM",
]

def write_defines(file: typing.IO, defines):
	write_section(file, "Defines")
	for define in defines:
		entire_name = define["name"]

		if entire_name in _imgui_define_include:
			name = define_strip_prefix(entire_name)

			write_line_with_comments(file, f'{name} :: {define["content"]}', define)

	write_line(file)

# ENUMS
def enum_parse_name(original_name: str) -> typing.List[str]:
	start_idx = -1
	end_idx = -1
	if original_name.startswith("ImGui"):
		start_idx = 5
	elif original_name.startswith("Im"):
		start_idx = 2
	else:
		assert False, f'Invalid prefix on enum "{original_name}"'

	enum_field_prefix = original_name

	if original_name.endswith("_"):
		end_idx = -1
	else:
		enum_field_prefix += "_"
		end_idx = len(original_name)

	return [enum_field_prefix, original_name[start_idx:end_idx]]

def enum_parse_field_name(field_base_name: str, expected_prefix: str) -> str:
		field_name = strip_prefix_optional(expected_prefix, field_base_name)
		if field_name == None:
			return field_base_name
		else:
			return field_name

def enum_split_value(value: str) -> typing.List[str]:
	return list(map(lambda s: s.strip(), value.split("|")))

def enum_parse_value(value: str, enum_name, expected_prefix: str) -> str:
	if value.find("<") != -1 or str_to_int(value) != None:
		return value
	else:
		enums = enum_split_value(value)

		element_list = []

		for enum in enums:
			element_list.append(enum_name + "." + enum_parse_field_name(enum, expected_prefix))

		return " | ".join(element_list)

def enum_parse_flag_combination(value: str, expected_prefix: str) -> typing.List[str]:
	enums = enum_split_value(value)

	combined_enums = []

	for enum in enums:
		combined_enums.append("." + enum_parse_field_name(enum, expected_prefix))

	return combined_enums

# TODO[TS]: Don't bother parsing value expressions, use value directly.
def write_enum_as_flags(file, enum, enum_field_prefix, name):
	write_line_with_comments(file, f'{name} :: bit_set[{name.removesuffix("s")}; c.int]', enum)
	write_line(file, f'{name.removesuffix("s")} :: enum c.int {{')

	for element in enum["elements"]:
		element_value = element["value_expression"]
		bit_index = strip_prefix_optional("1<<", element_value)

		if bit_index == None:
			literal_value = try_eval(element_value)

			if literal_value == None or literal_value == 0:
				 # Not a unique flag - either "none" (0) or a combination flag
				continue

			bit_index = math.log2(literal_value)
			if bit_index != int(bit_index):
				file.write("/* this value is quite unfortunate */// ")
			# assert bit_index == int(bit_index), f'Got a literal number in a bitset, but it was not a power of two: {entire_name} = {element_value}'
			bit_index = int(bit_index)

		field_base_name = element["name"]
		field_name = enum_parse_field_name(field_base_name, enum_field_prefix)
		write_line_with_comments(file, f'{field_name} = {bit_index},', element, 1)

	write_line(file, "}")
	write_line(file)

	for element in enum["elements"]:
		element_base_name = element["name"]
		element_name = enum_parse_field_name(element_base_name, enum_field_prefix)
		element_value = element["value_expression"]

		value_string = ""
		value_is_stupid_dumb_garbage_literal = False

		if element_value == "0":
			value_string = ""
		elif element_value.startswith("1<<"):
			value_string = "." + element_name
		elif try_eval(element_value) != None:
			value_is_stupid_dumb_garbage_literal = True
			value_string = element_value
		else:
			flag_combination = enum_parse_flag_combination(element_value, enum_field_prefix)
			value_string = ",".join(flag_combination)

		if value_is_stupid_dumb_garbage_literal:
			extra_comment = f'Meant to be of type {name}'
			write_line(file, f'{name}_{element_name} :: c.int({value_string}) // {extra_comment}')
		else:
			write_line(file, f'{name}_{element_name} :: {name}{{{value_string}}}')

	write_line(file)

def write_enum_as_constants(file, enum, enum_field_prefix, name):
	write_line_with_comments(file, f'{name} :: distinct c.int', enum)

	for element in enum["elements"]:
		field_base_name = element["name"]
		field_name = enum_parse_field_name(field_base_name, enum_field_prefix)
		field_value = element["value_expression"]

		field_value_evald = try_eval(field_value)
		if field_value_evald != None:
			write_line_with_comments(file, f'{name}_{field_name} :: {name}({field_value})', element)
		else:
			enums = enum_split_value(field_value)
			enums = list(map(lambda s: strip_imgui_branding(s), enums))
			write_line_with_comments(file, f'{name}_{field_name} :: {name}({" | ".join(enums)})', element)

	write_line(file)

def write_enum(file: typing.IO, enum, enum_field_prefix: str, name: str, stop_after: str):
	write_line(file, f'{name} :: enum c.int {{')

	stop_comment = ""

	for element in enum["elements"]:
		field_base_name = element["name"]
		# SEE: _imgui_enum_stop_after
		if field_base_name == stop_after:
			stop_comment = "// "
			write_line(file, "\t// Some of the next enum values are self referential, which currently causes issues")
			write_line(file, "\t// Search for this in the generator for more info.")

		field_name = enum_parse_field_name(field_base_name, enum_field_prefix)
		field_name = make_identifier_valid(field_name)

		if "value_expression" in element:
			base_value = element["value_expression"]
			value = enum_parse_value(base_value, name, enum_field_prefix)
			write_line(file, f'\t{stop_comment}{field_name} = {value},')
		else:
			write_line(file, f'\t{stop_comment}{field_name},')

	write_line(file, "}")
	write_line(file)

_imgui_enum_as_constants = [
	# These flags use the lower four bits to encode button index, and the rest
	# other flags.
	"ImGuiPopupFlags_",
	# These initialize elements with elements with elements... or whatever.
	# This can be solved by figuring out which of the elements are an actual bitmask
	"ImGuiTableFlags_",
	"ImDrawFlags_",
	"ImGuiHoveredFlags_",
	# This one is special, because it doesn't actually define a single flag of its own...
	# It's also deprecated
	"ImDrawCornerFlags_",
]

_imgui_enum_skip = [
	# This is both deprecated, and also depends on weirdly scoped enums in `Key`
	"ImGuiModFlags_",
]

# Odin can't do self referential enums. Where this is the case, we need to remove
# both the self referential enums, as well as the following enum elements
# (as they may depend on the previous element value)
_imgui_enum_stop_after = {
	"ImGuiKey": "ImGuiKey_NamedKey_BEGIN",
}

def write_enums(file: typing.IO, enums):
	write_section(file, "Enums")
	for enum in enums:
		# enum_field_prefix is the prefix expected on each field
		# name is the actual name of the enum
		entire_name = enum["name"]
		[enum_field_prefix, name] = enum_parse_name(entire_name)

		if entire_name in _imgui_enum_skip:
			continue

		# if entire_name != "ImGuiPopupFlags_": continue
		# if entire_name == "ImGuiKey": continue

		if name.endswith("Flags"):
			if entire_name in _imgui_enum_as_constants:
				# The truly cursed path - there's nothing we can do to save these
				write_enum_as_constants(file, enum, enum_field_prefix, name)
			else:
				write_enum_as_flags(file, enum, enum_field_prefix, name)
		else:
			stop_after = None
			if entire_name in _imgui_enum_stop_after:
				stop_after = _imgui_enum_stop_after[entire_name]
			write_enum(file, enum, enum_field_prefix, name, stop_after)

# TYPEDEFS

# STRUCTS
_imgui_struct_skip = [
	# Has an anonymous field, which currently isn't handled
	"ImVector_ImGuiStorage_ImGuiStoragePair",
	# Depends on the above
	"ImGuiStorage",
]

# We can generate these structs just fine, but we have a better Odin equivalent.
_imgui_struct_override = {
	"ImVec2": "Vec2 :: [2]f32",
	"ImVec4": "Vec4 :: [4]f32",
}

_imgui_struct_field_name_override = {
	# We have a field called `ID` of type `ID`. In Odin, field names can not
	# have the same identifier as a type in the same struct.
	# TODO[TS]: This can be fixed properly, by stringifying all the field types,
	# then checking that our field name is not in that list.
	"ID": "_ID",
}

def write_structs(file: typing.IO, structs):
	write_section(file, "Structs")
	for struct in structs:
		entire_name = struct["name"]

		if entire_name in _imgui_struct_skip:
			continue

		if entire_name in _imgui_struct_override:
			write_line(file, _imgui_struct_override[entire_name])
			continue

		# ANONYMOUS TODO:
		if entire_name.startswith("__anonymous_type"):
			continue

		any_anonymous = False
		for field in struct["fields"]:
			if field["is_anonymous"]:
				any_anonymous = True
				break
		if any_anonymous:
			continue
		# /ANONYMOUS

		name = strip_imgui_branding(entire_name)

		write_line_with_comments(file, f'{name} :: struct {{', struct)
		for field in struct["fields"]:
			adjusted_name = apply_override(field["name"], _imgui_struct_field_name_override)
			field_type = parse_type2(field["type"])
			write_line_with_comments(file, f'{adjusted_name}: {field_type},', field, 1)

		write_line(file, "}")
		write_line(file)

# FUNCTIONS
def function_to_string(function) -> str:
	proc_decl = 'proc "c" ('

	argument_list = []
	arguments = function["arguments"]

	for argument_idx in range(len(arguments)):
		argument = arguments[argument_idx]

		argument_type = "no type yet :)"
		argument_is_varargs = argument["is_varargs"]
		argument_name = argument["name"]

		if argument_is_varargs:
			argument_name = "#c_vararg args"
			argument_type = "..any"
		else:
			argument_name = make_identifier_valid(argument_name)
			argument_type = parse_type2(argument["type"], in_function=True)

		argument_list.append(f'{argument_name}: {argument_type}')

	proc_decl += ", ".join(argument_list)

	proc_decl += ")"

	return_type = parse_type2(function["return_type"])
	if return_type != "void":
		proc_decl += f' -> {return_type}'

	return proc_decl

def function_uses_va_list(function) -> bool:
	arguments = function["arguments"]

	if len(arguments) == 0:
		return False

	last_arg = arguments[len(arguments) - 1]

	if last_arg["is_varargs"]:
		# These don't have a type field
		return False

	return last_arg["type"]["declaration"] == "va_list"

_imgui_functions_skip = [
	# These depend on storage, which is currently skipped
	"ImGui_SetStateStorage",
	"ImGui_GetStateStorage",
	"ImGuiStorage_Clear",
	"ImGuiStorage_GetInt",
	"ImGuiStorage_SetInt",
	"ImGuiStorage_GetBool",
	"ImGuiStorage_SetBool",
	"ImGuiStorage_GetFloat",
	"ImGuiStorage_SetFloat",
	"ImGuiStorage_GetVoidPtr",
	"ImGuiStorage_SetVoidPtr",
	"ImGuiStorage_GetIntRef",
	"ImGuiStorage_GetBoolRef",
	"ImGuiStorage_GetFloatRef",
	"ImGuiStorage_GetVoidPtrRef",
	"ImGuiStorage_SetAllInt",
	"ImGuiStorage_BuildSortByKey",
	# Returns ImStr, which isn't defined anywhere?
	"ImStr_FromCharStr",
]

# We have to keep track of seen functions, as currently one function (GetKeyIndex)
# is present twice in the json
_imgui_functions_seen = {}

_imgui_function_prefixes = [
	"ImGui_",
	"ImGui",
	"Im",
]

def write_functions(file: typing.IO, functions):
	write_section(file, "Functions")
	write_line(file, """
when      ODIN_OS == .Windows do foreign import lib "imgui_windows_x64.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui_linux_x64.a"
else when ODIN_OS == .Darwin {
	when ODIN_ARCH == .amd64 { foreign import lib "imgui_darwin_x64.a" } else { foreign import lib "imgui_darwin_arm64.a" }
}
""")
	write_line(file, "foreign lib {")

	for function in functions:
		entire_name = function["name"]
		if entire_name in _imgui_functions_skip:
			continue

		if entire_name in _imgui_functions_seen:
			continue
		_imgui_functions_seen[entire_name] = True

		[prefix, remainder] = strip_list(entire_name, _imgui_function_prefixes)

		decl = ""

		if function_uses_va_list(function):
			 # Functions with va_list always have a vararg counterpart, and va_list cannot be constructed from Odin
			decl += "// "

		if prefix != None:
			decl += f'@(link_name="{entire_name}") '

		decl += f'{remainder} :: '

		decl += function_to_string(function)
		decl += " ---"

		write_line_with_comments(file, decl, function, 1)

	write_line(file, "}")

# TYPEDEFS

_imgui_allowed_typedefs = [
	"ImWchar16",
	"ImWchar32",
	# "ImWchar",

	"DrawIdx",
	"ImDrawIdx",
	"ImTextureID",
	"ImGuiID",

	"ImGuiKeyChord",

	"ImDrawCallback",
	"ImGuiSizeCallback",
	"ImGuiInputTextCallback",
	"ImGuiMemAllocFunc",
	"ImGuiMemFreeFunc",
]

def write_typedefs(file: typing.IO, typedefs):
	write_section(file, "Typedefs")
	for typedef in typedefs:
		entire_name = typedef["name"]

		if not entire_name in _imgui_allowed_typedefs:
			continue

		name = strip_imgui_branding(entire_name)

		write_line_with_comments(file, f'{name} :: {parse_type2(typedef["type"])}', typedef)

def main():
	parser = argparse.ArgumentParser()

	parser.add_argument("imgui_json", default="imgui.json")
	parser.add_argument("destination_file", default="imgui.odin")

	args = parser.parse_args()

	info = json.load(open(args.imgui_json, "r"))
	file = open(args.destination_file, "w+")

	write_header(file)
	write_defines(file, info["defines"])
	write_enums(file, info["enums"])
	write_structs(file, info["structs"])
	write_functions(file, info["functions"])
	write_typedefs(file, info["typedefs"])

	# TODO: Duplicate wchar typedef. Easy fix, but ignoring for now!
	write_line(file, "Wchar :: Wchar16")

if __name__ == "__main__": main()
