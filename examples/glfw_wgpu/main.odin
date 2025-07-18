package imgui_example_glfw_wgpu

// This is an example of using the bindings with GLFW and WebGPU.

import im "../.."
import "../../imgui_impl_glfw"
import "../../imgui_impl_wgpu"

import "base:runtime"

import "core:fmt"
import "core:os"
import "core:math/linalg"

import "vendor:glfw"
import "vendor:wgpu"
import "vendor:wgpu/glfwglue"

ctx:      runtime.Context
window:   glfw.WindowHandle
instance: wgpu.Instance
adapter:  wgpu.Adapter
device:   wgpu.Device
surface:  wgpu.Surface
queue:    wgpu.Queue
config:   wgpu.SurfaceConfiguration

main :: proc() {
	ctx = context

	assert(glfw.Init() == true)
	defer glfw.Terminate()

	glfw.WindowHint(glfw.CLIENT_API, glfw.NO_API)
	window = glfw.CreateWindow(1280, 720, "Dear ImGui GLFW+WebGPU example", nil, nil)
	assert(window != nil)
	defer glfw.DestroyWindow(window)

	im.CHECKVERSION()
	im.CreateContext()
	defer im.DestroyContext()
	io := im.GetIO()
	io.ConfigFlags += { .NavEnableKeyboard, .NavEnableGamepad }

	im.StyleColorsDark()

	assert(imgui_impl_glfw.InitForOther(window, true))
	defer imgui_impl_glfw.Shutdown()

	instance = wgpu.CreateInstance()
	defer wgpu.InstanceRelease(instance)

	wgpu.InstanceRequestAdapter(instance, nil, { callback = on_adapter })
	defer wgpu.AdapterRelease(adapter)
	defer wgpu.DeviceRelease(device)
	defer wgpu.SurfaceRelease(surface)
	defer wgpu.QueueRelease(queue)

	defer imgui_impl_wgpu.Shutdown()

	for !glfw.WindowShouldClose(window) {
		glfw.PollEvents()

		if device == nil {
			continue
		}

		imgui_impl_glfw.NewFrame()

		sz := linalg.to_u32(io.DisplaySize * io.DisplayFramebufferScale)
		if sz != ([2]u32{config.width, config.height}) {
			config.width  = sz.x
			config.height = sz.y
			wgpu.SurfaceConfigure(surface, &config)
		}

		imgui_impl_wgpu.NewFrame()
		im.NewFrame()

		im.ShowDemoWindow()

		if im.Begin("Window containing a quit button") {
			if im.Button("The quit button in question") {
				glfw.SetWindowShouldClose(window, true)
			}
		}
		im.End()

		im.Render()

		surface_texture := wgpu.SurfaceGetCurrentTexture(surface)
		defer wgpu.TextureRelease(surface_texture.texture)

		surface_view := wgpu.TextureCreateView(surface_texture.texture)
		defer wgpu.TextureViewRelease(surface_view)

		encoder := wgpu.DeviceCreateCommandEncoder(device)
		defer wgpu.CommandEncoderRelease(encoder)

		pass := wgpu.CommandEncoderBeginRenderPass(encoder, &{
			colorAttachmentCount = 1,
			colorAttachments     = &wgpu.RenderPassColorAttachment{
				view       = surface_view,
				loadOp     = .Clear,
				storeOp    = .Store,
				clearValue = { 0, 0, 0, 1 },
			},
		})
		defer wgpu.RenderPassEncoderRelease(pass)

		imgui_impl_wgpu.RenderDrawData(im.GetDrawData(), pass)
		wgpu.RenderPassEncoderEnd(pass)

		cmd_buffer := wgpu.CommandEncoderFinish(encoder)
		defer wgpu.CommandBufferRelease(cmd_buffer)

		wgpu.QueueSubmit(queue, { cmd_buffer })

		wgpu.SurfacePresent(surface)
	}
}

on_adapter :: proc "c" (status: wgpu.RequestAdapterStatus, the_adapter: wgpu.Adapter, msg: string, user, _: rawptr) {
	context = ctx
	if status == .Success {
		adapter = the_adapter
		assert(adapter != nil)
		wgpu.AdapterRequestDevice(adapter, nil, { callback = on_device })
	} else {
		fmt.eprintfln("Could not get WebGPU adapter: %v: %v", status, msg)
		os.exit(1)
	}
}

on_device :: proc "c" (status: wgpu.RequestDeviceStatus, the_device: wgpu.Device, msg: string, user, _: rawptr) {
	context = ctx
	if status == .Success {
		device = the_device
	} else {
		fmt.eprintfln("Could not get WebGPU device: %v: %v", status, msg)
		os.exit(1)
	}

	assert(device != nil)

	surface = glfwglue.GetSurface(instance, window)

	queue = wgpu.DeviceGetQueue(device)

	surface_capabilities, _ := wgpu.SurfaceGetCapabilities(surface, adapter)
	assert(surface_capabilities.formatCount >= 1)
	// The first present mode is the preferred one
	preferred_surface_format := surface_capabilities.formats[0]

	config  = {
		device      = device,
		format      = preferred_surface_format,
		usage       = { .RenderAttachment },
		alphaMode   = .Opaque,
		presentMode = .Fifo,
	}

	init_info := imgui_impl_wgpu.INIT_INFO_DEFAULT
	init_info.Device = device
	init_info.NumFramesInFlight = 3
	init_info.RenderTargetFormat = preferred_surface_format

	imgui_impl_wgpu.Init(init_info)
}
