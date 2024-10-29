/*=========================================================================

Program:   ParaView
Module:    launcher.cxx

Copyright (c) Kitware, Inc.
All rights reserved.
See Copyright.txt or http://www.paraview.org/HTML/Copyright.html for details.

This software is distributed WITHOUT ANY WARRANTY; without even
the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the above copyright notice for more information.

=========================================================================*/

#include <vtksys/Process.h>
#include <vtksys/SystemTools.hxx>

#include <cstdlib>
#include <cstring>
#include <iostream>
#include <string>
#include <vector>

#if defined(_WIN32) && !defined(__CYGWIN__)
#include <windows.h>
#endif

#if defined(__APPLE__)
#include <mach-o/dyld.h>
#endif

#if defined(__linux__)
#include <dlfcn.h>
#endif

static char const* const mesa_relative_libdir = MESA_RELATIVE_LIBDIR;
static char const* const mpi_relative_libdir = MPI_RELATIVE_LIBDIR;
static char const* const tool = TOOL;
static char const* const tool_suffix = TOOL_SUFFIX;

#if defined(_WIN32)
static char const* const library_env = "PATH";
#elif defined(__APPLE__)
static char const* const library_env = "DYLD_LIBRARY_PATH";
#else
static char const* const library_env = "LD_LIBRARY_PATH";
#endif

#if defined(_WIN32)
static char const path_separator = ';';
#else
static char const path_separator = ':';
#endif

#if ENABLE_MESA || ENABLE_OSMESA
#define ENABLE_MESA_BACKENDS 1
#else
#define ENABLE_MESA_BACKENDS 0
#endif

static char const* const backends[] = {
#if ENABLE_MESA_BACKENDS
  "llvmpipe",
#if ENABLE_MESA_SWR
  "swr",
#endif
#endif
  nullptr };

void available(char const* name, char const* const* arr)
{
  std::cerr << "Available " << name << ":" << std::endl;
  char const* const* current = arr;
  while (*current)
  {
    std::cerr << "    " << *current << std::endl;
    ++current;
  }
}

void usage(char const* prog)
{
  std::cerr << "Launcher options:"
            << std::endl
            << "  --print       Print modified environment." << std::endl;
#if ENABLE_MPI
  std::cerr << "  --system-mpi  Use MPI implementation available on the system." << std::endl;
#endif
#if ENABLE_MESA
  std::cerr << "  --mesa        Use Mesa GL for rendering." << std::endl;
#endif
#if ENABLE_MESA_BACKENDS
  std::cerr << "  --backend <backend>  Specify mesa backend." << std::endl << std::endl;
  available("backends", backends);
#endif
}

void error(char const* msg, char const* arg)
{
  if (arg)
  {
    std::cerr << "error: " << msg << arg << std::endl;
  }
  else
  {
    std::cerr << "error: " << msg << std::endl;
  }
}

void set_launcher_env(bool print, char const* var, const char* value)
{
  std::string const setting = std::string(var) + "=" + value;
  vtksys::SystemTools::PutEnv(setting);
  if (print)
  {
    std::cerr << setting << std::endl;
  }
}

std::string current_exe_dir(char const* prog)
{
  std::string exe_dir;
#if defined(_WIN32) && !defined(__CYGWIN__)
  (void)prog; // ignore this on windows
  wchar_t modulepath[_MAX_PATH];
  ::GetModuleFileNameW(NULL, modulepath, sizeof(modulepath));
  std::string path = vtksys::Encoding::ToNarrow(modulepath);
  std::string realPath = vtksys::SystemTools::GetRealPathResolvingWindowsSubst(path, NULL);
  if (realPath.empty())
  {
    realPath = path;
  }
  exe_dir = vtksys::SystemTools::GetFilenamePath(realPath);
#elif defined(__APPLE__)
  (void)prog; // ignore this on OS X
#define CM_EXE_PATH_LOCAL_SIZE 16384
  char exe_path_local[CM_EXE_PATH_LOCAL_SIZE];
#if defined(MAC_OS_X_VERSION_10_3) && !defined(MAC_OS_X_VERSION_10_4)
  unsigned long exe_path_size = CM_EXE_PATH_LOCAL_SIZE;
#else
  uint32_t exe_path_size = CM_EXE_PATH_LOCAL_SIZE;
#endif
#undef CM_EXE_PATH_LOCAL_SIZE
  char* exe_path = exe_path_local;
  if (_NSGetExecutablePath(exe_path, &exe_path_size) < 0)
  {
    exe_path = static_cast<char*>(malloc(exe_path_size));
    _NSGetExecutablePath(exe_path, &exe_path_size);
  }
  exe_dir = vtksys::SystemTools::GetFilenamePath(vtksys::SystemTools::GetRealPath(exe_path));
  if (exe_path != exe_path_local)
  {
    free(exe_path);
  }
#else
  std::string errorMsg;
  std::string exe;
  if (vtksys::SystemTools::FindProgramPath(prog, exe, errorMsg))
  {
    // remove symlinks
    exe = vtksys::SystemTools::GetRealPath(exe);
    exe_dir = vtksys::SystemTools::GetFilenamePath(exe);
  }
  else
  {
    // ???
  }
#endif

  return exe_dir;
}

int main(int argc, char* argv[])
{
  char const* backend = nullptr;
  bool print = false;
  bool help = false;

  bool forward_mpi = true;
  bool forward_mesa = false;

  std::vector<char const*> args;
  for (int i = 1; i < argc; ++i)
  {
    char const* arg = argv[i];
    if (!strcmp(arg, "--help") || !strcmp(arg, "/?"))
    {
      help = true;
      args.push_back(arg);
    }
    else if (!strcmp(arg, "--print") && !print)
    {
      print = true;
    }
    else if (!strcmp(arg, "--system-mpi") && forward_mpi)
    {
      forward_mpi = false;
    }
    else if (!strcmp(arg, "--mesa") && !forward_mesa)
    {
      forward_mesa = true;
    }
    else if (!strcmp(arg, "--backend") && backend == nullptr)
    {
      ++i;
      if (argc <= i)
      {
        error("--backend requires an argument", nullptr);
        return EXIT_FAILURE;
      }

      backend = argv[i];

      // Check that the backend argument is valid.
      bool have_backend = false;
      char const* const* current_backend = backends;
      while (*current_backend)
      {
        if (!strcmp(*current_backend, backend))
        {
          have_backend = true;
          break;
        }
        ++current_backend;
      }

      if (!have_backend)
      {
        error("unknown backend: ", backend);
        available("backends", backends);
        return EXIT_FAILURE;
      }
    }
    else
    {
      args.push_back(arg);
    }
  }
  args.push_back(nullptr);

  std::string const exe_dir = current_exe_dir(argv[0]);

  // VTK looks at this environment variable to select an OpenGL context
  // provider. This can give an undesired outcome when the env var
  // is configured to create EGL render window and the --mesa option is used
  // because the bundled mesa does not provide `libEGL`.
  const char* current_default_opengl_window =
      vtksys::SystemTools::GetEnv("VTK_DEFAULT_OPENGL_WINDOW");
  if (current_default_opengl_window != nullptr)
  {
    if (!strcmp(current_default_opengl_window, "vtkEGLRenderWindow"))
    {
      // This is handled easily as execution can take two paths:
      //
      // 1. If VTK finds `libEGL`, the --mesa option is unnecessary. Inform the
      // user about unused option.
      // 2. If VTK cannot find `libEGL` on the system, it will eventually fallback
      // to OSMesa. In this case, the `prefix_paths` will guide the discovery of
      // `libOSMesa`
      if (forward_mesa)
      {
        std::cout << "Note: The --mesa option "
                    "will have no effect if your system has EGL installed "
                    "because your environment has set "
                    "VTK_DEFAULT_OPENGL_WINDOW="
                  << current_default_opengl_window << '\n';
      }
    }
#if ENABLE_MESA_BACKENDS && defined(__linux__)
    else if (!strcmp(current_default_opengl_window, "vtkOSOpenGLRenderWindow"))
    {
      // Assist the PV process in locating mesa by appending the path to the bundled mesa library.
      if (!forward_mesa)
      {
        // First, check if OSMesa is already installed somewhere in the system.
        const char* libNamesToTry[] = {
            "libOSMesa.so.8", "libOSMesa.so.6", "libOSMesa.so"};
        void* libosmesa_handle = nullptr;
        for (const auto& libName : libNamesToTry)
        {
          libosmesa_handle = dlopen(libName, RTLD_LAZY | RTLD_GLOBAL);
          if (libosmesa_handle)
          {
            break;
          }
        }
        // use the bundled libOSMesa as we were unable to find one in the system
        if (libosmesa_handle == nullptr)
        {
          forward_mesa = true;
          std::cout
              << "OSMesa not found. Fallback to bundled libOSMesa at "
              << exe_dir << '/' << mesa_relative_libdir << '\n';
        }
      }
    }
#endif
  }

  std::string prefix_paths;
  if (forward_mesa)
  {
    prefix_paths += exe_dir + "/" + mesa_relative_libdir;
  }
  if (forward_mpi)
  {
    if (prefix_paths.size() > 0)
    {
      prefix_paths += path_separator;
    }
    prefix_paths += exe_dir + "/" + mpi_relative_libdir;
  }

  // Set up the environment
  if (prefix_paths.size() > 0)
  {
    char const* cur_value = vtksys::SystemTools::GetEnv(library_env);
    std::string new_library_env;
    // Unset -> use just the new path.
    if (!cur_value)
    {
      new_library_env = prefix_paths;
    }
    // Empty -> use just the new path.
    else if (!*cur_value)
    {
      new_library_env = prefix_paths;
    }
    // Prepend it with the separator.
    else
    {
      new_library_env = prefix_paths + path_separator + cur_value;
    }
    set_launcher_env(print, library_env, new_library_env.c_str());
  }

  if (backend)
  {
    set_launcher_env(print, "GALLIUM_DRIVER", backend);
  }

  if (help)
  {
    usage(tool);
    std::cerr << std::endl << tool << " options:" << std::endl;
  }

  // Build the command line for the tool.
  std::string const tool_path = exe_dir + "/" + tool + tool_suffix;
  // Insert the program to run as argv[0].
  args.insert(args.begin(), tool_path.c_str());
  // Append a NULL at the end of the array.
  args.push_back(nullptr);

  // Run the tool with the arguments given.
  auto proc = vtksysProcess_New();
  vtksysProcess_SetCommand(proc, args.data());
  vtksysProcess_SetPipeShared(proc, vtksysProcess_Pipe_STDOUT, 1);
  vtksysProcess_SetPipeShared(proc, vtksysProcess_Pipe_STDERR, 1);
  vtksysProcess_Execute(proc);
  vtksysProcess_WaitForExit(proc, nullptr);

  // Extract the result of the command.
  int const state = vtksysProcess_GetState(proc);
  int ret = EXIT_FAILURE;
  if (state == vtksysProcess_State_Exited)
  {
    ret = vtksysProcess_GetExitValue(proc);
  }
  else if (state == vtksysProcess_State_Exception)
  {
    const char* exception_str = vtksysProcess_GetExceptionString(proc);
    error("exception occurred: ", exception_str);
  }
  else if (state == vtksysProcess_State_Error)
  {
    const char* error_str = vtksysProcess_GetErrorString(proc);
    error("process error: ", error_str);
  }
  else if (state == vtksysProcess_State_Expired)
  {
    error("timeout error", nullptr);
  }

  // Cleanup.
  vtksysProcess_Delete(proc);
  return ret;
}
