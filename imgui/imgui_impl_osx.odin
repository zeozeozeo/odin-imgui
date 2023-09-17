// +build darwin
package imgui

import "core:c"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

// imgui_impl_osx.h
// Last checked 357f752b
foreign lib {
	ImGui_ImplOSX_Init     :: proc(view: rawptr) -> bool ---
	ImGui_ImplOSX_Shutdown :: proc() ---
	ImGui_ImplOSX_NewFrame :: proc(view: rawptr) ---
}
