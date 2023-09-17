// +build windows
package imgui

import "core:c"

import "vendor:directx/d3d11"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

// imgui_impl_dx11.h
// Last checked 357f752b
foreign lib {
	ImGui_ImplDX11_Init           :: proc(device: ^d3d11.IDevice, device_context: ^d3d11.IDeviceContext) -> c.bool ---
	ImGui_ImplDX11_Shutdown       :: proc() ---
	ImGui_ImplDX11_NewFrame       :: proc() ---
	ImGui_ImplDX11_RenderDrawData :: proc(draw_data: ^DrawData) ---

	// Use if you want to reset your rendering device without losing Dear ImGui state.
	ImGui_ImplDX11_InvalidateDeviceObjects :: proc() ---
	ImGui_ImplDX11_CreateDeviceObjects     :: proc() -> c.bool ---
}
