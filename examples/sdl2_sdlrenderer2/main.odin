package imgui_example_sdl2_sdlrenderer2

// This is an example of using the bindings with SDL2 and SDL_Renderer
// For a more complete example with comments, see:
// https://github.com/ocornut/imgui/blob/docking/examples/example_sdl2_sdlrenderer2/main.cpp

USE_DOCKING_AND_VIEWPORTS :: true

import "../../imgui/"

import sdl "vendor:sdl2"
// Required for SDL_RenderGeometryRaw()
#assert(sdl.MAJOR_VERSION >= 2)
#assert(sdl.MINOR_VERSION >= 0)
#assert(sdl.PATCHLEVEL >= 18)

main :: proc() {
	assert(sdl.Init(sdl.INIT_EVERYTHING) == 0)
	defer sdl.Quit()

	window := sdl.CreateWindow(
		"Dear ImGui SDL2+SDL_Renderer example",
		sdl.WINDOWPOS_CENTERED,
		sdl.WINDOWPOS_CENTERED,
		1280, 720,
		{.RESIZABLE, .ALLOW_HIGHDPI})
	assert(window != nil)
	defer sdl.DestroyWindow(window)

	renderer := sdl.CreateRenderer(window, -1, {.PRESENTVSYNC, .ACCELERATED})
	assert(renderer != nil)
	defer sdl.DestroyRenderer(renderer)

	imgui.CHECKVERSION()
	imgui.CreateContext(nil)
	defer imgui.DestroyContext(nil)
	io := imgui.GetIO()
	io.ConfigFlags += {.NavEnableKeyboard, .NavEnableGamepad}

	imgui.StyleColorsDark(nil)

	imgui.ImGui_ImplSDL2_InitForSDLRenderer(window, renderer)
	defer imgui.ImGui_ImplSDL2_Shutdown()
	imgui.ImGui_ImplSDLRenderer2_Init(renderer)
	defer imgui.ImGui_ImplSDLRenderer2_Shutdown()

	running := true
	for running {
		e: sdl.Event
		for sdl.PollEvent(&e) {
			imgui.ImGui_ImplSDL2_ProcessEvent(&e)

			#partial switch e.type {
			case .QUIT: running = false
			}
		}

		imgui.ImGui_ImplSDLRenderer2_NewFrame()
		imgui.ImGui_ImplSDL2_NewFrame()
		imgui.NewFrame()

		imgui.ShowDemoWindow(nil)

		if imgui.Begin("Window containing a quit button", nil, {}) {
			if imgui.Button("The quit button in question") {
				running = false
			}
		}
		imgui.End()

		imgui.Render()
		sdl.RenderSetScale(renderer, io.DisplayFramebufferScale.x, io.DisplayFramebufferScale.y)
		sdl.SetRenderDrawColor(renderer, 0, 0, 0, 255)
		sdl.RenderClear(renderer)
		imgui.ImGui_ImplOpenGL3_RenderDrawData(imgui.GetDrawData())
		sdl.RenderPresent(renderer)
	}
}
