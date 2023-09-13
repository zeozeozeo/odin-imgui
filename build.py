import subprocess
from os import path
import os
import shutil
from glob import glob
import typing

# @CONFIGURE: Must be key into below table
active_branch = "docking"
git_heads = {
	# Default Dear ImGui branch
	"master": { "imgui": "b9ab6e201", "dear_bindings": "5c15ae4" },
	# Docking branch
	"docking": { "imgui": "72dbe45ad", "dear_bindings": "5c15ae4" },
}

# @CONFIGURE: Elements must be keys into below table
wanted_backends = ["vulkan", "sdl2", "opengl3"]
backends = {
	"allegro5":     { "supported": False, "includes": [], "defines": [] },
	"android":      { "supported": False, "includes": [], "defines": [] },
	"dx10":         { "supported": False, "includes": [], "defines": [] },
	"dx11":         { "supported": False, "includes": [], "defines": [] },
	"dx12":         { "supported": False, "includes": [], "defines": [] },
	"dx9":          { "supported": False, "includes": [], "defines": [] },
	"glfw":         { "supported": False, "includes": [], "defines": [] },
	"glut":         { "supported": False, "includes": [], "defines": [] },
	"opengl2":      { "supported": False, "includes": [], "defines": [] },
	"opengl3":      { "supported": True,  "includes": [], "defines": [] },
	# Requires https://github.com/libsdl-org/SDL.git at tag release-2.28.3/commit 8a5ba43
	"sdl2":         { "supported": True,  "includes": [["SDL", "include"]], "defines": [] },
	"sdl3":         { "supported": False, "includes": [], "defines": [] },
	"sdlrenderer2": { "supported": False, "includes": [], "defines": [] },
	"sdlrenderer3": { "supported": False, "includes": [], "defines": [] },
	# Requires https://github.com/KhronosGroup/Vulkan-Headers.git commit 4f51aac
	"vulkan":       { "supported": True,  "includes": [["Vulkan-Headers", "include"]], "defines": ["VK_NO_PROTOTYPES"] },
	"wgpu":         { "supported": False, "includes": [], "defines": [] },
	"win32":        { "supported": False, "includes": [], "defines": [] },
}

# @CONFIGURE:
compile_debug = False

# Assert which doesn't clutter the output
def assertx(cond: bool, msg: str):
	if not cond:
		print(msg)
		exit(1)

def copy(from_path: str, files: typing.List[str], to_path: str):
	for file in files:
		shutil.copy(path.join(from_path, file), to_path)

def map_to_folder(files: typing.List[str], folder: str) -> typing.List[str]:
	return map(lambda file: path.join(folder, file), files)

def ensure_outside_of_repo():
	assertx(not path.isfile("gen_odin.py"), "You must run this from outside of the odin-imgui repository!")

def run_vcvars(cmd):
	assertx(subprocess.run(f"vcvarsall.bat x64 && {cmd}").returncode == 0, f"Failed to run command '{cmd}'")

def ensure_checked_out_with_commit(dir: str, repo: str, wanted_commit: str):
	# We assume that we are at least not using a completely wrong git repo
	if not path.isdir(dir):
		subprocess.run(args=f"git clone {repo}", check=True)

	active_commit = subprocess.check_output(f"git -C {dir} rev-parse --short HEAD").decode().strip()
	if active_commit == wanted_commit:
		print(f"{dir} is already checked out at {wanted_commit}")
		return
	else:
		print(f"{dir} is checked out at unwanted commit {active_commit}")
		subprocess.run(args=f"git -C {dir} reset --hard {wanted_commit}")

def main():
	ensure_outside_of_repo()
	ensure_checked_out_with_commit("imgui", "https://github.com/ocornut/imgui.git", git_heads[active_branch]["imgui"])
	ensure_checked_out_with_commit("dear_bindings", "https://github.com/dearimgui/dear_bindings.git", git_heads[active_branch]["dear_bindings"])

	# Clear our temp and build folder
	shutil.rmtree(path="temp", ignore_errors=True)
	os.mkdir("temp")
	shutil.rmtree(path="build", ignore_errors=True)
	os.mkdir("build")

	# Generate bindings for active ImGui branch
	subprocess.run("python dear_bindings/dear_bindings.py -o temp/c_imgui imgui/imgui.h")
	# Generate odin bindings from dear_bindings json file
	subprocess.run("python odin-imgui/gen_odin.py temp/c_imgui.json build/imgui.odin")

	# Find and copy imgui sources to temp folder
	imgui_headers = glob(pathname="*.h", root_dir="imgui")
	imgui_sources = glob(pathname="*.cpp", root_dir="imgui")
	copy("imgui", imgui_headers, "temp")
	copy("imgui", imgui_sources, "temp")

	# Copy pre-made implementation file
	shutil.copy(path.join("odin-imgui", "imgui_impl.odin"), "build")

	# Gather sources, defines, includes etc
	all_sources = imgui_sources
	compile_flags = []

	all_sources += ["c_imgui.cpp"]
	compile_flags += ["/Fotemp\\", '/DIMGUI_IMPL_API="extern \\\"C\\\""']

	if compile_debug:
		compile_flags += ["/Od", "/Z7"]
	else:
		compile_flags += ["/O2"]

	f = open(path.join("build", "impl_enabled.odin"), "w+")
	f.writelines([
		"package imgui\n",
		"\n",
		"// This file is generated with the rest of the imgui bindings, and enables\n",
		"// backend implementations in imgui_impl.odin\n",
		"\n",
	])

	for backend_name in backends:
		f.writelines([f"BACKEND_{backend_name.upper()}_ENABLED :: {'true' if backend_name in wanted_backends else 'false'}\n"])

	# Find and copy imgui backend sources to temp folder
	for backend_name in wanted_backends:
		backend = backends[backend_name]
		if not backend["supported"]:
			print(f"Warning: compiling backend '{backend_name}' which is not officially supported")

		copy("imgui/backends", [f"imgui_impl_{backend_name}.cpp", f"imgui_impl_{backend_name}.h"], "temp")
		all_sources += [f"imgui_impl_{backend_name}.cpp"]

		for define in backend["defines"]:
			compile_flags += [f"/D{define}"]

		for include in backend["includes"]:
			compile_flags += ["/I" + path.join("backend_deps", path.join(*include))]

	# Opengl 3 is the only backend that has a special auxiliary file. So we just copy it manually in this case.
	if "opengl3" in wanted_backends:
		shutil.copy(path.join("imgui", "backends", "imgui_impl_opengl3_loader.h"), "temp")

	all_objects = map(lambda file: file.removesuffix(".cpp") + ".obj", all_sources)

	sources_string = " ".join(map_to_folder(imgui_sources, "temp"))
	compile_flags_string = " ".join(compile_flags)
	print(f"cl {compile_flags_string} /c {sources_string}")
	run_vcvars(f"cl {compile_flags_string} /c {sources_string}")

	objects_string = " ".join(map_to_folder(all_objects, "temp"))
	run_vcvars(f"lib /OUT:build/imgui.lib {objects_string}")

	for file in ["imgui_impl.odin", "imgui.lib", "imgui.odin", "impl_enabled.odin"]:
		assertx(path.isfile(path.join("build", file)), f"Missing file '{file}' in build folder! Something went wrong..")

	print("Looks like everything went ok!")

if __name__ == "__main__":
	main()
