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

# Fix MSI patch version number limitations.
if (cpack_generator STREQUAL "WIX" AND
    CPACK_PACKAGE_VERSION_PATCH GREATER "65536")
  # We're using a date. Set the package number to a value that fits in 16bits
  # because Windows doesn't support it for MSI installers. Convert using:
  #   full:    20231231
  #   limited: __23123_
  # https://learn.microsoft.com/en-us/windows/win32/msi/productversion
  string(SUBSTRING "${CPACK_PACKAGE_VERSION_PATCH}" 2 5 CPACK_PACKAGE_VERSION_PATCH)
endif ()

# Set the license files.
set(CPACK_RESOURCE_FILE_LICENSE "${superbuild_install_location}/share/licenses/ParaView/Copyright.txt")
set(qt5_license_file "${CMAKE_CURRENT_LIST_DIR}/files/Qt5.LICENSE")
set(qt6_license_file "${CMAKE_CURRENT_LIST_DIR}/files/Qt6.LICENSE")

# Set the translations to bundle
set(paraview_languages fr_FR pt_BR tr_TR)

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
if (qt5_enabled OR qt6_enabled)
  list(APPEND paraview_executables
    paraview)
  set(paraview_has_gui TRUE)
endif ()

set(other_executables)
if (vrpn_enabled)
  list(APPEND other_executables
    vrpn_server)
endif()

if (collaborationserver_enabled)
  list(APPEND other_executables
    collaboration_server)
endif()

if (ospraymodulempi_enabled)
  list(APPEND other_executables
    ospray_mpi_worker)
endif()

set(python_modules
  cinema_python
  pygments
  mpi4py) # Comes from VTK or `pythonmpi4py`

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

check_for_python_module(catalyst catalyst)
check_for_python_module(catalyst catalyst_conduit)
check_for_python_module(h5py h5py)
check_for_python_module(matplotlib matplotlib)
check_for_python_module(matplotlib mpl_toolkits)
check_for_python_module(numpy numpy)
check_for_python_module(numpy pkg_resources)
check_for_python_module(openpmd openpmd_api)
check_for_python_module(pythonaiohttp aiohttp)
check_for_python_module(pythonaiosignal aiosignal)
check_for_python_module(pythonasynctimeout async_timeout)
check_for_python_module(pythonattrs attr)
check_for_python_module(pythoncftime cftime)
check_for_python_module(pythonchardet chardet)
check_for_python_module(pythoncharsetnormalizer charset_normalizer)
check_for_python_module(pythoncontourpy contourpy)
check_for_python_module(pythoncycler cycler)
check_for_python_module(pythoncython cython)
check_for_python_module(pythondateutil dateutil)
check_for_python_module(pythonfonttools fontTools)
check_for_python_module(pythonfrozenlist frozenlist)
check_for_python_module(pythonidna idna)
check_for_python_module(pythonkiwisolver kiwisolver)
check_for_python_module(pythonmpmath mpmath)
check_for_python_module(pythonmultidict multidict)
check_for_python_module(pythonnetcdf4 netCDF4)
check_for_python_module(pythonpackaging packaging)
check_for_python_module(pythonpandas pandas)
check_for_python_module(pythonpillow PIL)
check_for_python_module(pythonpygments pygments)
check_for_python_module(pythonpyparsing pyparsing)
check_for_python_module(pythonsix six)
check_for_python_module(pythontypingextensions typing_extensions)
check_for_python_module(pythontzdata tzdata)
check_for_python_module(pythonversioneer versioneer)
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

list(APPEND python_modules ${paraview_additional_python_modules})

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
if (NOT DEFINED paraview_plugin_package_path)
  set(paraview_plugin_package_path "${paraview_plugin_path}")
endif ()
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

if (medreader_enabled)
  list(APPEND paraview_plugins
    MEDReader)
endif()

if (ttk_enabled)
  list(APPEND paraview_plugins
    TopologyToolKit)
endif()

if (vortexfinder2_enabled)
  list(APPEND paraview_plugins
    VortexFinder)
endif ()
if (cinemaexport_enabled)
  list(APPEND paraview_plugins
    CinemaExport)
endif ()
if (surfacetrackercut_enabled)
  list(APPEND paraview_plugins
    SurfaceTrackerCut)
endif()

list(APPEND paraview_plugins ${paraview_additional_plugins})

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
    message(FATAL_ERROR
      "${superbuild_install_location}/share/licenses/${project} does not exist, aborting.")
  endif ()
endfunction ()

function (paraview_install_spdx project)
  if (EXISTS "${superbuild_install_location}/share/doc/${project}/spdx/${project}.spdx")
    install(
      FILES   "${superbuild_install_location}/share/doc/${project}/spdx/${project}.spdx"
      DESTINATION "${paraview_spdx_path}/spdx"
      COMPONENT   superbuild)
  else ()
    message(FATAL_ERROR "${superbuild_install_location}/share/doc/${project}/spdx/${project}.spdx does not exist, aborting.")
  endif ()
endfunction ()

function (paraview_install_xr_manifests)
  # Install XR json files
  if (NOT "XRInterface" IN_LIST paraview_plugins)
    return ()
  endif ()

  install(
    DIRECTORY "${superbuild_install_location}/${paraview_plugin_path}/XRInterface/"
    DESTINATION "${paraview_plugin_package_path}/XRInterface"
    COMPONENT "superbuild"
    FILES_MATCHING PATTERN "*.json")
endfunction ()

function (paraview_install_openxr_models)
  if (NOT "XRInterface" IN_LIST paraview_plugins)
    return ()
  endif ()

  if (openxrmodels_enabled)
    install(
      DIRECTORY   "${superbuild_install_location}/share/paraview-${paraview_version}/openxrmodels"
      DESTINATION "share/paraview-${paraview_version}"
      COMPONENT   superbuild)
  endif ()
endfunction ()

function (paraview_install_bivariate_textures)
  # Install texture files for BivariateRepresentations plugin
  if (NOT "BivariateRepresentations" IN_LIST paraview_plugins)
    return ()
  endif ()

  if (NOT EXISTS "${superbuild_install_location}/${paraview_plugin_path}/BivariateRepresentations/Resources")
    return ()
  endif ()

  install(
    DIRECTORY "${superbuild_install_location}/${paraview_plugin_path}/BivariateRepresentations/Resources"
    DESTINATION "${paraview_plugin_package_path}/BivariateRepresentations"
    COMPONENT "superbuild")
endfunction ()

function (paraview_install_paraview_modules_spdx_files)
  if (EXISTS "${superbuild_install_location}/share/doc/ParaView/spdx")
    install(
      DIRECTORY   "${superbuild_install_location}/share/doc/ParaView/spdx"
      DESTINATION "${paraview_spdx_path}"
      COMPONENT   superbuild)
  else ()
    message(FATAL_ERROR
      "${superbuild_install_location}/share/doc/ParaView/spdx does not exist, aborting.")
  endif ()
endfunction ()

#[==[.md
paraview_install_translations
Description:
  Install all needed translation files from both qt and
  paraview-translations.
Arguments:
  project: The name of the project holding ParaView translations.
  dir: The destination directory for translations.

#]==]
function (paraview_install_translations project dir)
  if (${project}_enabled)
    foreach(_language IN LISTS paraview_languages)
      install(
        FILES   "${superbuild_install_location}/share/${dir}paraview_${_language}.qm"
        DESTINATION "${paraview_translations_dir}"
        COMPONENT   superbuild)
      # Get the language code without the country code
      string(REGEX MATCH "^([a-z]+)"
        _language_code "${_language}")
      foreach(_translation_qm IN ITEMS qtbase  qt  qtmultimedia  qtscript  qtxmlpatterns)
        if (EXISTS "${superbuild_install_location}/share/${dir}${_translation_qm}_${_language_code}.qm")
          install(
            FILES   "${superbuild_install_location}/share/${dir}${_translation_qm}_${_language_code}.qm"
            DESTINATION "${paraview_translations_dir}"
            COMPONENT   superbuild)
        endif ()
      endforeach()
    endforeach()
  endif ()
endfunction ()

macro (remove_not_packaged_projects)
  foreach (project IN LISTS packaged_projects)
    if (NOT ${project}_built_by_superbuild)
      list(REMOVE_ITEM packaged_projects ${project})
    endif ()
  endforeach ()

  # Remove package without licenses
  list(REMOVE_ITEM packaged_projects
    exodus # dummy project to enable the library in the seacas build
    ospraymaterials # CC0 License
    launchers # ParaView
    paraviewgettingstartedguide # ParaView
    paraviewtutorialdata # ParaView
    )

  # Do not install license of non-packaged projects
  list(REMOVE_ITEM packaged_projects
    gperf
    libxslt
    medconfiguration
    meson
    ninja
    pkgconf
    pythoncppy
    pythonflitcore
    pythonhatchfancypypireadme
    pythonhatchling
    pythonhatchvcs
    pythonmako
    pythonmarkupsafe
    pythonmesonpython
    pythonpkgconfig
    pythonpluggy
    pythonpyprojectmetadata
    pythontomli
    pythontroveclassifiers
    pythonsemanticversion
    pythonsetuptools
    pythonsetuptoolsrust
    pythonsetuptoolsscm
    )
endmacro ()

function (paraview_install_all_licenses)
  # Recover a list of packaged projects
  set(packaged_projects "${enabled_projects}")
  remove_not_packaged_projects()

  # paraview install itself in ParaView directory
  if (paraview IN_LIST packaged_projects)
    list(REMOVE_ITEM packaged_projects paraview)
    list(APPEND packaged_projects ParaView)
  endif ()

  foreach (project IN LISTS packaged_projects)
    paraview_install_license("${project}")
  endforeach ()

  # When packaging system qt, install the license manually
  if (qt5_plugin_paths)
    install(
      FILES       "${qt5_license_file}"
      DESTINATION "${paraview_license_path}/qt5"
      COMPONENT   superbuild)
  endif ()
  if (qt6_plugin_paths)
    install(
      FILES       "${qt6_license_file}"
      DESTINATION "${paraview_license_path}/qt6"
      COMPONENT   superbuild)
  endif ()
endfunction ()

function (paraview_install_all_spdx_files)
  # paraview install module SPDX files in ParaView directory
  paraview_install_paraview_modules_spdx_files()

  # Recover a list of packaged projects
  set(packaged_projects "${enabled_projects}")
  remove_not_packaged_projects()

  # paraview install many .spdx files instead
  if (paraview IN_LIST packaged_projects)
    list(REMOVE_ITEM packaged_projects paraview)
  endif ()

  foreach (project IN LISTS packaged_projects)
    paraview_install_spdx("${project}")
  endforeach ()
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
  # SPDX is only generated if Python is enabled.
  if (python3_enabled AND GENERATE_SPDX)
    paraview_install_all_spdx_files()
  endif ()

  if (paraview_translations_dir AND (qt5_enabled OR qt6_enabled))
    paraview_install_translations(paraviewtranslations "translations/")
  endif()

  paraview_install_xr_manifests()
  paraview_install_openxr_models()
  paraview_install_bivariate_textures()
endfunction ()

if (qt5_enabled AND (NOT USE_SYSTEM_qt5 OR PACKAGE_SYSTEM_QT))
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

    if (qt5_ENABLE_MULTIMEDIA)
      list(APPEND qt5_plugins
        audio/libqtaudio_alsa)
    endif ()
  endif ()

  superbuild_get_qt5_plugin_install_paths(qt5_plugin_paths ${qt5_plugins})
else ()
  set(qt5_plugin_paths)
endif ()

if (qt6_enabled AND (NOT USE_SYSTEM_qt6 OR PACKAGE_SYSTEM_QT))
  include(qt6.functions)

  set(qt6_plugin_prefix)
  if (NOT WIN32)
    set(qt6_plugin_prefix "lib")
  endif ()

  # Add SVG support, so ParaView can use SVG icons
  set(qt6_plugins
    iconengines/${qt6_plugin_prefix}qsvgicon
    imageformats/${qt6_plugin_prefix}qsvg
    sqldrivers/${qt6_plugin_prefix}qsqlite)

  if (WIN32)
    list(APPEND qt6_plugins
      platforms/qwindows
      styles/qmodernwindowsstyle)
  elseif (APPLE)
    list(APPEND qt6_plugins
      platforms/libqcocoa
      styles/libqmacstyle)
  elseif (UNIX)
    list(APPEND qt6_plugins
      egldeviceintegrations/libqeglfs-x11-integration
      generic/libqevdevkeyboardplugin
      generic/libqevdevmouseplugin
      platforms/libqxcb
      platforminputcontexts/libcomposeplatforminputcontextplugin
      xcbglintegrations/libqxcb-egl-integration
      xcbglintegrations/libqxcb-glx-integration)
  endif ()

  superbuild_get_qt6_plugin_install_paths(qt6_plugin_paths ${qt6_plugins})
else ()
  set(qt6_plugin_paths)
endif ()

if (socat_built_by_superbuild)
  include(socat.bundle)
endif ()

foreach (bundle_file IN LISTS paraview_additional_bundle_files)
  include(${bundle_file})
endforeach ()
