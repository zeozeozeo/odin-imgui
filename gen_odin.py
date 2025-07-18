import json
import typing
import ast
import argparse
import sys
from os import path

# TODO:
# - Get rid of any special handling of values
#		There are many cases where we override or disable different structs/enums etc.
#		This is done for a variety of reasons. We should continuously try to fix these where possible.
# - Use enum value field
#		A recent change in dear_bindings allows knowing the exact evaluated value of enum fields.
#		This might be very good for some enums which can't be written as flags
#		See: https://github.com/dearimgui/dear_bindings/blob/main/docs/Changelog.txt
# - Check for IMGUI_DISABLE_OBSOLETE_FUNCTIONS
# - In general, conditionals should be checked to see if they cause any issues.
# - There should be an option to emit a more complete version of IMGUI_CHECKVERSION() that checks all structs (and more?)
# @(link_name) Should be avoided where possible to reduce noise
# Investigate whether Ex functions can be removed in favor of actually respecting default args and proc groups

g_has_imgui_internal_and_is_not_in_imgui_internal = False

# HELPERS
def nice_stack(start: int = 0):
	i = start + 1

	stack_strings = []

	while True:
		try:
			frame = sys._getframe(i)
			stack_strings.append([frame.f_code.co_name, f'{path.basename(frame.f_code.co_filename)}:{frame.f_lineno}'])
			i += 1
		except:
			max_len = 0
			for j in range(len(stack_strings)):
				max_len = max(max_len, len(stack_strings[j][0]))
			max_len += 1
			for stack_string in stack_strings:
				print(stack_string[0] + " " * (max_len - len(stack_string[0])) + stack_string[1])
			return

def die(message):
	print()
	print("FATAL ERROR: " + message)
	print()
	nice_stack(1)
	exit(1)

def write_line(file: typing.IO, line: str = "", indent = 0):
	file.writelines(["\t" * indent, line, "\n"])

def strip_prefix_optional(prefix: str, string: str) -> str:
	if string.startswith(prefix): return string.removeprefix(prefix)
	return None

def strip_prefix(prefix: str, string: str) -> str:
	stripped = strip_prefix_optional(prefix, string)
	assert stripped != None, f'"{string}" did not start with "{prefix}"'
	return stripped

def strip_suffix_optional(suffix: str, string: str) -> str:
	if string.endswith(suffix): return string.removesuffix(suffix)
	return None

def strip_suffix(suffix: str, string: str) -> str:
	stripped = strip_suffix_optional(suffix, string)
	assert stripped != None, f'"{string}" did not end with "{suffix}"'
	return stripped

def strip_circumfix_optional(prefix: str, suffix: str, string: str) -> str:
	if string.startswith(prefix) and string.endswith(suffix): return string.removeprefix(prefix).removesuffix(suffix)
	return None

def strip_circumfix(prefix: str, suffix: str, string: str) -> str:
	stripped = strip_circumfix_optional(prefix, suffix, string)
	assert stripped != None, f'"{string}" did not have circumfix "{prefix}" and "{suffix}'
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

# returns [chomped string, ok]
def _chomp(prefix: str, string: str) -> [str, bool]:
	if string.startswith(prefix):
		return [string.removeprefix(prefix), True]
	return [string, False]

# returns [chomped string, found string, ok]
def _chomp_until(until: str, string: str) -> [str, str, bool]:
	pos = string.find(until)
	if pos == -1:
		return [string, "", False]

	return [string[pos:], string[:pos+len(until)-1], True]

_disallowed_identifiers = [
	"in", "context", # Odin keywords
	"c", # Shadows import "core:c"
]

def make_identifier_valid(ident: str) -> str:
	if str_to_int(ident[0]) != None: return "_" + ident

	for keyword in _disallowed_identifiers:
		if ident == keyword: return "_" + ident

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

	"FILE": "c.FILE"
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

def parse_type(type_dict, in_function=False) -> str:
	if "type_details" in type_dict:
		details = type_dict["type_details"]
		assert details["flavour"] == "function_pointer"

		return function_to_string(details)

	return parse_type_desc(type_dict["description"], in_function)

# TODO[TS]: Clean this up a bit
def parse_type_desc(type_desc, in_function=False) -> str:
	kind = type_desc["kind"]
	if kind == "Builtin":
		return make_type_odiney(type_desc["builtin_type"])

	elif kind == "User":
		return make_type_odiney(type_desc["name"])

	elif kind == "Pointer":
		named_type = peek_named_type(type_desc["inner_type"])
		if named_type != None:
			if named_type in _pointer_aliases:
				return _pointer_aliases[named_type]

		return "^" + parse_type_desc(type_desc["inner_type"], in_function)

	elif kind == "Array":
		array_bounds = get_array_count(type_desc)
		array_str = None
		if in_function:
			if    array_bounds == None: array_str = f'[^]' # Pointer decay
			else: array_str = f'^[{array_bounds}]'
		else:     array_str = f'[{array_bounds}]'

		assert array_str != None

		return array_str + parse_type_desc(type_desc["inner_type"], in_function)

	else:
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
	# TODO: These can be evaluated with varying levels of effort
	"32+1": "33",
	"IM_DRAWLIST_TEX_LINES_WIDTH_MAX+1": str(int(IM_DRAWLIST_TEX_LINES_WIDTH_MAX+1)),
	"(IM_UNICODE_CODEPOINT_MAX +1)/8192/8": str(int((IM_UNICODE_CODEPOINT_MAX +1)/8192/8)),
}

# Get array count for name. If not array, returns None
def get_array_count(type_desc) -> str:
	if not "bounds" in type_desc:
		return None

	bounds_value = type_desc["bounds"]
	if str_to_int(bounds_value) != None: return bounds_value

	if bounds_value in _imgui_bounds_value_overrides:
		return _imgui_bounds_value_overrides[bounds_value]

	if bounds_value in processed_defines: return define_strip_prefix(bounds_value)

	enum_value = try_convert_enum_literal(bounds_value)
	if enum_value != None:
		return enum_value

	die(f'Couldn\'t parse array bounds "{bounds_value}"')

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

_odin_value_aliases = {
	"NULL": "nil",
	"-FLT_MIN": "-min(f32)",
	"FLT_MAX": "max(f32)",
	"sizeof(float)": "size_of(f32)",
	"IM_COL32_WHITE": "0xff_ff_ff_ff",
}

def type_is_int(type: str) -> bool:
	return type in ["u8", "i8", "u16", "i16", "u32", "i32", "u64", "i64", "u128", "i128", "int", "uint", "byte", "char", "rune", "uintptr"]

def convert_imvec_value(value: str, components: int) -> str:
	stripped = strip_circumfix(f"ImVec{components}(", ")", value)
	values = stripped.split(",")
	assert len(values) == components
	for i in range(len(values)):
		values[i] = make_value_odiney(values[i].strip(), "int") # We say "int" here to imply that it's numeric
		assert len(values[i]) > 0

	return "{" + ", ".join(values) + "}"

def make_value_odiney(value: str, type_hint: str = None) -> str:
	if value == "IM_COL32(255, 0, 0, 255)": return "u32(0xff0000ff)" # joyous world
	if value in _odin_value_aliases: return _odin_value_aliases[value]
	if type_hint == "Vec2": return convert_imvec_value(value, 2)
	if type_hint == "Vec4": return convert_imvec_value(value, 4)
	# TODO: This is almost certainly not the right place to do this
	if strip_imgui_branding(value) != value: return strip_imgui_branding(value)
	if value.endswith("f"): return value.removesuffix("f")

	if value == "0" and not type_is_int(type_hint): return "{}"

	return value

# HEADER
def write_global_header(file: typing.IO):
	write_line(file, "package imgui")

def write_import_header(file: typing.IO):
	write_line(file, """
import "core:c"

@(private="file") ARCH :: "x64" when ODIN_ARCH == .amd64 else "arm64"

when ODIN_OS == .Windows {
	foreign import lib { "imgui_windows_" + ARCH + ".lib" }
} else when ODIN_OS == .Linux {
	foreign import lib {
		"imgui_linux_" + ARCH + ".a",
		"system:stdc++",
	}
} else when ODIN_OS == .Darwin {
	foreign import lib {
		"imgui_darwin_" + ARCH + ".a",
		"system:c++",
	}
} else when ODIN_OS == .JS {
	foreign import lib "wasm/c_imgui.o"
	@(require) foreign import "wasm/imgui.o"
	@(require) foreign import "wasm/imgui_demo.o"
	@(require) foreign import "wasm/imgui_draw.o"
	@(require) foreign import "wasm/imgui_tables.o"
	@(require) foreign import "wasm/imgui_widgets.o"
}
""")

def write_import_header_internal(file: typing.IO):
	write_line(file, """
import "core:c"

@(private="file") ARCH :: "x64" when ODIN_ARCH == .amd64 else "arm64"

when ODIN_OS == .Windows {
	foreign import lib { "imgui_windows_" + ARCH + ".lib" }
} else when ODIN_OS == .Linux {
	foreign import lib {
		"imgui_linux_" + ARCH + ".a",
		"system:c++",
	}
} else when ODIN_OS == .Darwin {
	foreign import lib {
		"imgui_darwin_" + ARCH + ".a",
		"system:c++",
	}
} else when ODIN_OS == .JS {
	foreign import lib "wasm/c_imgui_internal.o"
}""")

def write_main_file_header(file: typing.IO):
	write_line(file, """CHECKVERSION :: proc() {
	DebugCheckVersionAndDataLayout(VERSION, size_of(IO), size_of(Style), size_of(Vec2), size_of(Vec4), size_of(DrawVert), size_of(DrawIdx))
}""")

# Pushes a list of field components to the aligned fields, accounting for comments.
# Attached comments will be included as a field component
# Preceding comments will be inserted as a "delimiter", which will
# reset alignment.
def append_aligned_field(aligned_fields, field_components, comment_parent):
	comment = comment_parent.get("comments", {})
	for preceding_comment in comment.get("preceding", []):
		aligned_fields.append(preceding_comment)

	if "attached" in comment: aligned_fields.append(field_components + [" " + comment["attached"]])
	else:                     aligned_fields.append(field_components)

# Given a list of fields, write them out aligned
def _write_aligned_fields_range(file: typing.IO, aligned_fields, indent = 0):
	# Find column sizes
	column_sizes = []

	for field in aligned_fields:
		for component_idx in range(len(field)):
			if component_idx >= len(column_sizes): column_sizes.append(0)

			component = field[component_idx]
			column_sizes[component_idx] = max(column_sizes[component_idx], len(component))

	for field in aligned_fields:
		file.write('\t' * indent)
		for component_idx in range(len(field)):
			component = field[component_idx]
			whitespace_amount = column_sizes[component_idx] - len(component)
			if component_idx == len(field) - 1: whitespace_amount = 0 # Don't pad last element
			file.write(component + (' ' * whitespace_amount))

		write_line(file)

def write_aligned_fields(file: typing.IO, aligned_fields, indent = 0):
	last_non_delimiter = 0 # Implicit delimiter at start
	for field_idx in range(len(aligned_fields)):
		field = aligned_fields[field_idx]
		if type(field) == str:
			# We're at a delimiter

			# Align and write fields since last delimiter, if any
			if field_idx > last_non_delimiter:
				# We have a range of fields which should be aligned to each other
				_write_aligned_fields_range(file, aligned_fields[last_non_delimiter:field_idx], indent)

			# Write this line
			write_line(file, field, indent)

			# Keep updating to field_idx + 1 until we don't have a delimiter
			last_non_delimiter = field_idx + 1

	# If we didn't end with a delimiter, then we might have remaining fields to align
	if len(aligned_fields) > last_non_delimiter:
		_write_aligned_fields_range(file, aligned_fields[last_non_delimiter:len(aligned_fields)], indent)

# DEFINES

# To add something to this list, it needs to be defined 100% of the time.
# This for now means that we cannot emit defines such as IMGUI_HAS_VIEWPORT
# They should also not be ambiguous like IM_COL32_R_SHIFT obviously.
_defines_to_emit = [
	"IMGUI_VERSION",
	"IMGUI_VERSION_NUM",
	"IMGUI_PAYLOAD_TYPE_COLOR_3F",
	"IMGUI_PAYLOAD_TYPE_COLOR_4F",
	"IM_UNICODE_CODEPOINT_INVALID",
	"IM_UNICODE_CODEPOINT_MAX",
	"IM_DRAWLIST_TEX_LINES_WIDTH_MAX",
	"IM_DRAWLIST_ARCFAST_TABLE_SIZE",
]

# Defines which are allowed to be defined in imconfig.h
_allowed_user_defines = [
	# A bug in dear_imgui struct fields causes these two defines to behave incorrectly
	"IMGUI_DISABLE_OBSOLETE_FUNCTIONS",
	# "IMGUI_DISABLE_OBSOLETE_KEYIO",
	"IMGUI_USE_WCHAR32",
]

# Things which are allowed in an #ifdef
_allowed_ifdef = [
	"IMGUI_USE_WCHAR32", # User defined only, bool
	"IM_DRAWLIST_TEX_LINES_WIDTH_MAX", # Overridden by user, int
	"IMGUI_DISABLE_OBSOLETE_FUNCTIONS", # User defined only, bool
	"IMGUI_DISABLE_OBSOLETE_KEYIO", # User defined only, bool
	"IMGUI_DISABLE_DEBUG_TOOLS", # User defined only, bool
	"IMGUI_DISABLE_METRICS_WINDOW", # User defined only, bool
	"IMGUI_OVERRIDE_DRAWVERT_STRUCT_LAYOUT", # User defined only, bool. Indicates custom ImDrawVert struct. Should not be set for Odin purposes
	"ImTextureID", # Concrete type overridden by user. Hard to deal with in Odin, so for now should not be set up by user
	"ImDrawIdx", # Concrete type overridden by user. Hard to deal with in Odin, so for now should not be set up by user
	"ImDrawCallback", # Concrete type overridden by user. Hard to deal with in Odin, so for now should not be set up by user
	# TODO: These were enabled to make imgui_internal.h to work, without thinking very hard about whether this was a good idea
	"IMGUI_ENABLE_TEST_ENGINE",
	"IMGUI_HAS_DOCK",
	"IMGUI_DISABLE_FILE_FUNCTIONS",
	"IMGUI_DISABLE_DEFAULT_FILE_FUNCTIONS",
	"IMGUI_DISABLE_DEFAULT_MATH_FUNCTIONS",
	"IMGUI_ENABLE_SSE",
	"IM_DRAWLIST_ARCFAST_TABLE_SIZE",
	"IMGUI_ENABLE_STB_TRUETYPE",
	"IMGUI_ENABLE_FREETYPE",
]

_define_overrides = {
	"IMGUI_ENABLE_SSE": False,
}

# Defines to process whatsoever
_defines_to_process = []
for define in (_defines_to_emit + _allowed_user_defines + _allowed_ifdef):
	if not define in _defines_to_process: _defines_to_process.append(define)
for define in _define_overrides.keys():
	if not define in _defines_to_process: _defines_to_process.append(define)

# Evaluated define and value
processed_defines = {}

# Checks if define is defined, and make sure that we're allowed to use the define in the first place.
def _ifdef(define: str) -> bool:
	if not define in _allowed_ifdef: die("Not allowed to check define '" + define + "'")
	return define in processed_defines

# Checks #ifdef/#ifndef, which is simple: we can only have a single string define to check, no expressions
def condition_ifdef(condition_str) -> bool:
	return _ifdef(condition_str)

def condition_if(expression_str) -> bool:
	# This is hardcoded for the path where we have [optional !, defined(, some_def, ), optional &&] and repeat
	try:
		while len(expression_str) > 0:
			[expression_str, invert] = _chomp("!", expression_str)
			[expression_str, ok] = _chomp("defined(", expression_str)
			assert ok
			[expression_str, found_str, ok] = _chomp_until(")", expression_str)
			assert ok
			[expression_str, ok] = _chomp(")", expression_str)
			assert ok
			if _ifdef(found_str) == invert: return False
			[expression_str, ok] = _chomp("&&", expression_str)
			if ok: assert len(expression_str) > 0
	except:
		die(f"Failed to parse expression_str: '{expression_str}'")
		return False

def passes_conditionals(thing_with_conditionals) -> bool:
	if not "conditionals" in thing_with_conditionals: return True

	for conditional in thing_with_conditionals["conditionals"]:
		condition_kind = conditional["condition"]
		expression = conditional["expression"]

		if condition_kind == "ifdef":
			if not condition_ifdef(expression): return False
		elif condition_kind == "ifndef":
			if condition_ifdef(expression): return False
		elif condition_kind == "if":
			if not condition_if(expression): return False
		elif condition_kind == "ifnot":
			if condition_if(expression): return False
		else:
			die("Unexpected condition kind: " + condition_kind)
			return False

	return True

_imgui_define_prefixes = ["IMGUI_", "IM_"]

# Defines have special prefixes
def define_strip_prefix(name: str) -> str:
	for prefix in _imgui_define_prefixes:
		if name.startswith(prefix):
			return name.removeprefix(prefix)

	return name

def ingest_and_write_defines(file: typing.IO, defines):
	write_section(file, "Defines")
	aligned = []

	for define in defines:
		define_name = define["name"]
		if not define_name in _defines_to_process: continue

		if define_name in _define_overrides:
			processed_defines[define_name] = _define_overrides[define_name]
		else:
			is_user_define = define["source_location"]["filename"].endswith("imconfig.h")
			if not passes_conditionals(define):
				assert not is_user_define # Why you ifdef-ing in imconfig....
				continue

			if is_user_define and not define_name in _allowed_user_defines:
				die("Disallowed user define '" + define_name + "'")

			if define_name in processed_defines:
				die("Define '" + define_name + "' already defined! This is almost certainly not correct")
			else:
				processed_defines[define_name] = define.get("content", "")

		if define_name in _defines_to_emit:
			append_aligned_field(aligned, [define_strip_prefix(define_name), f' :: {define.get("content", "true")}'], define)

	write_aligned_fields(file, aligned)

# ENUMS
def enum_parse_name(original_name: str) -> typing.List[str]:
	start_idx = -1
	end_idx = -1
	if original_name.startswith("ImGui"): start_idx = 5
	elif original_name.startswith("Im"):  start_idx = 2
	else: assert False, f'Invalid prefix on enum "{original_name}"'

	enum_field_prefix = original_name

	if original_name.endswith("_"):
		end_idx = -1
	else:
		enum_field_prefix += "_"
		end_idx = len(original_name)

	return [enum_field_prefix, original_name[start_idx:end_idx]]

def enum_parse_field_name(field_base_name: str, expected_prefix: str) -> str:
	field_name = strip_prefix_optional(expected_prefix, field_base_name)
	if field_name == None: return field_base_name
	else:                  return field_name

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
	aligned_enums = []
	aligned_flags = []

	for element in enum["elements"]:
		if not passes_conditionals(element): continue

		element_entire_name = element["name"]
		element_value = element["value_expression"]
		element_name = enum_parse_field_name(element_entire_name, enum_field_prefix)
		handled = False # To catch missed cases

		bit_index = strip_prefix_optional("1<<", element_value)
		if bit_index != None:
			# We're definitely something that can be represented with a single bit
			append_aligned_field(aligned_enums, [element_name, f' = {bit_index},'], element)
			handled = True
		else:
			# We're something weird

			# NavRenderCursorFlags_None is used for some argument default values
			# as well as backward-compat names, so let's generate it
			if enum["name"] == "ImGuiNavRenderCursorFlags_":
				if element_value == "0" or element_value == "ImGuiNavRenderCursorFlags_None":
					append_aligned_field(aligned_flags, [f'{name}_{element_name}', f' :: {name}{{}}'], element)
					continue

			if element_value == "0": continue # This is the _None variant, which can be represented in Odin by {}

			if try_eval(element_value) != None:
				extra_comment = f'Meant to be of type {name}'
				append_aligned_field(aligned_flags, [f'{name}_{element_name}', f' :: c.int({element_value}) // {extra_comment}'], element)
				handled = True
			else:
				flag_combination = ",".join(enum_parse_flag_combination(element_value, enum_field_prefix))
				append_aligned_field(aligned_flags, [f'{name}_{element_name}', f' :: {name}{{{flag_combination}}}'], element)
				handled = True

		if not handled:
			print("element_entire_name", element_entire_name)
			print("element_value", element_value)
			print("element_name", element_name)

	# Flags
	write_line_with_comments(file, f'{name} :: bit_set[{name.removesuffix("s")}; c.int]', enum)
	write_line(file, f'{name.removesuffix("s")} :: enum c.int {{')
	write_aligned_fields(file, aligned_enums, 1)
	write_line(file, "}")

	# Combination flags not representable by the above
	write_line(file)
	write_aligned_fields(file, aligned_flags, 0)
	write_line(file)

def write_enum_as_constants(file, enum, enum_field_prefix, name):
	write_line_with_comments(file, f'{name} :: distinct c.int', enum)

	aligned = []

	for element in enum["elements"]:
		if not passes_conditionals(element): continue

		field_base_name = element["name"]
		field_name = enum_parse_field_name(field_base_name, enum_field_prefix)
		field_value = element["value_expression"]

		field_value_evald = try_eval(field_value)
		if field_value_evald != None:
			append_aligned_field(aligned, [f'{name}_{field_name}', f' :: {name}({field_value})'], element)
		else:
			enums = enum_split_value(field_value)
			enums = list(map(lambda s: strip_imgui_branding(s), enums))
			append_aligned_field(aligned, [f'{name}_{field_name}', f' :: {name}({" | ".join(enums)})'], element)

	write_aligned_fields(file, aligned)
	write_line(file)

def write_enum(file: typing.IO, enum, enum_field_prefix: str, name: str):
	write_line_with_comments(file, f'{name} :: enum c.int {{', enum)

	prev_value = -1 # This is a hack as we elide value expressions if our value == prev_value + 1

	aligned = []

	for element in enum["elements"]:
		if not passes_conditionals(element): continue

		assert isinstance(element["value"], int)
		value_is_implicit = element["value"] == prev_value + 1

		field_base_name = element["name"]
		field_name = enum_parse_field_name(field_base_name, enum_field_prefix)
		field_name = make_identifier_valid(field_name)

		if value_is_implicit:
			append_aligned_field(aligned, [f'{field_name},'], element)
		else:
			append_aligned_field(aligned, [f'{field_name} = {element["value"]},'], element)

		prev_value = element["value"]

	write_aligned_fields(file, aligned, 1)
	write_line(file, "}")
	write_line(file)

_imgui_enum_as_constants = [
	# This flag type is initialized from `1` in default args. Which we can't do in Odin
	"ImGuiPopupFlags_",
	# These initialize elements with elements with elements... or whatever.
	# This can be solved by figuring out which of the elements are an actual bitmask
	"ImGuiTableFlags_",
	"ImDrawFlags_",
	"ImGuiHoveredFlags_",
	# This one is special, because it doesn't actually define a single flag of its own...
	# It's also deprecated TODO: seems to be fixed!
	# "ImDrawCornerFlags_",
	# These are made constants as one of their fields are used as default args in procs
	"ImGuiNavHighlightFlags_",
	"ImGuiTypingSelectFlags_",
]

_imgui_enum_skip = [
	# This is both deprecated, and also depends on weirdly scoped enums in `Key`
	"ImGuiModFlags_", # TODO: seems to be fixed!
	# These are skipped only to get an MVP version of imgui_internal.h up..
	"ImGuiDockNodeFlagsPrivate_",
	"ImGuiHoveredFlagsPrivate_",
	"ImGuiButtonFlagsPrivate_",
	"ImGuiInputFlagsPrivate_",
	"ImGuiDataTypePrivate_",
	"ImGuiItemFlagsPrivate_",
	"ImGuiTreeNodeFlagsPrivate_",
	"ImGuiTabItemFlagsPrivate_",
]

def write_enums(file: typing.IO, enums):
	write_section(file, "Enums")
	for enum in enums:
		if not passes_conditionals(enum): continue

		# enum_field_prefix is the prefix expected on each field
		# name is the actual name of the enum
		entire_name = enum["name"]
		[enum_field_prefix, name] = enum_parse_name(entire_name)

		if entire_name in _imgui_enum_skip: continue

		# TODO[TS]: Just use "is_flags_enum"
		if name.endswith("Flags"):
			if entire_name in _imgui_enum_as_constants:
				# The truly cursed path - there's nothing we can do to save these
				write_enum_as_constants(file, enum, enum_field_prefix, name)
			else:
				write_enum_as_flags(file, enum, enum_field_prefix, name)
		else:
			write_enum(file, enum, enum_field_prefix, name)

# STRUCTS

# We can generate these structs just fine, but we have a better Odin equivalent.
_imgui_struct_override = {
	"ImVec2": "Vec2 :: [2]f32",
	"ImVec4": "Vec4 :: [4]f32",
}

# Struct fields which are the same identifier as a type.
# TODO[TS]: This can be fixed properly, by stringifying all the field types,
# then checking that our field name is not in that list.
_imgui_struct_field_name_override = {
	"ID",
	"Rect",
	"Window",
	"DrawData",
	"Font",
	"PlatformImeData",
	"DebugLogFlags",
	"LayoutType",
	"DrawList",
	"DockNode",
}

# These structs are defined properly if imgui_internal is included, but are
# always present in imgui.h as empty structs.
_imgui_struct_skip_if_not_imgui_internal = [
	"ImDrawListSharedData",
	"ImFontBuilderIO",
	"ImGuiContext",
]

def write_structs(file: typing.IO, structs):
	write_section(file, "Structs")
	for struct in structs:
		entire_name = struct["name"]
		if g_has_imgui_internal_and_is_not_in_imgui_internal and entire_name in _imgui_struct_skip_if_not_imgui_internal:
			continue

		if not passes_conditionals(struct): continue

		if entire_name in _imgui_struct_override:
			write_line(file, _imgui_struct_override[entire_name])
			continue

		name = strip_imgui_branding(entire_name)

		write_line_with_comments(file, f'{name} :: struct {{', struct)
		field_components = []
		for field in struct["fields"]:
			if not passes_conditionals(field): continue
			name = field["name"]
			if name in _imgui_struct_field_name_override:
				name = name + "_"
			field_type = parse_type(field["type"])
			append_aligned_field(field_components, [f'{name}: ', f'{field_type},'], field)

		write_aligned_fields(file, field_components, 1)

		write_line(file, "}")
		write_line(file)

# FUNCTIONS
def function_to_string(function, as_type=True) -> str:
	proc_decl = 'proc "c" (' if as_type else "proc("

	argument_list = []
	arguments = function["arguments"]

	for argument_idx in range(len(arguments)):
		argument = arguments[argument_idx]

		argument_type = "no type yet :)"
		argument_is_varargs = argument["is_varargs"]
		argument_name = "no name yet :("
		if "name" in argument:
			argument_name = argument["name"]
		else:
			# We live in a joyous world where arguments don't need to have names
			argument_name = "arg_" + str(argument_idx)

		if argument_is_varargs:
			argument_name = "#c_vararg args"
			argument_type = "..any"
		else:
			argument_name = make_identifier_valid(argument_name)
			argument_type = parse_type(argument["type"], in_function=True)

		default_value = None
		if "default_value" in argument:
			default_value = make_value_odiney(argument["default_value"], argument_type)
			assert not as_type, "Not possible to have default args in type!"

		if default_value: argument_list.append(f'{argument_name}: {argument_type} = {default_value}')
		else:             argument_list.append(f'{argument_name}: {argument_type}')

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
	# Returns ImStr, which isn't defined anywhere?
	# Also has weird #ifdef
	"ImStr_FromCharStr",
]

_imgui_function_prefixes = ["ImGui_", "ImGui", "Im"]

def function_has_default_args(function) -> bool:
	for argument in function["arguments"]:
		if "default_value" in argument:
			return True

	return False

def write_functions(file: typing.IO, functions):
	write_section(file, "Functions")
	write_line(file, '@(default_calling_convention="c")')
	write_line(file, "foreign lib {")

	aligned = []

	for function in functions:
		entire_name = function["name"]

		if entire_name in _imgui_functions_skip: continue
		if not passes_conditionals(function): continue
		if function_uses_va_list(function): continue

		[_prefix, remainder] = strip_list(entire_name, _imgui_function_prefixes)

		aligned_components = []

		aligned_components.append(f'@(link_name="{entire_name}") ')
		aligned_components.append(remainder)
		aligned_components.append(f' :: {function_to_string(function, False)}')
		aligned_components.append(" ---")

		append_aligned_field(aligned, aligned_components, function)

	write_aligned_fields(file, aligned, 1)

	write_line(file, "}")

# TYPEDEFS

_imgui_allowed_typedefs = [
	"ImWchar16",
	"ImWchar32",
	"ImWchar",

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
	"ImGuiSelectionUserData",

	# imgui_internal.h
	"ImGuiTableColumnIdx",
	"ImGuiTableDrawChannelIdx",
	"ImGuiKeyRoutingIndex",
	"ImBitArrayPtr",
	"ImPoolIdx",
	"ImGuiContextHookCallback",
	"ImFileHandle",
	"ImGuiErrorCallback"
]

_imgui_typedef_overrides = {
	"ImWchar32": "rune",
}

def write_typedefs(file: typing.IO, typedefs):
	write_section(file, "Typedefs")
	aligned = []

	for typedef in typedefs:
		if not passes_conditionals(typedef): continue

		entire_name = typedef["name"]

		if entire_name in _imgui_typedef_overrides:
			append_aligned_field(aligned, [strip_imgui_branding(entire_name), f' :: {_imgui_typedef_overrides[entire_name]}'], typedef)
			continue

		if not entire_name in _imgui_allowed_typedefs: continue
		append_aligned_field(aligned, [strip_imgui_branding(entire_name), f' :: {parse_type(typedef["type"])}'], typedef)

	write_aligned_fields(file, aligned)

def main():
	if not sys.version.startswith("3.11.5"):
		print("", file=sys.stderr)
		print(f"Warning: odin-imgui has been tested against Python version 3.11.5. (Yours: {sys.version})", file=sys.stderr)
		print("The script will still likely work, but it is untested!", file=sys.stderr)
		print("", file=sys.stderr)

	parser = argparse.ArgumentParser()

	parser.add_argument("--imgui", required=True, help="The dear_bindings json file for imgui.h")
	parser.add_argument("--imconfig", required=True, help="The dear_bindings json file for imconfig.h")
	parser.add_argument("--imgui_internal", help="The dear_bindings json file for imgui_internal.h")

	args = parser.parse_args()

	has_imgui_internal = bool(args.imgui_internal)

	global g_has_imgui_internal_and_is_not_in_imgui_internal
	g_has_imgui_internal_and_is_not_in_imgui_internal = has_imgui_internal

	# Read imconfig. Should be only defines
	imconfig_info = json.load(open(args.imconfig))
	imconfig_file = open("imconfig.odin", "w+")
	write_global_header(imconfig_file)
	ingest_and_write_defines(imconfig_file, imconfig_info["defines"])
	assert len(imconfig_info["enums"]) == 0
	assert len(imconfig_info["structs"]) == 0
	assert len(imconfig_info["functions"]) == 0
	assert len(imconfig_info["typedefs"]) == 0

	# Read main imgui file
	imgui_info = json.load(open(args.imgui))
	imgui_file = open("imgui.odin", "w+")
	write_global_header(imgui_file)
	write_import_header(imgui_file)
	write_main_file_header(imgui_file)
	ingest_and_write_defines(imgui_file, imgui_info["defines"])
	write_enums(imgui_file, imgui_info["enums"])
	write_structs(imgui_file, imgui_info["structs"])
	write_functions(imgui_file, imgui_info["functions"])
	write_typedefs(imgui_file, imgui_info["typedefs"])

	# Read imgui_internal file, if present.
	if has_imgui_internal:
		g_has_imgui_internal_and_is_not_in_imgui_internal = False
		imgui_internal_info = json.load(open(args.imgui_internal))
		imgui_internal_file = open("imgui_internal.odin", "w+")
		write_global_header(imgui_internal_file)
		write_import_header_internal(imgui_internal_file)
		ingest_and_write_defines(imgui_internal_file, imgui_internal_info["defines"])
		write_enums(imgui_internal_file, imgui_internal_info["enums"])
		write_structs(imgui_internal_file, imgui_internal_info["structs"])
		write_functions(imgui_internal_file, imgui_internal_info["functions"])
		write_typedefs(imgui_internal_file, imgui_internal_info["typedefs"])

if __name__ == "__main__": main()
