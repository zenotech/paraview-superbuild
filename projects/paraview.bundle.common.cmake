include(paraview-version)

# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
  "ParaView is a scientific visualization tool.")
if (NOT DEFINED CPACK_PACKAGE_NAME)
  set(CPACK_PACKAGE_NAME "ParaView")
endif ()
set(CPACK_PACKAGE_VENDOR "Kitware, Inc.")
set(CPACK_PACKAGE_VERSION_MAJOR "${paraview_version_major}")
set(CPACK_PACKAGE_VERSION_MINOR "${paraview_version_minor}")
set(CPACK_PACKAGE_VERSION_PATCH "${paraview_version_patch}${paraview_version_suffix}")
if (PARAVIEW_PACKAGE_SUFFIX)
  set(CPACK_PACKAGE_VERSION_PATCH "${CPACK_PACKAGE_VERSION_PATCH}-${PARAVIEW_PACKAGE_SUFFIX}")
endif ()

if (NOT DEFINED package_filename)
  set(package_filename "${PARAVIEW_PACKAGE_FILE_NAME}")
endif ()

if (package_filename)
  set(CPACK_PACKAGE_FILE_NAME "${package_filename}")
else ()
  set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
endif ()

# Set the license file.
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_LIST_DIR}/files/paraview.license.txt")

set(paraview_executables
  pvdataserver
  pvrenderserver
  pvserver)
if (python_enabled)
  list(APPEND paraview_executables
    pvpython)

  if (mpi_enabled)
    list(APPEND paraview_executables
      pvbatch)
  endif ()
endif ()

set(paraview_has_gui FALSE)
if (qt5_enabled)
  list(APPEND paraview_executables
    paraview)
  set(paraview_has_gui TRUE)
endif ()

set(python_modules
  cinema_python
  pygments
  six)

if (numpy_built_by_superbuild)
  list(APPEND python_modules
    numpy)
endif ()

if (scipy_built_by_superbuild)
  list(APPEND python_modules
    scipy)
endif ()

if (matplotlib_built_by_superbuild)
  list(APPEND python_modules
    matplotlib)
endif ()

if (paraviewweb_enabled)
  list(APPEND python_modules
    autobahn
    constantly
    incremental
    twisted
    zope)

  if (WIN32)
    list(APPEND python_modules
      adodbapi
      isapi
      pythoncom
      win32com)
  endif ()
endif ()

if (mpi_enabled)
  list(APPEND python_modules
    mpi4py)
endif ()

function (paraview_add_plugin output)
  set(contents "<?xml version=\"1.0\"?>\n<Plugins>\n</Plugins>\n")
  foreach (name IN LISTS ARGN)
    set(auto_load 0)
    if (DEFINED paraview_plugin_${name}_auto_load)
      set(auto_load 1)
    endif ()
    set(plugin_directive "  <Plugin name=\"${name}\" auto_load=\"${auto_load}\" />\n")
    string(REPLACE "</Plugins>" "${plugin_directive}</Plugins>" contents "${contents}")
  endforeach ()
  file(WRITE "${output}" "${contents}")
endfunction ()

file(STRINGS "${superbuild_install_location}/${paraview_plugin_path}/.plugins"
  paraview_plugin_lines
  REGEX "name=\"[A-Za-z0-9]+\"")
set(paraview_plugins)
foreach (paraview_plugin_line IN LISTS paraview_plugin_lines)
  string(REGEX REPLACE ".*name=\"\([A-Za-z0-9]+\)\".*" "\\1" paraview_plugin "${paraview_plugin_line}")
  list(APPEND paraview_plugins
    "${paraview_plugin}")
endforeach ()

if (osmesa_built_by_superbuild OR mesa_built_by_superbuild)
  set(mesa_libraries glapi)
  if (mesa_built_by_superbuild)
    list(APPEND mesa_libraries GL)
  endif()
  if (osmesa_built_by_superbuild)
    list(APPEND mesa_libraries OSMesa)
  endif()
  if (mesa_USE_SWR)
    list(APPEND mesa_libraries swrAVX swrAVX2)
  endif ()
endif ()

function (paraview_install_pdf project filename)
  if (${project}_enabled)
    install(
      FILES       "${superbuild_install_location}/doc/${filename}"
      DESTINATION "${paraview_doc_dir}"
      COMPONENT   superbuild)
  endif ()
endfunction ()

function (paraview_install_data project dir)
  if (${project}_enabled)
    install(
      DIRECTORY   "${superbuild_install_location}/${dir}"
      DESTINATION "${paraview_data_dir}"
      COMPONENT   superbuild)
  endif ()
endfunction ()

function (paraview_install_extra_data)
  if (paraview_doc_dir)
    paraview_install_pdf(paraviewgettingstartedguide "GettingStarted.pdf")
    paraview_install_pdf(paraviewusersguide "Guide.pdf")
    paraview_install_pdf(paraviewtutorial "Tutorial.pdf")
  endif ()

  if (paraview_data_dir)
    paraview_install_data(paraviewtutorialdata "data/")
  endif ()
endfunction ()

if (qt5_enabled)
  include(qt5.functions)

  set(qt5_plugin_prefix)
  if (NOT WIN32)
    set(qt5_plugin_prefix "lib")
  endif ()

  set(qt5_plugins
    sqldrivers/${qt5_plugin_prefix}qsqlite)

  if (WIN32)
    list(APPEND qt5_plugins
      platforms/qwindows)
  elseif (APPLE)
    list(APPEND qt5_plugins
      platforms/libqcocoa
      printsupport/libcocoaprintersupport)
  elseif (UNIX)
    list(APPEND qt5_plugins
      platforms/libqxcb
      platforminputcontexts/libcomposeplatforminputcontextplugin
      xcbglintegrations/libqxcb-glx-integration)
  endif ()

  superbuild_install_qt5_plugin_paths(qt5_plugin_paths ${qt5_plugins})
else ()
  set(qt5_plugin_paths)
endif ()

if (socat_built_by_superbuild)
  include(socat.bundle)
endif ()
