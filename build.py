import subprocess
from os import path
import os
import shutil
from glob import glob
import typing
from sys import platform

# TODO:
# - Auto download backends deps
#		It should be relatively easy to automatically clone any deps.
# - Don't `cd` into temp folder
#		When compiling, we `cd` into the temp folder, as there's no option
#		for clang or gcc to output .o files into another folder.
#		We should probably instead run one compile command per source file.
#		This lets us specify the output file, as well as compiling in paralell

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

def exec(cmd: typing.List[str], what: str) -> str:
	max_what_len = 40
	if len(what) > max_what_len:
		what = what[:max_what_len - 2] + ".."
	print(what + (" " * (max_what_len - len(what))) + "> " + " ".join(cmd))
	return subprocess.check_output(cmd).decode().strip()

def copy(from_path: str, files: typing.List[str], to_path: str):
	for file in files:
		shutil.copy(path.join(from_path, file), to_path)

def map_to_folder(files: typing.List[str], folder: str) -> typing.List[str]:
	return list(map(lambda file: path.join(folder, file), files))

def ensure_outside_of_repo():
	assertx(not path.isfile("gen_odin.py"), "You must run this from outside of the odin-imgui repository!")

def run_vcvars(cmd: typing.List[str]):
	assertx(subprocess.run(f"vcvarsall.bat x64 && {' '.join(cmd)}").returncode == 0, f"Failed to run command '{cmd}'")

def ensure_checked_out_with_commit(dir: str, repo: str, wanted_commit: str):
	# We assume that we are at least not using a completely wrong git repo
	if not path.isdir(dir):
		exec(["git", "clone", repo], f"Checking out {dir}")

	active_commit = exec(["git", "-C", dir, "rev-parse", "--short", "HEAD"], f"Checking active commit for {dir}")
	if active_commit == wanted_commit:
		return
	else:
		print(f"{dir} on unwanted commit {active_commit}")
		exec(["git", "-C", dir, "reset", "--hard", wanted_commit], f"Checking out wanted commit {wanted_commit}")

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
	exec(["python", "dear_bindings/dear_bindings.py", "-o", "temp/c_imgui", "imgui/imgui.h"], "Running dear_bindings")
	# Generate odin bindings from dear_bindings json file
	exec(["python", "odin-imgui/gen_odin.py", "temp/c_imgui.json", "build/imgui.odin"], "Running odin-imgui")

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
	if platform ==   "win32": compile_flags += ['/DIMGUI_IMPL_API=extern\\\"C\\\"']
	elif platform == "linux": compile_flags += ['-DIMGUI_IMPL_API=extern\"C\"', "-fPIC", "-fno-exceptions", "-fno-rtti", "-fno-threadsafe-statics"]

	if compile_debug:
		if platform ==   "win32": compile_flags += ["/Od", "/Z7"]
		elif platform == "linux": compile_flags += ["-g", "-Od"]
	else:
		if platform ==   "win32": compile_flags += ["/O2"]
		elif platform == "linux": compile_flags += ["-O3"]

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
			if platform   == "win32": compile_flags += [f"/D{define}"]
			elif platform == "linux": compile_flags += [f"-D{define}"]

		for include in backend["includes"]:
			if platform   == "win32": compile_flags += ["/I" + path.join("..", "backend_deps", path.join(*include))]
			elif platform == "linux": compile_flags += ["-I" + path.join("..", "backend_deps", path.join(*include))]

	# Opengl 3 is the only backend that has a special auxiliary file. So we just copy it manually in this case.
	if "opengl3" in wanted_backends:
		shutil.copy(path.join("imgui", "backends", "imgui_impl_opengl3_loader.h"), "temp")

	all_objects = []
	if platform   == "win32": all_objects += map(lambda file: file.removesuffix(".cpp") + ".obj", all_sources)
	elif platform == "linux": all_objects += map(lambda file: file.removesuffix(".cpp") + ".o", all_sources)

	os.chdir("temp")

	if platform   == "win32": run_vcvars(["cl"] + compile_flags + ["/c"] + all_sources)
	elif platform == "linux": exec(["clang"] + compile_flags + ["-c"] + all_sources, "Compiling sources")

	os.chdir("..")

	if platform   == "win32": run_vcvars(["lib", "/OUT:" + path.join("build", "imgui.lib")] + map_to_folder(all_objects, "temp"))
	elif platform == "linux": exec(["ar", "rcs", path.join("build", "imgui.a")] + map_to_folder(all_objects, "temp"), "Making library from objects")

	expected_files = ["imgui_impl.odin", "imgui.odin", "impl_enabled.odin"]
	if platform   == "win32": expected_files += ["imgui.lib"]
	elif platform == "linux": expected_files += ["imgui.a"]

	for file in expected_files:
		assertx(path.isfile(path.join("build", file)), f"Missing file '{file}' in build folder! Something went wrong..")

	print("Looks like everything went ok!")

if __name__ == "__main__":
	main()
