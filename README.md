# Odin ImGui - Generated ImGui using dear_bindings

## Usage
Simply import, a version of the bindings + lib are already comitted. (Windows only for now)

## Building

 1. Clone [Dear ImGui](https://github.com/ocornut/imgui), and [dear_bindings](https://github.com/dearimgui/dear_bindings)
 2. Generate JSON data for `imgui.h`:
	- Note that `dear_bindings` requires [PLY](https://www.dabeaz.com/ply/). You can install it with `python -m pip install ply`
	- Example: `python dear_bindings.py -o c_imgui imgui/imgui.h`
		- This generates `c_imgui.[json|h|cpp]`
		- See dear_bindings project for more info
 3. Generate Odin from `c_imgui.json`:
	- Example: `python gen_odin.py c_imgui.json imgui/imgui.odin`
 4. Compile ImGui bindings C code:
	- Put `c_imgui.h, c_imgui.cpp` in your Dear ImGui folder
	- Compile ImGui alongside the C bindings.
	- Replace the `imgui.lib` (or platform equivalent) with your compiled file.

## Example script for generating sources:
```sh
#!/bin/bash

# Uncomment for initial setup
# git clone https://gitlab.com/L-4/odin-imgui.git
# git clone https://github.com/ocornut/imgui.git
# git clone https://github.com/dearimgui/dear_bindings.git

# Delete remaining files from potential old build
rm -f c_imgui.*
# Generate C imgui wrapper and reflection data
python dear_bindings/dear_bindings.py -o c_imgui imgui/imgui.h
# Use reflection data to generate Odin bindings for C wrapper
python odin-imgui/gen_odin.py c_imgui.json odin-imgui/imgui.odin
# Remove c_imgui sources from imgui in case they were there before
rm -f imgui/c_imgui.h imgui/c_imgui.cpp
# Move c_imgui sources to imgui
mv c_imgui.cpp imgui/
mv c_imgui.h imgui/
```

## Example script for compiling imgui wrapper
```bat
set sources=imgui.cpp imgui_demo.cpp imgui_draw.cpp imgui_tables.cpp imgui_widgets.cpp c_imgui.cpp
set objects=imgui.obj imgui_demo.obj imgui_draw.obj imgui_tables.obj imgui_widgets.obj c_imgui.obj
set compile_flags=/O2

del imgui.lib
cl /c %sources% %compile_flags%
lib %objects%
del %objects%
```
