include(paraview-version)

# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
  "ParaView is a scientific visualization tool.")
set(CPACK_PACKAGE_NAME "ParaView")
set(CPACK_PACKAGE_VENDOR "Kitware, Inc.")
set(CPACK_PACKAGE_VERSION_MAJOR "${paraview_version_major}")
set(CPACK_PACKAGE_VERSION_MINOR "${paraview_version_minor}")
set(CPACK_PACKAGE_VERSION_PATCH "${paraview_version_patch}${paraview_version_suffix}")
if (PARAVIEW_PACKAGE_SUFFIX)
  set(CPACK_PACKAGE_VERSION_PATCH "${CPACK_PACKAGE_VERSION_PATCH}-${PARAVIEW_PACKAGE_SUFFIX}")
endif ()

set(CPACK_PACKAGE_FILE_NAME
  "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

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
if (qt4_enabled OR qt5_enabled)
  list(APPEND paraview_executables
    paraview)
  set(paraview_has_gui TRUE)
endif ()

set(python_modules
  pygments
  six)

if (numpy_enabled AND NOT USE_SYSTEM_numpy)
  list(APPEND python_modules
    numpy)
endif ()

if (matplotlib_enabled AND NOT USE_SYSTEM_matplotlib)
  list(APPEND python_modules
    matplotlib)
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

if (paraview_doc_dir)
  paraview_install_pdf(paraviewgettingstartedguide "GettingStarted.pdf")
  paraview_install_pdf(paraviewusersguide "Guide.pdf")
  paraview_install_pdf(paraviewtutorial "Tutorial.pdf")
endif ()

if (paraview_data_dir)
  paraview_install_data(paraviewtutorialdata "data/")
endif ()
