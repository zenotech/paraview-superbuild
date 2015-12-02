include(paraview-version)

set(paraview_doc_dir "share/paraview-${paraview_version}/doc")
set(paraview_data_dir "share/paraview-${paraview_version}/data")
include(paraview.bundle.common)

# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
  "ParaView Catalyst ${PARAVIEW_CATALYST_EDITION} for in-situ visualization")
set(CPACK_PACKAGE_NAME "ParaView-Catalyst-${PARAVIEW_CATALYST_EDITION}")

set(CPACK_PACKAGE_FILE_NAME
  "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${PACKAGE_SUFFIX}")

install(
  DIRECTORY   "${superbuild_install_location}/include/paraview-${paraview_version}"
  DESTINATION "include"
  USE_SOURCE_PERMISSIONS
  COMPONENT   "catalyst")
install(
  DIRECTORY   "${superbuild_install_location}/lib/cmake/paraview-${paraview_version}"
  DESTINATION "lib/cmake"
  USE_SOURCE_PERMISSIONS
  COMPONENT   "catalyst")

list(APPEND paraview_executables
  paraview-config)

set(paraview_component "catalyst")
include(paraview.bundle.unix)
