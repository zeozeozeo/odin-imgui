package imgui_impl

// While this should work fine, the build steps are WIP and not documented!
// Check build_everything.bat for a lead on how to get this working.
// This being said, if what you need exists in this file, then the precompiled .lib should include all you need already!

import "core:c"

import sdl "vendor:sdl2"
import vk "vendor:vulkan"

import imgui "../"

when      ODIN_OS == .Windows do foreign import lib "../imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "../imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "../imgui.a"

// imgui_impl_sdl2.h
foreign lib {
	ImGui_ImplSDL2_InitForOpenGL      :: proc(window: ^sdl.Window, sdl_gl_context: rawptr) -> c.bool ---
	ImGui_ImplSDL2_InitForVulkan      :: proc(window: ^sdl.Window) -> c.bool ---
	ImGui_ImplSDL2_InitForD3D         :: proc(window: ^sdl.Window) -> c.bool ---
	ImGui_ImplSDL2_InitForMetal       :: proc(window: ^sdl.Window) -> c.bool ---
	ImGui_ImplSDL2_InitForSDLRenderer :: proc(window: ^sdl.Window, renderer: ^sdl.Renderer) -> c.bool ---
	ImGui_ImplSDL2_Shutdown           :: proc() ---
	ImGui_ImplSDL2_NewFrame           :: proc() ---
	ImGui_ImplSDL2_ProcessEvent       :: proc(event: ^sdl.Event) -> c.bool ---
}

// imgui_impl_opengl3.h
foreign lib {
	ImGui_ImplOpenGL3_Init           :: proc(glsl_version: cstring /*=nullptr*/) -> c.bool ---
	ImGui_ImplOpenGL3_Shutdown       :: proc() ---
	ImGui_ImplOpenGL3_NewFrame       :: proc() ---
	ImGui_ImplOpenGL3_RenderDrawData :: proc(draw_data: ^imgui.DrawData) ---
	// (Optional) Called by Init/NewFrame/Shutdown
	ImGui_ImplOpenGL3_CreateFontsTexture   :: proc() -> c.bool ---
	ImGui_ImplOpenGL3_DestroyFontsTexture  :: proc() ---
	ImGui_ImplOpenGL3_CreateDeviceObjects  :: proc() -> c.bool ---
	ImGui_ImplOpenGL3_DestroyDeviceObjects :: proc() ---
}

// imgui_impl_vulkan.h
ImGui_ImplVulkan_InitInfo :: struct {
	Instance:        vk.Instance,
	PhysicalDevice:  vk.PhysicalDevice,
	Device:          vk.Device,
	QueueFamily:     u32,
	Queue:           vk.Queue,
	PipelineCache:   vk.PipelineCache,
	DescriptorPool:  vk.DescriptorPool,
	Subpass:         u32,
	MinImageCount:   u32,
	ImageCount:      u32,
	MSAASamples:     vk.SampleCountFlags,
	Allocator:       ^vk.AllocationCallbacks,
	CheckVkResultFn: proc "c" (err: vk.Result),
}

foreign lib {
	ImGui_ImplVulkan_Init                     :: proc(info: ^ImGui_ImplVulkan_InitInfo, render_pass: vk.RenderPass) -> bool ---
	ImGui_ImplVulkan_Shutdown                 :: proc() ---
	ImGui_ImplVulkan_NewFrame                 :: proc() ---
	ImGui_ImplVulkan_RenderDrawData           :: proc(draw_data: ^imgui.DrawData, command_buffer: vk.CommandBuffer, pipeline: vk.Pipeline = {}) ---
	ImGui_ImplVulkan_CreateFontsTexture       :: proc(command_buffer: vk.CommandBuffer) -> bool ---
	ImGui_ImplVulkan_DestroyFontUploadObjects :: proc() ---
	ImGui_ImplVulkan_SetMinImageCount         :: proc(min_image_count: u32) --- // To override MinImageCount after initialization (e.g. if swap chain is recreated)

	ImGui_ImplVulkan_LoadFunctions :: proc(loader_func: proc "c" (function_name: cstring, user_data: rawptr) -> vk.ProcVoidFunction, user_data: rawptr = nil) -> c.bool ---
}

// There are some more Vulkan functions/structs, but they aren't necessary
