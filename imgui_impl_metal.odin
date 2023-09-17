// +build darwin
package imgui

import "core:c"

import mtl "vendor:darwin/Metal"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

// imgui_impl_metal.h
// Last checked 33e13c8
foreign lib {
	ImGui_ImplMetal_Init           :: proc(device: ^mtl.Device) -> c.bool ---
	ImGui_ImplMetal_Shutdown       :: proc() ---
	ImGui_ImplMetal_NewFrame       :: proc(renderPassDescriptor: ^mtl.RenderPassDescriptor) ---
	ImGui_ImplMetal_RenderDrawData :: proc(draw_data: ^DrawData,
										   commandBuffer: ^mtl.CommandBuffer,
										   commandEncoder: ^mtl.RenderCommandEncoder) ---

	// Called by Init/NewFrame/Shutdown
	ImGui_ImplMetal_CreateFontsTexture   :: proc(device: ^mtl.Device) -> c.bool ---
	ImGui_ImplMetal_DestroyFontsTexture  :: proc() ---
	ImGui_ImplMetal_CreateDeviceObjects  :: proc(device: ^mtl.Device) -> c.bool ---
	ImGui_ImplMetal_DestroyDeviceObjects :: proc() ---
}
