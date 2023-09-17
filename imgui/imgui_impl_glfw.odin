package imgui

import "core:c"

import "vendor:glfw"

when      ODIN_OS == .Windows do foreign import lib "imgui.lib"
else when ODIN_OS == .Linux   do foreign import lib "imgui.a"
else when ODIN_OS == .Darwin  do foreign import lib "imgui.a"

// imgui_impl_glfw.h
// Last checked f8f805f
foreign lib {
	ImGui_ImplGlfw_InitForOpenGL :: proc(window: glfw.WindowHandle, install_callbacks: c.bool) -> c.bool ---
	ImGui_ImplGlfw_InitForVulkan :: proc(window: glfw.WindowHandle, install_callbacks: c.bool) -> c.bool ---
	ImGui_ImplGlfw_InitForOther  :: proc(window: glfw.WindowHandle, install_callbacks: c.bool) -> c.bool ---
	ImGui_ImplGlfw_Shutdown      :: proc() ---
	ImGui_ImplGlfw_NewFrame      :: proc() ---

	// GLFW callbacks install
	// - When calling Init with 'install_callbacks=true': ImGui_ImplGlfw_InstallCallbacks() is called. GLFW callbacks will be installed for you. They will chain-call user's previously installed callbacks, if any.
	// - When calling Init with 'install_callbacks=false': GLFW callbacks won't be installed. You will need to call individual function yourself from your own GLFW callbacks.
	ImGui_ImplGlfw_InstallCallbacks :: proc(window: glfw.WindowHandle) ---
	ImGui_ImplGlfw_RestoreCallbacks :: proc(window: glfw.WindowHandle) ---

	// GFLW callbacks options:
	// - Set 'chain_for_all_windows=true' to enable chaining callbacks for all windows (including secondary viewports created by backends or by user)
	ImGui_ImplGlfw_SetCallbacksChainForAllWindows :: proc(chain_for_all_windows: c.bool) ---

	// GLFW callbacks (individual callbacks to call yourself if you didn't install callbacks)
	ImGui_ImplGlfw_WindowFocusCallback :: proc(window: glfw.WindowHandle, focused: c.int) --- // Since 1.84
	ImGui_ImplGlfw_CursorEnterCallback :: proc(window: glfw.WindowHandle, entered: c.int) --- // Since 1.84
	ImGui_ImplGlfw_CursorPosCallback   :: proc(window: glfw.WindowHandle, x: f64, y: f64) --- // Since 1.87
	ImGui_ImplGlfw_MouseButtonCallback :: proc(window: glfw.WindowHandle, button: c.int, action: c.int, mods: c.int) ---
	ImGui_ImplGlfw_ScrollCallback      :: proc(window: glfw.WindowHandle, xoffset: f64, yoffset: f64) ---
	ImGui_ImplGlfw_KeyCallback         :: proc(window: glfw.WindowHandle, key: c.int, scancode: c.int, action: c.int, mods: c.int) ---
	ImGui_ImplGlfw_CharCallback        :: proc(window: glfw.WindowHandle, c: c.uint) ---
	ImGui_ImplGlfw_MonitorCallback     :: proc(monitor: glfw.MonitorHandle, event: c.int) ---
}
