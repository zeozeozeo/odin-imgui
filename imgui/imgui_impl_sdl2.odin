package imgui

import "core:c"

import sdl "vendor:sdl2"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

// imgui_impl_sdl2.h
// Last checked 357f752
foreign lib {
	ImGui_ImplSDL2_InitForOpenGL      :: proc(window: ^sdl.Window, sdl_gl_context: rawptr) -> c.bool ---
	ImGui_ImplSDL2_InitForVulkan      :: proc(window: ^sdl.Window) -> c.bool ---
	ImGui_ImplSDL2_InitForD3D         :: proc(window: ^sdl.Window) -> c.bool ---
	ImGui_ImplSDL2_InitForMetal       :: proc(window: ^sdl.Window) -> c.bool ---
	ImGui_ImplSDL2_InitForSDLRenderer :: proc(window: ^sdl.Window, renderer: ^sdl.Renderer) -> c.bool ---
	ImGui_ImplSDL2_InitForOther       :: proc(window: ^sdl.Window) -> c.bool ---
	ImGui_ImplSDL2_Shutdown           :: proc() ---
	ImGui_ImplSDL2_NewFrame           :: proc() ---
	ImGui_ImplSDL2_ProcessEvent       :: proc(event: ^sdl.Event) -> c.bool ---
}

// ImGui_ImplSDL2_NewFrame is elided as it is obsolete.
// Delete this when it's removed from dear imgui.
