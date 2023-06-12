@rem This is neither robust nor properly documented, but is what I use to compile backends.
@rem You'll have to clone a few repositories (vulkan-headers, sdl2, maybe more) into ../backend_deps for this
@rem to work.

if not exist imgui.cpp (
	echo Move this file to within the imgui repository!
	pause
	exit /b 1
)

call vcvarsall x64

@rem Add your wanted backend sources here
set backend_sources=backends/imgui_impl_sdl2.cpp backends/imgui_impl_opengl3.cpp backends/imgui_impl_vulkan.cpp
set backend_objects=imgui_impl_sdl2.obj imgui_impl_opengl3.obj imgui_impl_vulkan.obj

set imgui_sources=imgui.cpp imgui_demo.cpp imgui_draw.cpp imgui_tables.cpp imgui_widgets.cpp c_imgui.cpp
set imgui_objects=imgui.obj imgui_demo.obj imgui_draw.obj imgui_tables.obj imgui_widgets.obj c_imgui.obj

set sources=%imgui_sources% %backend_sources%
set objects=%imgui_objects% %backend_objects%

@rem Your backend might need some additional includes. Add them here
@rem Note that VK_NO_PROTOTYPES is probably required for Vulkan, as Odin's Vulkan package doesn't actually link against vulkan1.dll
set compile_flags=/O2 /I. /I../backend_deps/SDL/include /I../backend_deps/Vulkan-Headers/include /DIMGUI_IMPL_API="extern \"C\"" /DVK_NO_PROTOTYPES
set lib_file=imgui.lib

del %lib_file%
cl /c %sources% %compile_flags%
lib /out:%lib_file% %objects%
del %objects%

set imgui_lib_dest=..\odin-imgui\imgui.lib

if exist "%imgui_lib_dest%" (
	del "%imgui_lib_dest%"
)

move "%lib_file%" "%imgui_lib_dest%"

pause
