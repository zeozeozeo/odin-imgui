import json
import typing
import ast
import math
import argparse

# HELPERS
def write_line(file: typing.IO, line: str = ""):
	file.writelines([line, "\n"])

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

	try:
		return ast.literal_eval(string)
	except Exception:
		return None

_odin_keywords = [
	"in",
]

def make_identifier_valid(ident: str) -> str:
	if str_to_int(ident[0]) != None:
		return "_" + ident

	for keyword in _odin_keywords:
		if ident == keyword:
			return "_" + ident

	return ident


def make_field_list(names: typing.List[str], type: str, array_count: int, in_function: bool = False) -> str:
	names = list(map(lambda s: make_identifier_valid(s), names))
	array_type_extension = ""
	if array_count != None:
		if in_function:
			if array_count == "func_arg_pointer_decay":
				# At least we know that it's meant to be an array...
				array_type_extension = "[^]"
			else:
				array_type_extension = f'^[{array_count}]'
		else:
			array_type_extension = f'[{array_count}]'

	return ", ".join(names) + ": " + array_type_extension + type

# Try strippiung prefixes from the list, returns tuple of [prefix, remainder]
def strip_list(name: str, prefix_list: typing.List[str]) -> typing.List[str]:
	for prefix in prefix_list:
		if name.startswith(prefix):
			return [prefix, name.removeprefix(prefix)]

	return ["", name]

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
	"int": "c.int",
	"void*": "rawptr",
	"const char*": "cstring",
	"char*": "cstring",
	"char": "c.char",
	"unsigned char": "c.uchar",
	"unsigned short": "c.ushort",
	"unsigned int": "c.uint",
	"signed char": "c.char",
	"signed short": "c.short",
	"signed int": "c.int",
	"signed long long": "c.longlong",
	"unsigned long long": "c.ulonglong",
	"short": "c.short",
	"size_t": "c.size_t",
	"va_list": "libc.va_list",
}

def parse_type_str(type_str: str) -> str:
	 # TODO: This could potentially remove `const` from the middle of a name
	type_str = type_str.replace("const", "")
	type_str = type_str.replace(" *", "*")
	type_str = type_str.replace("* ", "*")

	prev_str = type_str
	while True:
		type_str = prev_str.replace("  ", " ")
		if type_str == prev_str:
			break
		prev_str = type_str

	type_str = type_str.strip()

	return _parse_type_str(type_str)

def _parse_type_str(type_str: str) -> str:
	if type_str in _type_aliases:
		return _type_aliases[type_str]

	if type_str.endswith("*"):
		return "^" + _parse_type_str(type_str.removesuffix("*"))

	return strip_imgui_branding(type_str)

def parse_type(type_dict) -> str:
	if "type_details" in type_dict:
		details = type_dict["type_details"]
		assert(details["flavour"] == "function_pointer")

		return function_to_string(details)

	return parse_type_str(type_dict["declaration"])

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
def get_array_count(name_dict) -> str:
	if not name_dict["is_array"]:
		assert "array_bounds" not in name_dict, "This is awkward..."
		return None

	bounds_value = name_dict["array_bounds"]

	# TODO:
	if bounds_value in _imgui_bounds_value_overrides:
		return _imgui_bounds_value_overrides[bounds_value]

	if bounds_value == "None":
		# The fact that we get "None" probably indicates a bug in the generator.
		# This indicates an arg like `float foo[]`.
		return "func_arg_pointer_decay"

	if try_eval(bounds_value) != None:
		return bounds_value

	enum_value = try_convert_enum_literal(bounds_value)
	if enum_value != None:
		return enum_value

	print(f'Couldn\'t parse array bounds "{name_dict["array_bounds"]}"')
	# assert array_count != None, f'Couldn\'t parse array bounds for "{name_dict["array_bounds"]}"'

	return None

def write_section(file: typing.IO, section_name: str):
	write_line(file)
	write_line(file, "////////////////////////////////////////////////////////////")
	write_line(file, "// " + section_name.upper())
	write_line(file, "////////////////////////////////////////////////////////////")
	write_line(file)

# HEADER
def write_header(file: typing.IO):
	write_line(file, """package imgui

import "core:c"

CHECKVERSION :: proc() {
	DebugCheckVersionAndDataLayout(IMGUI_VERSION, size_of(IO), size_of(Style), size_of(Vec2), size_of(Vec4), size_of(DrawVert), size_of(DrawIdx))
}
""")

# DEFINES

_imgui_define_prefixes = [
	""
]

# Defines have special prefixes
def define_strip_prefix(name: str) -> str:
	for prefix in _imgui_define_prefixes:
		if name.startswith(prefix):
			return name.removeprefix(prefix)

	return name

_imgui_define_include = [
	"IMGUI_VERSION"
]

def write_defines(file: typing.IO, defines):
	write_section(file, "Defines")
	for define in defines:
		entire_name = define["name"]

		if entire_name in _imgui_define_include:
			name = define_strip_prefix(entire_name)

			write_line(file, f'{name} :: {define["content"]}')

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

def write_enum_as_flags(file, enum, enum_field_prefix, name):
	write_line(file, f'{name} :: bit_set[{name.removesuffix("s")}; c.int]')
	write_line(file, f'{name.removesuffix("s")} :: enum c.int {{')

	for element in enum["elements"]:
		element_value = element["value"]
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
		write_line(file, f'\t{field_name} = {bit_index},')

	write_line(file, "}")
	write_line(file)

	for element in enum["elements"]:
		element_base_name = element["name"]
		element_name = enum_parse_field_name(element_base_name, enum_field_prefix)
		element_value = element["value"]

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
	write_line(file, f'{name} :: distinct c.int')

	for element in enum["elements"]:
		field_base_name = element["name"]
		field_name = enum_parse_field_name(field_base_name, enum_field_prefix)
		field_value = element["value"]

		field_value_evald = try_eval(field_value)
		if field_value_evald != None:
			write_line(file, f'{name}_{field_name} :: {name}({field_value})')
		else:
			enums = enum_split_value(field_value)
			enums = list(map(lambda s: strip_imgui_branding(s), enums))
			write_line(file, f'{name}_{field_name} :: {name}({" | ".join(enums)})')

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

		if "value" in element:
			base_value = element["value"]
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

_imgui_struct_override = {
	"ImVec2": "Vec2 :: [2]f32",
	"ImVec4": "Vec4 :: [4]f32",
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
		if entire_name.startswith("<anonymous"):
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
		# name = entire_name

		write_line(file, f'{name} :: struct {{')
		for field in struct["fields"]:
			field_names = field["names"]

			# Check if there is a mix of array and non array fields
			expects_array_types = field_names[0]["is_array"]
			has_any_differing_types = False
			for field_name in field_names:
				if field_name["is_array"] != expects_array_types:
					has_any_differing_types = True
					break

			field_type = parse_type(field["type"])

			if has_any_differing_types:
				for field_name in field_names:
					array_count = get_array_count(field_name)
					write_line(f'\t{make_field_list([field_name["name"]], field_name["type"], array_count)},')
			else:
				array_count = get_array_count(field_names[0])
				field_name_strings = map(lambda field_name: field_name["name"], field_names)
				write_line(file, f'\t{make_field_list(field_name_strings, field_type, array_count)},')
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
			argument_type = parse_type(argument["type"])

		array_count = get_array_count(argument)
		argument_list.append(make_field_list([argument_name], argument_type, array_count, in_function=True))

	proc_decl += ", ".join(argument_list)

	proc_decl += ")"

	return_type = parse_type(function["return_type"])
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
	write_line(file, """// I'm not an expert on this, so the linux/osx imports may be incorrect!
when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"
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

		decl = "\t"

		if function_uses_va_list(function):
			 # Functions with va_list always have a vararg counterpart, and va_list cannot be constructed from Odin
			decl += "// "

		if prefix != None:
			decl += f'@(link_name="{entire_name}") '

		decl += f'{remainder} :: '

		decl += function_to_string(function)
		decl += " ---"

		write_line(file, decl)

	write_line(file, "}")

# TYPEDEFS

_imgui_allowed_typedefs = [
	"ImS8",
	"ImU8",
	"ImS16",
	"ImU16",
	"ImS32",
	"ImU32",
	"ImS64",
	"ImU64",

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

		write_line(file, f'{name} :: {parse_type(typedef["type"])}')

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
