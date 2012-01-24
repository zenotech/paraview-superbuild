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
  COMPONENT runtime)

# install all libs Paraview depends on.
#install(FILES ${required_libraries}
#  DESTINATION "lib/paraview-3.12"
#  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ
#  COMPONENT runtime)

# simply install everything in "lib".
install(DIRECTORY "@install_location@/lib/"
  DESTINATION "lib/paraview-3.12"
  COMPONENT runtime
  PATTERN "paraview-3.12" EXCLUDE)

# install python
#if (ENABLE_PYTHON)
#  install(DIRECTORY "@install_location@/lib/python2.7"
#    DESTINATION "lib/paraview-3.12"
#    USE_SOURCE_PERMISSIONS
#    COMPONENT runtime)
#endif()

# install executables
foreach(executable
  paraview pvbatch pvblot pvdataserver pvpython pvrenderserver pvserver)
  install(PROGRAMS "@install_location@/bin/${executable}"
    DESTINATION "bin"
    COMPONENT runtime)
endforeach()

if (ENABLE_MPICH2)
  install(PROGRAMS "@install_location@/bin/mpiexec.hydra"
    DESTINATION "lib/paraview-3.12"
    COMPONENT runtime
    RENAME "mpiexec")
  install(DIRECTORY "@install_location@/bin/"
    DESTINATION "lib/paraview-3.12"
    USE_SOURCE_PERMISSIONS
    COMPONENT runtime
    PATTERN "hydra*")
endif()

# Enable CPack packaging.
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY
  "ParaView is a scientific visualization tool.")
SET(CPACK_PACKAGE_NAME "ParaView")
SET(CPACK_PACKAGE_VENDOR "Kitware, Inc.")
SET(CPACK_PACKAGE_VERSION_MAJOR 3)
SET(CPACK_PACKAGE_VERSION_MINOR 14)
SET(CPACK_PACKAGE_VERSION_PATCH 0)
INCLUDE(CPack)
