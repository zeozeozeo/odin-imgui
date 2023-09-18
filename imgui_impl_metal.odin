// +build darwin
package imgui

import "core:c"

import mtl "vendor:darwin/Metal"

when      ODIN_OS == .Windows do foreign import lib "imgui_windows_x64.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui_linux_x64.a"
else when ODIN_OS == .Darwin {
	when ODIN_ARCH == .amd64 { foreign import lib "imgui_darwin_x64.a" } else { foreign import lib "imgui_darwin_arm64.a" }
}

// imgui_impl_metal.h
// Last checked 357f752b
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
