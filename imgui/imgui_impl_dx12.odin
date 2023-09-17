// +build windows
package imgui

import "core:c"

import "vendor:directx/d3d12"
import "vendor:directx/dxgi"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

// imgui_impl_dx12.h
// Last checked 357f752b
foreign lib {
	// cmd_list is the command list that the implementation will use to render imgui draw lists.
	// Before calling the render function, caller must prepare cmd_list by resetting it and setting the appropriate
	// render target and descriptor heap that contains font_srv_cpu_desc_handle/font_srv_gpu_desc_handle.
	// font_srv_cpu_desc_handle and font_srv_gpu_desc_handle are handles to a single SRV descriptor to use for the internal font texture.
	ImGui_ImplDX12_Init :: proc(device: ^d3d12.IDevice, num_frames_in_flight: c.int, rtv_format: dxgi.FORMAT, cbv_srv_heap: ^d3d12.IDescriptorHeap,
		font_srv_cpu_desc_handle: d3d12.CPU_DESCRIPTOR_HANDLE, font_srv_gpu_desc_handle: d3d12.GPU_DESCRIPTOR_HANDLE) -> c.bool ---
	ImGui_ImplDX12_Shutdown       :: proc() ---
	ImGui_ImplDX12_NewFrame       :: proc() ---
	ImGui_ImplDX12_RenderDrawData :: proc(draw_data: ^DrawData, graphics_command_list: ^d3d12.IGraphicsCommandList) ---

	// Use if you want to reset your rendering device without losing Dear ImGui state.
	ImGui_ImplDX12_InvalidateDeviceObjects :: proc() ---
	ImGui_ImplDX12_CreateDeviceObjects     :: proc() -> c.bool ---
}
