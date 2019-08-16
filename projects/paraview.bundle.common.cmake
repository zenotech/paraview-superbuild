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
    pvbatch
    pvpython)
endif ()
if (mesa_enabled)
  list(APPEND paraview_executables
    paraview-mesa)
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
  mpi4py)

if (nlohmannjson_enabled)
  list(APPEND python_modules parflow)
endif()

macro (check_for_python_module project module)
  if (${project}_built_by_superbuild)
    list(APPEND python_modules
      "${module}")
  endif ()
endmacro ()

check_for_python_module(numpy numpy)
check_for_python_module(numpy pkg_resources)
check_for_python_module(scipy scipy)
check_for_python_module(pythonkiwisolver kiwisolver)
check_for_python_module(matplotlib matplotlib)
check_for_python_module(matplotlib mpl_toolkits)
check_for_python_module(pythonattrs attr)
check_for_python_module(pythonpygments pygments)
check_for_python_module(pythonsix six)
check_for_python_module(pythonautobahn autobahn)
check_for_python_module(pythonconstantly constantly)
check_for_python_module(pythoncycler cycler)
check_for_python_module(pythondateutil dateutil)
check_for_python_module(pythonhyperlink hyperlink)
check_for_python_module(pythonincremental incremental)
check_for_python_module(pythonpyparsing pyparsing)
check_for_python_module(pythontwisted twisted)
check_for_python_module(pythontxaio txaio)
check_for_python_module(pythonwslink wslink)
check_for_python_module(pythonzopeinterface zope)
check_for_python_module(pytz pytz)

if (WIN32)
  check_for_python_module(pywin32 adodbapi)
  check_for_python_module(pywin32 isapi)
  check_for_python_module(pywin32 pythoncom)
  check_for_python_module(pywin32 pythonwin)
  check_for_python_module(pywin32 pywin32_system32)
  check_for_python_module(pywin32 win32)
  check_for_python_module(pywin32 win32com)
  check_for_python_module(pywin32 win32comext)
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

set(plugin_file_dir
  "${superbuild_install_location}/${paraview_plugin_path}/")
if (EXISTS "${plugin_file_dir}/paraview.plugins.xml")
  set(plugin_file
    "${plugin_file_dir}/paraview.plugins.xml")
elseif (EXISTS "${plugin_file_dir}/.plugins")
  set(plugin_file
    "${plugin_file_dir}/.plugins")
endif ()

file(STRINGS "${plugin_file}"
  paraview_plugin_lines
  REGEX "name=\"[A-Za-z0-9]+\"")
set(paraview_plugins)
foreach (paraview_plugin_line IN LISTS paraview_plugin_lines)
  string(REGEX REPLACE ".*name=\"\([A-Za-z0-9]+\)\".*" "\\1" paraview_plugin "${paraview_plugin_line}")
  list(APPEND paraview_plugins
    "${paraview_plugin}")
endforeach ()

if (vortexfinder2_enabled)
  list(APPEND paraview_plugins
    VortexFinder)
endif ()

if (osmesa_built_by_superbuild OR mesa_built_by_superbuild)
  set(mesa_libraries)
  if (mesa_built_by_superbuild)
    list(APPEND mesa_libraries GL)
  endif()
  if (osmesa_built_by_superbuild)
    list(APPEND mesa_libraries OSMesa)
  endif()
  if (mesa_USE_SWR)
    string(REPLACE "," ";" _mesa_SWR_ARCH "${mesa_SWR_ARCH}")
    list(LENGTH _mesa_SWR_ARCH mesa_num_swr_archs)
    if (mesa_num_swr_archs GREATER 1)
      foreach (arch IN LISTS _mesa_SWR_ARCH)
        string(TOUPPER "${arch}" ARCH)
        list(APPEND mesa_libraries swr${ARCH})
      endforeach ()
    endif ()
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

function (paraview_install_materials project dir)
  if (${project}_enabled)
    install(
      DIRECTORY   "${superbuild_install_location}/${dir}"
      DESTINATION "${paraview_materials_dir}"
      COMPONENT   superbuild)
  endif ()
endfunction ()

function (paraview_install_extra_data)
  if (paraview_doc_dir)
    paraview_install_pdf(paraviewgettingstartedguide "GettingStarted.pdf")
  endif ()

  if (paraview_data_dir)
    paraview_install_data(paraviewtutorialdata "examples/")
  endif ()

  if (paraview_materials_dir)
    paraview_install_materials(ospraymaterials "materials/")
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

    if (NOT qt5_version VERSION_LESS "5.10")
      list(APPEND qt5_plugins
        styles/qwindowsvistastyle)
    endif ()
  elseif (APPLE)
    list(APPEND qt5_plugins
      platforms/libqcocoa
      printsupport/libcocoaprintersupport)

    if (NOT qt5_version VERSION_LESS "5.10")
      list(APPEND qt5_plugins
        styles/libqmacstyle)
    endif ()
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
