package imgui

import "core:c"

import vk "vendor:vulkan"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

// imgui_impl_vulkan.h
// Last checked 357f752
ImGui_ImplVulkan_InitInfo :: struct {
	Instance:        vk.Instance,
	PhysicalDevice:  vk.PhysicalDevice,
	Device:          vk.Device,
	QueueFamily:     u32,
	Queue:           vk.Queue,
	PipelineCache:   vk.PipelineCache,
	DescriptorPool:  vk.DescriptorPool,
	Subpass:         u32,
	MinImageCount:   u32,                 // >= 2
	ImageCount:      u32,                 // >= MinImageCount
	MSAASamples:     vk.SampleCountFlags, // >= VK_SAMPLE_COUNT_1_BIT (0 -> default to VK_SAMPLE_COUNT_1_BIT)

	// Dynamic Rendering (Optional)
	UseDynamicRendering:   c.bool,    // Need to explicitly enable VK_KHR_dynamic_rendering extension to use this, even for Vulkan 1.3.
	ColorAttachmentFormat: vk.Format, // Required for dynamic rendering

	// Allocation, Debugging
	Allocator:       ^vk.AllocationCallbacks,
	CheckVkResultFn: proc "c" (err: vk.Result),
}

foreign lib {
	// Called by user code
	ImGui_ImplVulkan_Init                     :: proc(info: ^ImGui_ImplVulkan_InitInfo, render_pass: vk.RenderPass) -> c.bool ---
	ImGui_ImplVulkan_Shutdown                 :: proc() ---
	ImGui_ImplVulkan_NewFrame                 :: proc() ---
	ImGui_ImplVulkan_RenderDrawData           :: proc(draw_data: ^DrawData, command_buffer: vk.CommandBuffer, pipeline: vk.Pipeline = {}) ---
	ImGui_ImplVulkan_CreateFontsTexture       :: proc(command_buffer: vk.CommandBuffer) -> bool ---
	ImGui_ImplVulkan_DestroyFontUploadObjects :: proc() ---
	ImGui_ImplVulkan_SetMinImageCount         :: proc(min_image_count: u32) --- // To override MinImageCount after initialization (e.g. if swap chain is recreated)

	ImGui_ImplVulkan_LoadFunctions :: proc(loader_func: proc "c" (function_name: cstring, user_data: rawptr) -> vk.ProcVoidFunction, user_data: rawptr = nil) -> c.bool ---
}

// There are some more Vulkan functions/structs, but they aren't necessary
