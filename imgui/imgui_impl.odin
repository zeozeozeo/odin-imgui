package imgui

import "core:c"

import sdl "vendor:sdl2"
import vk "vendor:vulkan"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

when BACKEND_SDL2_ENABLED {
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
}

when BACKEND_OPENGL3_ENABLED {
	// imgui_impl_opengl3.h
	// Last checked 357f752
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
}

when BACKEND_VULKAN_ENABLED {
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
}
