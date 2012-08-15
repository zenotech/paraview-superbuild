# script to "bundle" paraview.

# We hardcode the version numbers since we cannot determine versions during
# configure stage.
set (pv_version_major 3)
set (pv_version_minor 14)
set (pv_version_patch 1)
set (pv_version_suffix dev)
set (pv_version "${pv_version_major}.${pv_version_minor}")

# install all ParaView's shared libraries.
install(DIRECTORY "@install_location@/lib/paraview-${pv_version}"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

# install python
if (python_ENABLED AND NOT USE_SYSTEM_python)
  install(DIRECTORY "@install_location@/lib/python2.7"
    DESTINATION "lib/paraview-${pv_version}/lib"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild)
  # install pyconfig.h
  install (DIRECTORY "@install_location@/include/python2.7"
    DESTINATION "lib/paraview-${pv_version}/include"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild
    PATTERN "pyconfig.h")
endif()

# install library dependencies for various executables.
# the dependencies are searched only under the <install_location> and hence
# system libraries are not packaged.
install(CODE
  "execute_process(COMMAND
    ${CMAKE_COMMAND}
      -Dexecutable:PATH=${install_location}/lib/paraview-${pv_version}/paraview
      -Ddependencies_root:PATH=${install_location}
      -Dtarget_root:PATH=\${CMAKE_INSTALL_PREFIX}/lib/paraview-${pv_version}
      -Dpv_version:STRING=${pv_version}
      -P ${CMAKE_CURRENT_LIST_DIR}/install_dependencies.cmake)"
  COMPONENT superbuild)

# simply other miscellaneous dependencies.

if (qt_ENABLED AND NOT USE_SYSTEM_qt)
  install(DIRECTORY
    # install all qt plugins (including sqllite).
    # FIXME: we can reconfigure Qt to be built with inbuilt sqllite support to 
    # avoid the need for plugins.
    "@install_location@/plugins/"
    DESTINATION "lib/paraview-${pv_version}"
    COMPONENT superbuild
    PATTERN "*.a" EXCLUDE
    PATTERN "paraview-${pv_version}" EXCLUDE
    PATTERN "fontconfig" EXCLUDE
    PATTERN "*.jar" EXCLUDE
    PATTERN "*.debug.*" EXCLUDE
    PATTERN "libboost*" EXCLUDE)
endif()

# install executables
foreach(executable
  paraview pvbatch pvblot pvdataserver pvpython pvrenderserver pvserver)
  install(PROGRAMS "@install_location@/bin/${executable}"
    DESTINATION "bin"
    COMPONENT superbuild)
endforeach()

if (mpich2_ENABLED AND NOT USE_SYSTEM_mpich2)
  install(PROGRAMS "@install_location@/bin/mpiexec.hydra"
    DESTINATION "lib/paraview-${pv_version}"
    COMPONENT superbuild
    RENAME "mpiexec")
  foreach (hydra_exe hydra_nameserver hydra_persist hydra_pmi_proxy)
    install(PROGRAMS "@install_location@/bin/${hydra_exe}"
      DESTINATION "lib/paraview-${pv_version}"
      COMPONENT superbuild)
  endforeach()
endif()

# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
  "ParaView is a scientific visualization tool.")
set(CPACK_PACKAGE_NAME "ParaView")
set(CPACK_PACKAGE_VENDOR "Kitware, Inc.")
set(CPACK_PACKAGE_VERSION_MAJOR ${pv_version_major})
set(CPACK_PACKAGE_VERSION_MINOR ${pv_version_minor})
if (pv_version_suffix)
  set(CPACK_PACKAGE_VERSION_PATCH ${pv_version_patch}-${pv_version_suffix})
  set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${pv_version_suffix}-${package_suffix}")
else()
  set(CPACK_PACKAGE_VERSION_PATCH ${pv_version_patch})
  set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${package_suffix}")
endif()

SET(CPACK_COMPONENTS_ALL "superbuild")
INCLUDE(CPack)
