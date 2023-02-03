# Odin ImGui - Generated ImGui using dear_bindings

## Usage
Simply import, a version of the bindings + lib are already comitted.

## Building

 1. Get imgui.h from [Dear ImGui](https://github.com/ocornut/imgui), and [dear_bindings](https://github.com/dearimgui/dear_bindings)
 2. Generate JSON data for `imgui.h`:
    - Example: `python dear_bindings.py -o c_imgui imgui/imgui.h`
        - This generates `c_imgui.[json|h|cpp]`
        - See dear_bindings project for more info
 3. Generate Odin from `c_imgui.json`:
    - Example: `python gen_odin.py c_imgui.json imgui/imgui.odin`
 4. Compile ImGui bindings C code:
    - Put `c_imgui.h, c_imgui.cpp` in your Dear ImGui folder
    - Compile ImGui alongside the C bindings:
```
set sources=imgui_demo.cpp imgui_draw.cpp imgui_tables.cpp imgui_widgets.cpp imgui.cpp c_imgui.cpp
set objects=imgui_demo.obj imgui_draw.obj imgui_tables.obj imgui_widgets.obj imgui.obj c_imgui.obj

del imgui.lib
cl /c %sources%
lib %objects%
del %objects%
```