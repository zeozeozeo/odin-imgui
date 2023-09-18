// +build darwin
package imgui

import "core:c"

when      ODIN_OS == .Windows do foreign import lib "imgui_windows_x64.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui_linux_x64.a"
else when ODIN_OS == .Darwin {
	when ODIN_ARCH == .amd64 { foreign import lib "imgui_darwin_x64.a" } else { foreign import lib "imgui_darwin_arm64.a" }
}

// imgui_impl_osx.h
// Last checked 357f752b
foreign lib {
	ImGui_ImplOSX_Init     :: proc(view: rawptr) -> bool ---
	ImGui_ImplOSX_Shutdown :: proc() ---
	ImGui_ImplOSX_NewFrame :: proc(view: rawptr) ---
}
