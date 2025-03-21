include(paraview-version)

set(paraview_doc_dir "doc")
set(paraview_data_dir "examples")
set(paraview_translations_dir "translations")
set(paraview_materials_dir "materials")
set(paraview_kernels_nvidia_index_dir "kernels_nvidia_index")
set(paraview_plugin_path "bin/paraview-${paraview_version}/plugins")
set(paraview_license_path "share/licenses")
set(paraview_spdx_path "share/paraview-${paraview_version}")
include(paraview.bundle.common)

set(CPACK_WIX_PROGRAM_MENU_FOLDER "ParaView ${paraview_version_full}")
set(CPACK_WIX_PRODUCT_ICON "${CMAKE_CURRENT_LIST_DIR}/paraview.ico")

if (NOT "$ENV{GITLAB_CI}" STREQUAL "")
  # Suppress validation.  It does not work without
  # an interactive session or an admin account.
  # https://github.com/wixtoolset/issues/issues/3968
  list(APPEND CPACK_WIX_LIGHT_EXTRA_FLAGS "-sval")
endif ()

# Set NSIS install specific stuff.
if (CMAKE_CL_64)
  # Change default installation root path for Windows x64.
  set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
endif ()

# URL to website providing assistance in installing your application.
set(CPACK_NSIS_HELP_LINK "http://paraview.org/Wiki/ParaView")
set(paraview_description "ParaView ${paraview_version_full}")
set(pvserver_description "pvserver ${paraview_version_full} (Server)")
set(pvdataserver_description "pvdataserver ${paraview_version_full} (Data-Server)")
set(pvrenderserver_description "pvrenderserver ${paraview_version_full} (Render-Server)")
set(pvpython_description "pvpython ${paraview_version_full} (Python Shell)")

set(paraview_start_menu_name "ParaView ${paraview_version_full}")

#FIXME: need a pretty icon.
#set(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_LIST_DIR}/paraview.ico")
#set(CPACK_NSIS_MUI_FINISHPAGE_RUN "bin/paraview.exe")

set(library_paths "")
if (Qt5_DIR)
  list(APPEND library_paths
    "${Qt5_DIR}/../../../bin")
endif ()

set(exclude_regexes)
if (python3_enabled)
  if (python3_built_by_superbuild)
    list(APPEND library_paths
      "${superbuild_install_location}/Python")
  else()
    list(APPEND exclude_regexes
        ".*python3[0-9]+.dll")
  endif()
endif ()

# Install paraview executables to bin.
foreach (executable IN LISTS paraview_executables other_executables)
  if (DEFINED "${executable}_description")
    list(APPEND CPACK_NSIS_MENU_LINKS
      "bin/${executable}.exe" "${${executable}_description}")
  endif ()
  if (DEFINED "${executable}_start_menu_name")
    set_property(INSTALL "bin/${executable}.exe" APPEND
      PROPERTY
        CPACK_START_MENU_SHORTCUTS "${${executable}_start_menu_name}")
  endif ()

  superbuild_windows_install_program("${executable}" "bin"
    SEARCH_DIRECTORIES "${library_paths}"
    EXCLUDE_REGEXES    ${exclude_regexes})
endforeach()

if (EXISTS "${superbuild_install_location}/bin/paraview.conf")
  install(
    FILES       "${superbuild_install_location}/bin/paraview.conf"
    DESTINATION "bin"
    COMPONENT   "superbuild")
endif ()

foreach (paraview_plugin IN LISTS paraview_plugins)
  superbuild_windows_install_plugin("${paraview_plugin}.dll"
    "${paraview_plugin_path}/${paraview_plugin}" "${paraview_plugin_path}/${paraview_plugin}"
    SEARCH_DIRECTORIES "${paraview_plugin_path}/${paraview_plugin}" "${library_paths}" "${superbuild_install_location}/bin"
    EXCLUDE_REGEXES ${exclude_regexes})
endforeach ()

set(plugins_file "${CMAKE_CURRENT_BINARY_DIR}/paraview.plugins.xml")
paraview_add_plugin("${plugins_file}" ${paraview_plugins})

install(
  FILES       "${plugins_file}"
  DESTINATION "${paraview_plugin_path}"
  COMPONENT   superbuild)

if (nvidiaindex_enabled)
  set(nvidiaindex_libraries
    libdice
    libnvindex)

  # Need different nvrtc-builtins library depending on the version of IndeX.
  if (nvidiaindex_SOURCE_SELECTION STREQUAL "2.1")
    list(APPEND nvidiaindex_libraries nvrtc-builtins64_80)
  elseif (nvidiaindex_SOURCE_SELECTION STREQUAL "2.2")
    list(APPEND nvidiaindex_libraries nvrtc-builtins64_90)
  elseif (nvidiaindex_SOURCE_SELECTION STREQUAL "2.3")
    list(APPEND nvidiaindex_libraries nvrtc-builtins64_101)
  elseif (nvidiaindex_SOURCE_SELECTION STREQUAL "2.4")
    list(APPEND nvidiaindex_libraries nvrtc-builtins64_102)
  elseif (nvidiaindex_SOURCE_SELECTION VERSION_GREATER_EQUAL "5.12")
    list(APPEND nvidiaindex_libraries libnvindex_builtins)
  elseif (nvidiaindex_SOURCE_SELECTION VERSION_GREATER_EQUAL "5.10")
    list(APPEND nvidiaindex_libraries libnvindex_builtins)
    list(APPEND nvidiaindex_libraries nvrtc64_102_0)
    list(APPEND nvidiaindex_libraries nvrtc-builtins64_102)
  elseif (nvidiaindex_SOURCE_SELECTION VERSION_GREATER_EQUAL "5.9")
    list(APPEND nvidiaindex_libraries libnvindex_builtins)
    list(APPEND nvidiaindex_libraries nvrtc-builtins64_102)
  else ()
    message(FATAL_ERROR
      "Unknown nvrtc-builtins64 library for ${nvidiaindex_SOURCE_SELECTION}.")
  endif ()

  foreach (nvidiaindex_library IN LISTS nvidiaindex_libraries)
    superbuild_windows_install_plugin("${nvidiaindex_library}.dll"
      "bin" "bin"
      SEARCH_DIRECTORIES "${superbuild_install_location}/bin"
      # Yes, there are 8 slashes here. It goes through one CMake level here,
      # another in the `install(CODE)` during the install, and then a regex
      # level inside of Python. Since 2^3 is 8, we need 8 slashes to get one in
      # the regex character class.
      EXCLUDE_REGEXES ".*[/\\\\\\\\]nvcuda.dll")
  endforeach ()
endif ()

set(extra_library_names)
if (ispc_enabled AND ospray_SOURCE_SELECTION STREQUAL "2.12.0")
  list(APPEND extra_library_names
    ispcrt_device_cpu)
endif ()
if (rkcommon_enabled)
  list(APPEND extra_library_names
    rkcommon)
endif ()
if (openvkl_enabled)
  list(APPEND extra_library_names
    openvkl_module_cpu_device
    openvkl_module_cpu_device_4
    openvkl_module_cpu_device_8
    openvkl_module_cpu_device_16)
endif ()
if (ospray_enabled)
  list(APPEND extra_library_names
    ospray_module_denoiser)
  if (ospray_SOURCE_SELECTION STREQUAL "2.12.0")
    list(APPEND extra_library_names
      ospray_module_cpu)
  else ()
    list(APPEND extra_library_names
      ospray_module_ispc)
  endif ()
endif ()
if (ospraymodulempi_enabled)
  if (ospray_SOURCE_SELECTION STREQUAL "2.12.0")
    list(APPEND extra_library_names
      ospray_module_mpi_distributed_cpu
      ospray_module_mpi_offload)
  else ()
    list(APPEND extra_library_names
      ospray_module_mpi)
  endif ()
endif ()

foreach (extra_library_name IN LISTS extra_library_names)
  superbuild_windows_install_plugin("${extra_library_name}.dll"
    "bin" "bin"
    SEARCH_DIRECTORIES "${superbuild_install_location}/bin")
endforeach ()

if (visrtx_enabled)
  set(visrtxextra_libraries
    VisRTX
    dds
    nv_freeimage
    libmdl_sdk)

  foreach (visrtxextra_library IN LISTS visrtxextra_libraries)
    superbuild_windows_install_plugin("${visrtxextra_library}.dll"
      "bin" "bin"
      SEARCH_DIRECTORIES "${superbuild_install_location}/bin")
  endforeach ()
endif ()

if (python3_enabled)
  if (python3_built_by_superbuild)
    include(python3.functions)
    superbuild_install_superbuild_python3()
  endif ()

  superbuild_windows_install_python(
    MODULES ${python_modules}
    MODULE_DIRECTORIES  "${superbuild_install_location}/Python/Lib/site-packages"
                        "${superbuild_install_location}/bin/Lib/site-packages"
                        "${superbuild_install_location}/lib/site-packages"
                        "${superbuild_install_location}/lib/python${superbuild_python_version}/site-packages"
                        "${superbuild_install_location}/lib/paraview-${paraview_version_major}.${paraview_version_minor}/site-packages"
    SEARCH_DIRECTORIES  "${superbuild_install_location}/lib"
                        "${superbuild_install_location}/bin"
                        "${superbuild_install_location}/Python"
                        "${superbuild_install_location}/Python/Lib/site-packages/pywin32_system32"
                        ${library_paths}
    EXCLUDE_REGEXES     ${exclude_regexes})

  if (pywin32_built_by_superbuild)
      install(
        DIRECTORY   "${superbuild_install_location}/Python/Lib/site-packages/win32"
        DESTINATION "bin/Lib/site-packages"
        COMPONENT   "superbuild"
        PATTERN     "__pycache__" EXCLUDE)
      install(
        DIRECTORY   "${superbuild_install_location}/Python/Lib/site-packages/pywin32_system32"
        DESTINATION "bin/Lib/site-packages"
        COMPONENT   "superbuild"
        PATTERN     "__pycache__" EXCLUDE)
      install(
        FILES       "${superbuild_install_location}/Python/Lib/site-packages/pywin32.pth"
                    "${superbuild_install_location}/Python/Lib/site-packages/pywin32.version.txt"
        DESTINATION "bin/Lib/site-packages"
        COMPONENT   "superbuild")
  endif ()
endif ()

if (paraviewweb_enabled)
  install(
    DIRECTORY   "${superbuild_install_location}/share/paraview/web"
    DESTINATION "share/paraview-${paraview_version}"
    COMPONENT   "superbuild")
endif ()

foreach (qt5_plugin_path IN LISTS qt5_plugin_paths)
  get_filename_component(qt5_plugin_group "${qt5_plugin_path}" DIRECTORY)
  get_filename_component(qt5_plugin_group "${qt5_plugin_group}" NAME)

  superbuild_windows_install_plugin(
    "${qt5_plugin_path}"
    "bin"
    "bin/${qt5_plugin_group}"
    SEARCH_DIRECTORIES "${library_paths}")
endforeach ()

if (qt5_enabled)

  set(qt5_root_dir "${Qt5_DIR}/../../..")

  foreach (qt5_opengl_lib IN ITEMS opengl32sw libEGL libGLESv2)
    superbuild_windows_install_plugin(
      "${qt5_root_dir}/bin/${qt5_opengl_lib}.dll"
      "bin"
      "bin"
      SEARCH_DIRECTORIES "${library_paths}")
  endforeach ()

  if (qt5_ENABLE_WEBENGINE)
    _superbuild_windows_install_executable(
      "${qt5_root_dir}/bin/QtWebEngineProcess.exe"
      "bin"
      SEARCH_DIRECTORIES "${library_paths}"
      EXCLUDE_REGEXES    ${exclude_regexes})

    install(
      DIRECTORY   "${qt5_root_dir}/resources"
      DESTINATION "."
      COMPONENT   superbuild)

    install(
      FILES   "${qt5_root_dir}/bin/qt.conf"
      DESTINATION "bin"
      COMPONENT   superbuild)
  endif()
endif ()

if (openxrremoting_enabled)
  # The external package for openxrremoting contains several dlls, as it's
  # only loaded at runtime, we only package required dll for paraview to use
  # the OpenXRRemoting feature:
  # - Microsoft.Holographic.AppRemoting.OpenXr.dll
  # - RemotingXR.json
  set(openxrremoting_files
    Microsoft.Holographic.AppRemoting.OpenXr.dll
    RemotingXR.json
  )

  foreach (openxrremoting_file IN LISTS openxrremoting_files)
    install(
      FILES       "${superbuild_install_location}/bin/${openxrremoting_file}"
      DESTINATION "bin"
      COMPONENT   "superbuild")
  endforeach ()
endif ()

paraview_install_extra_data()

if (proj_enabled)
  install(
    FILES       "${superbuild_install_location}/share/proj/proj.db"
    DESTINATION "share/proj"
    COMPONENT   superbuild)
endif ()
