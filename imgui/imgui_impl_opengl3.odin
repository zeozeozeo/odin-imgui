package imgui

import "core:c"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

// imgui_impl_opengl3.h
// Last checked 357f752b
foreign lib {
	// Backend API
	ImGui_ImplOpenGL3_Init           :: proc(glsl_version: cstring /*=nullptr*/) -> c.bool ---
	ImGui_ImplOpenGL3_Shutdown       :: proc() ---
	ImGui_ImplOpenGL3_NewFrame       :: proc() ---
	ImGui_ImplOpenGL3_RenderDrawData :: proc(draw_data: ^DrawData) ---

	// (Optional) Called by Init/NewFrame/Shutdown
	ImGui_ImplOpenGL3_CreateFontsTexture   :: proc() -> c.bool ---
	ImGui_ImplOpenGL3_DestroyFontsTexture  :: proc() ---
	ImGui_ImplOpenGL3_CreateDeviceObjects  :: proc() -> c.bool ---
	ImGui_ImplOpenGL3_DestroyDeviceObjects :: proc() ---
}
