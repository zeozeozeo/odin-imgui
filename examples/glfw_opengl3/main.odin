package imgui_example_glfw_opengl3

// This is an example of using the bindings with GLFW and OpenGL 3.
// For a more complete example with comments, see:
// https://github.com/ocornut/imgui/blob/docking/examples/example_glfw_opengl3/main.cpp

import "../../imgui/"

import "vendor:glfw"
import gl "vendor:OpenGL"

main :: proc() {
	assert(glfw.Init() != 0)
	defer glfw.Terminate()

	window := glfw.CreateWindow(1280, 720, "Dear ImGui GLFW+OpenGL3 example", nil, nil)
	assert(window != nil)
	defer glfw.DestroyWindow(window)

	glfw.MakeContextCurrent(window)
	glfw.SwapInterval(1) // vsync

	gl.load_up_to(3, 3, proc(p: rawptr, name: cstring) {
		(cast(^rawptr)p)^ = glfw.GetProcAddress(name)
	})

	imgui.CHECKVERSION()
	imgui.CreateContext(nil)
	defer imgui.DestroyContext(nil)
	io := imgui.GetIO()
	io.ConfigFlags += {.NavEnableKeyboard, .NavEnableGamepad}
	when imgui.IMGUI_BRANCH == "docking" {
		io.ConfigFlags += {.DockingEnable}
		io.ConfigFlags += {.ViewportsEnable}

		style := imgui.GetStyle()
		style.WindowRounding = 0
		style.Colors[imgui.Col.WindowBg].w = 1
	}

	imgui.StyleColorsDark(nil)

	imgui.ImGui_ImplGlfw_InitForOpenGL(window, true)
	defer imgui.ImGui_ImplGlfw_Shutdown()
	imgui.ImGui_ImplOpenGL3_Init("#version 150")
	defer imgui.ImGui_ImplOpenGL3_Shutdown()

	for !glfw.WindowShouldClose(window) {
		glfw.PollEvents()

		imgui.ImGui_ImplOpenGL3_NewFrame()
		imgui.ImGui_ImplGlfw_NewFrame()
		imgui.NewFrame()

		imgui.ShowDemoWindow(nil)

		if imgui.Begin("Window containing a quit button", nil, {}) {
			if imgui.Button("The quit button in question") {
				glfw.SetWindowShouldClose(window, true)
			}
		}
		imgui.End()

		imgui.Render()
		display_w, display_h := glfw.GetFramebufferSize(window)
		gl.Viewport(0, 0, display_w, display_h)
		gl.ClearColor(0, 0, 0, 1)
		gl.Clear(gl.COLOR_BUFFER_BIT)
		imgui.ImGui_ImplOpenGL3_RenderDrawData(imgui.GetDrawData())

		when imgui.IMGUI_BRANCH == "docking" {
			backup_current_window := glfw.GetCurrentContext()
			imgui.UpdatePlatformWindows()
			imgui.RenderPlatformWindowsDefault()
			glfw.MakeContextCurrent(backup_current_window)
		}

		glfw.SwapBuffers(window)
	}
}
