# script to "bundle" paraview.
#include(GetPrerequisites)

# since ParaView uses shared forwarding, locate the real paraview executable.
set (required_libraries)
#get_prerequisites("@install_location@/lib/paraview-3.12/paraview"
#  # prerequisites_var
#  required_libraries
#  # execlude_system
#  1
#  # recurse
#  1
#  # exepath -- used on mac, so ignore.
#  "@install_location@/lib/paraview-3.12"
#  # dirs>
#  "@install_location@/lib"
#  )

# install all ParaView's libs
install(DIRECTORY "@install_location@/lib/paraview-3.12"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

# install all libs Paraview depends on.
#install(FILES ${required_libraries}
#  DESTINATION "lib/paraview-3.12"
#  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ
#  COMPONENT superbuild)

# simply install everything in "lib".
install(DIRECTORY
    # install all dependencies built
    "@install_location@/lib/"
    # install all qt plugins (including sqllite).
    # FIXME: we can reconfigure Qt to be built with inbuilt sqllite support to 
    # avoid the need for plugins.
    "@install_location@/plugins/"
  DESTINATION "lib/paraview-3.12"
  COMPONENT superbuild
  PATTERN "*.a" EXCLUDE
  PATTERN "*.la" EXCLUDE
  PATTERN "paraview-3.12" EXCLUDE
  PATTERN "fontconfig" EXCLUDE)

# install python
#if (ENABLE_PYTHON)
#  install(DIRECTORY "@install_location@/lib/python2.7"
#    DESTINATION "lib/paraview-3.12"
#    USE_SOURCE_PERMISSIONS
#    COMPONENT superbuild)
#endif()

# install executables
foreach(executable
  paraview pvbatch pvblot pvdataserver pvpython pvrenderserver pvserver)
  install(PROGRAMS "@install_location@/bin/${executable}"
    DESTINATION "bin"
    COMPONENT superbuild)
endforeach()

if (ENABLE_MPICH2)
  install(PROGRAMS "@install_location@/bin/mpiexec.hydra"
    DESTINATION "lib/paraview-3.12"
    COMPONENT superbuild
    RENAME "mpiexec")
  foreach (hydra_exe hydra_nameserver hydra_persist hydra_pmi_proxy)
    install(PROGRAMS "@install_location@/bin/${hydra_exe}"
      DESTINATION "lib/paraview-3.12"
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
SET(CPACK_PACKAGE_VERSION_PATCH 0)
SET(CPACK_COMPONENTS_ALL "superbuild")
INCLUDE(CPack)
