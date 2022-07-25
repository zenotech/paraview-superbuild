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
set(CPACK_PACKAGE_VERSION_PATCH "${paraview_version_patch}")
# WiX does not support non-dotted version numbers. See below.
if (NOT cpack_generator STREQUAL "WIX")
  string(APPEND CPACK_PACKAGE_VERSION_PATCH "${paraview_version_suffix}")
endif ()
set(name_suffix "")
if (paraview_version_branch)
  set(name_suffix "-${paraview_version_branch}")
endif ()

if (NOT DEFINED package_filename)
  set(package_filename "${PARAVIEW_PACKAGE_FILE_NAME}")
endif ()

if (package_filename)
  set(CPACK_PACKAGE_FILE_NAME "${package_filename}")
else ()
  set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}${name_suffix}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")
  # Append the version suffix here though. See above.
  if (cpack_generator STREQUAL "WIX")
    string(APPEND CPACK_PACKAGE_FILE_NAME "${paraview_version_suffix}")
  endif ()
  if (PARAVIEW_PACKAGE_SUFFIX)
    string(APPEND CPACK_PACKAGE_FILE_NAME "-${PARAVIEW_PACKAGE_SUFFIX}")
  endif ()
endif ()

# Set the license file.
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_LIST_DIR}/files/paraview.license.txt")

set(paraview_executables
  pvdataserver
  pvrenderserver
  pvserver)
if (python3_enabled)
  list(APPEND paraview_executables
    pvbatch
    pvpython)
endif ()

set(paraview_has_gui FALSE)
if (qt5_enabled)
  list(APPEND paraview_executables
    paraview)
  set(paraview_has_gui TRUE)
endif ()

set(other_executables)
if (vrpn_enabled)
  list(APPEND other_executables
    vrpn_server)
endif()

if (ospraymodulempi_enabled)
  list(APPEND other_executables
    ospray_mpi_worker)
endif()

set(python_modules
  cinema_python
  pygments
  mpi4py)

if (paraview_is_shared)
  list(APPEND python_modules
    paraview
    vtk
    vtkmodules)
else()
  list(APPEND python_modules
    _paraview
    _vtk
    _paraview_modules_static
    _vtkmodules_static)
endif()

if (nlohmannjson_enabled)
  list(APPEND python_modules parflow)
endif()

macro (check_for_python_module project module)
  if (${project}_built_by_superbuild)
    list(APPEND python_modules
      "${module}")
  endif ()
endmacro ()

check_for_python_module(h5py h5py)
check_for_python_module(matplotlib matplotlib)
check_for_python_module(matplotlib mpl_toolkits)
check_for_python_module(numpy numpy)
check_for_python_module(numpy pkg_resources)
check_for_python_module(openpmd openpmd_api)
check_for_python_module(pythonaiohttp aiohttp)
check_for_python_module(pythonasynctimeout async_timeout)
check_for_python_module(pythonattrs attr)
check_for_python_module(pythonchardet chardet)
check_for_python_module(pythoncycler cycler)
check_for_python_module(pythoncython cython)
check_for_python_module(pythondateutil dateutil)
check_for_python_module(pythonidna idna)
check_for_python_module(pythonkiwisolver kiwisolver)
check_for_python_module(pythonmpmath mpmath)
check_for_python_module(pythonmultidict multidict)
check_for_python_module(pythonpandas pandas)
check_for_python_module(pythonpillow PIL)
check_for_python_module(pythonpygments pygments)
check_for_python_module(pythonpyparsing pyparsing)
check_for_python_module(pythonsix six)
check_for_python_module(pythontypingextensions typing_extensions)
check_for_python_module(pythonwslinkasync wslink)
check_for_python_module(pythonyarl yarl)
check_for_python_module(pytz pytz)
if (paraview_package_scipy_always OR
    (NOT cpack_generator STREQUAL "NSIS" AND
     NOT cpack_generator STREQUAL "WIX"))
  check_for_python_module(scipy scipy)
endif ()
check_for_python_module(sympy sympy)

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

set(paraview_plugins)
if (paraview_is_shared)
  file(STRINGS "${plugin_file}"
    paraview_plugin_lines
    REGEX "name=\"[A-Za-z0-9]+\"")
  foreach (paraview_plugin_line IN LISTS paraview_plugin_lines)
    string(REGEX REPLACE ".*name=\"\([A-Za-z0-9]+\)\".*" "\\1" paraview_plugin "${paraview_plugin_line}")
    list(APPEND paraview_plugins
      "${paraview_plugin}")
  endforeach ()
endif ()

if (ttk_enabled)
  list(APPEND paraview_plugins
    TopologyToolKit)
endif()

if (vortexfinder2_enabled)
  list(APPEND paraview_plugins
    VortexFinder)
endif ()
if (surfacetrackercut_enabled)
  list(APPEND paraview_plugins
    SurfaceTrackerCut)
endif()

# Sort list of plugins alphabetically
list(SORT paraview_plugins CASE INSENSITIVE)

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

function (paraview_install_kernels_nvidia_index project dir)
  if (${project}_enabled)
    install(
      DIRECTORY   "${superbuild_install_location}/${dir}"
      DESTINATION "${paraview_kernels_nvidia_index_dir}"
      COMPONENT   superbuild)
  endif ()
endfunction ()

function (paraview_install_license project)
  if (EXISTS "${superbuild_install_location}/share/licenses/${project}")
    install(
      DIRECTORY   "${superbuild_install_location}/share/licenses/${project}"
      DESTINATION "${paraview_license_path}"
      COMPONENT   superbuild)
  else ()
    message(FATAL_ERROR "${superbuild_install_location}/share/licenses/${project} does not exist, aborting.")
  endif ()
endfunction ()

function (paraview_install_all_licenses)
  set(license_projects "${enabled_projects}")

  foreach (project IN LISTS license_projects)
    if (NOT ${project}_built_by_superbuild)
      list(REMOVE_ITEM license_projects ${project})
    endif ()
  endforeach ()

  # Remove package without licenses
  list(REMOVE_ITEM license_projects
    ospraymaterials # CC0 License
    launchers # ParaView
    paraviewgettingstartedguide # ParaView
    paraviewtutorialdata # ParaView
    )

  # Do not install license of non-packaged projects
  list(REMOVE_ITEM license_projects
    gperf
    meson
    ninja
    pkgconf
    pythoncppy
    pythonmako
    pythonpkgconfig
    pythonpkgconfig
    pythonsemanticversion
    pythonsetuptools
    pythonsetuptoolsrust
    pythonsetuptoolsscm
    )

  # paraview install itself in ParaView directory
  if (paraview IN_LIST license_projects)
    list(REMOVE_ITEM license_projects paraview)
    list(APPEND license_projects ParaView)
  endif ()

  foreach (project IN LISTS license_projects)
    paraview_install_license("${project}")
  endforeach ()

  # When packaging system qt, install the license manually
  if (qt5_plugin_paths)
    install(
      FILES   "${superbuild_source_directory}/projects/files/Qt5.LICENSE.LGPLv3"
      DESTINATION "${paraview_license_path}/qt5"
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

  if (paraview_kernels_nvidia_index_dir)
    paraview_install_kernels_nvidia_index(
      nvidiaindex "share/paraview-${paraview_version}/kernels_nvidia_index/")
  endif ()

  paraview_install_all_licenses()

endfunction ()

if (qt5_enabled)
  include(qt5.functions)

  set(qt5_plugin_prefix)
  if (NOT WIN32)
    set(qt5_plugin_prefix "lib")
  endif ()

  # Add SVG support, so ParaView can use SVG icons
  set(qt5_plugins
    iconengines/${qt5_plugin_prefix}qsvgicon
    imageformats/${qt5_plugin_prefix}qsvg
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
