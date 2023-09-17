package imgui

import "core:c"

import sdl "vendor:sdl2"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

// imgui_impl_sdlrenderer2.h
// Last checked f8f805f
foreign lib {
	ImGui_ImplSDLRenderer2_Init           :: proc(renderer: ^sdl.Renderer) -> c.bool ---
	ImGui_ImplSDLRenderer2_Shutdown       :: proc() ---
	ImGui_ImplSDLRenderer2_NewFrame       :: proc() ---
	ImGui_ImplSDLRenderer2_RenderDrawData :: proc(draw_data: ^DrawData) ---

	// Called by Init/NewFrame/Shutdown
	ImGui_ImplSDLRenderer2_CreateFontsTexture   :: proc() -> c.bool ---
	ImGui_ImplSDLRenderer2_DestroyFontsTexture  :: proc() ---
	ImGui_ImplSDLRenderer2_CreateDeviceObjects  :: proc() -> c.bool ---
	ImGui_ImplSDLRenderer2_DestroyDeviceObjects :: proc() ---
}
