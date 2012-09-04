# Consolidates platform independent stub for paraview.bundle.cmake files.

# We hardcode the version numbers since we cannot determine versions during
# configure stage.
set (pv_version_major 3)
set (pv_version_minor 14)
set (pv_version_patch 1)
set (pv_version_suffix dev)
set (pv_version "${pv_version_major}.${pv_version_minor}")

# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
  "ParaView is a scientific visualization tool.")
set(CPACK_PACKAGE_NAME "ParaView")
set(CPACK_PACKAGE_VENDOR "Kitware, Inc.")
set(CPACK_PACKAGE_VERSION_MAJOR ${pv_version_major})
set(CPACK_PACKAGE_VERSION_MINOR ${pv_version_minor})
if (pv_version_suffix)
  set(CPACK_PACKAGE_VERSION_PATCH ${pv_version_patch}-${pv_version_suffix})
else()
  set(CPACK_PACKAGE_VERSION_PATCH ${pv_version_patch})
endif()

set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${package_suffix}")

SET(CPACK_COMPONENTS_ALL "superbuild")
include(CPack)


# PARAVIEW_INSTALL_MANUAL_PDF is set before importing this file.
# This allows us to override the pdf downloading code for apple.
if (PARAVIEW_INSTALL_MANUAL_PDF)
  # download an install manual pdf.
  install(CODE "
    # create the doc directory.
    file(MAKE_DIRECTORY \"\${CMAKE_INSTALL_PREFIX}/doc\")

    # download the manual pdf.
    file(DOWNLOAD \"http://www.paraview.org/files/v${pv_version}/ParaViewUsersGuide.v${pv_version}.pdf\"
        \"\${CMAKE_INSTALL_PREFIX}/doc/ParaViewUsersGuide.v${pv_version}.pdf\"
        SHOW_PROGRESS)
  ")
endif()
