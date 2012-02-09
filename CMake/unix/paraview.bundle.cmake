# script to "bundle" paraview.

# install all ParaView's shared libraries.
install(DIRECTORY "@install_location@/lib/paraview-3.14"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

# install python
if (ENABLE_PYTHON)
  install(DIRECTORY "@install_location@/lib/python2.7"
    DESTINATION "lib/paraview-3.14/lib"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild)
  # install pyconfig.h
  install (DIRECTORY "@install_location@/include/python2.7"
    DESTINATION "lib/paraview-3.14/include"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild
    PATTERN "pyconfig.h")
endif()

# install library dependencies for various executables.
install(CODE
  "execute_process(COMMAND
    ${CMAKE_COMMAND}
      -Dexecutable:PATH=${install_location}/lib/paraview-3.14/paraview
      -Ddependencies_root:PATH=${install_location}
      -Dtarget_root:PATH=\${CMAKE_INSTALL_PREFIX}/lib/paraview-3.14
      -P ${CMAKE_CURRENT_LIST_DIR}/install_dependencies.cmake)"
  COMPONENT superbuild)

# simply other miscellaneous dependencies.
install(DIRECTORY
    # install all qt plugins (including sqllite).
    # FIXME: we can reconfigure Qt to be built with inbuilt sqllite support to 
    # avoid the need for plugins.
    "@install_location@/plugins/"
  DESTINATION "lib/paraview-3.14"
  COMPONENT superbuild
  PATTERN "*.a" EXCLUDE
  PATTERN "paraview-3.14" EXCLUDE
  PATTERN "fontconfig" EXCLUDE
  PATTERN "*.jar" EXCLUDE
  PATTERN "*.debug.*" EXCLUDE
  PATTERN "libboost*" EXCLUDE)

# install executables
foreach(executable
  paraview pvbatch pvblot pvdataserver pvpython pvrenderserver pvserver)
  install(PROGRAMS "@install_location@/bin/${executable}"
    DESTINATION "bin"
    COMPONENT superbuild)
endforeach()

if (ENABLE_MPICH2)
  install(PROGRAMS "@install_location@/bin/mpiexec.hydra"
    DESTINATION "lib/paraview-3.14"
    COMPONENT superbuild
    RENAME "mpiexec")
  foreach (hydra_exe hydra_nameserver hydra_persist hydra_pmi_proxy)
    install(PROGRAMS "@install_location@/bin/${hydra_exe}"
      DESTINATION "lib/paraview-3.14"
      COMPONENT superbuild)
  endforeach()
endif()

# Enable CPack packaging.
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY
  "ParaView is a scientific visualization tool.")
SET(CPACK_PACKAGE_NAME "ParaView")
SET(CPACK_PACKAGE_VENDOR "Kitware, Inc.")
SET(CPACK_PACKAGE_VERSION_MAJOR 3)
SET(CPACK_PACKAGE_VERSION_MINOR 14)
SET(CPACK_PACKAGE_VERSION_PATCH "0-RC2")
SET(CPACK_COMPONENTS_ALL "superbuild")
INCLUDE(CPack)
