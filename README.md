# Odin ImGui - Generated ImGui bindings using dear_bindings

## Usage
If you don't want to configure and or build yourself, download the latest release.
 - At the moment this release is only available for Windows, on the docking branch, and includes all supported backends.

## Building

Building is entirely automated, using `build.py`. Currently however there is only Windows and Linux, although compiling for other platforms shouldn't be too difficult, following the pattern in `build.py`.

 0. `dear_bindings` depends on a library called "`ply`"
	- You can probably install this with `python -m pip install ply`
	- On Arch Linux I had to install `python-ply` with pacman.
 1. Clone this repository into a clean directory `parent_directory`.
	- Optionally configure build at the top of `build.py`
	- Building some backends require external dependencies. Again check `build.py`.
 2. From *outside* of the `odin-imgui` folder, run `python odin-imgui/build.py`
 3. Folder `build/` is importable. Copy into your project.

## Configuring

Search for `@CONFIGURE` to see everything configurable.

### `active_branch`
The bindings have been tested against the main two branches of Dear ImGui: `master` and `docking`.
You can choose between the two by changing `active_branch`

### `wanted_backends`
This project allows you to compile ImGui backends alongside imgui itself, which is what Dear ImGui recommends you do.
Bindings have been written for a subset of the backends provided by ImGui
 - You can see if a backend is supported by checking the `backends` table in `build.py`.
 - If a backend is supported it means that:
	- Bindings have been written to `imgui_impl.odin`
	- It has been successfully compiled in the latest revision, for both supported branches.
 - Some backends have external dependencies. These should be cloned into a folder called `backend_deps`, with the given revision.
	- Eg: Vulkan requires that you clone `https://github.com/KhronosGroup/Vulkan-Headers.git` at commit `4f51aac` into `parent_directory/backend_deps/Vulkan-Headers`
 - You can enable a backend by adding it to `wanted_backends`
 - You can enable backends not officially supported. (If it works, please MR!)

### `compile_debug`
If set to true, will compile with debug flags

## Updating

The Dear ImGui commits which have been tested against are listed in `build.py`.
You can mess with these all you want and see if it works.

Additionally, when updating, all backends in `imgui_impl.odin` should be checked for new commits, and updated where necessary.
