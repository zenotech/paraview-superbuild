# Enable CPack packaging.
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
  "ParaView Catalyst ${CATALYST_EDITION} for in-situ visualization")
set(CPACK_PACKAGE_NAME "ParaView-Catalyst-${CATALYST_EDITION}")
set(CPACK_PACKAGE_VENDOR "Kitware, Inc.")
set(CPACK_PACKAGE_VERSION_MAJOR ${pv_version_major})
set(CPACK_PACKAGE_VERSION_MINOR ${pv_version_minor})
if (pv_version_suffix)
  set(CPACK_PACKAGE_VERSION_PATCH ${pv_version_patch}-${pv_version_suffix})
else()
  set(CPACK_PACKAGE_VERSION_PATCH ${pv_version_patch})
endif()

set(CPACK_PACKAGE_FILE_NAME
  "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}-${PACKAGE_SUFFIX}")

# set the license file.
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_LIST_DIR}/../paraview.license.txt")

include(CPack)

set (pdf_pv_version "4.3")
# download an install manual pdf.
install(CODE "
  # create the doc directory.
  file(MAKE_DIRECTORY \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/doc\")

  # download the manual pdf.
  file(DOWNLOAD \"http://www.paraview.org/files/v${pdf_pv_version}/ParaViewCatalystUsersGuide_v2.pdf\"
    \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}/doc/ParaViewCatalystUsersGuide_v2.pdf\"
    SHOW_PROGRESS)
")

install (DIRECTORY "${install_location}/include/paraview-${pv_version}"
  DESTINATION include
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)
install (DIRECTORY "${install_location}/lib/cmake/paraview-${pv_version}"
  DESTINATION lib/cmake
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

# install python
if (python_ENABLED AND NOT USE_SYSTEM_python)
  install(DIRECTORY "${install_location}/lib/python2.7"
    DESTINATION "lib/paraview-${pv_version}/lib"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild)
  # install pyconfig.h
  install (DIRECTORY "${install_location}/include/python2.7"
    DESTINATION "lib/paraview-${pv_version}/include"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild
    PATTERN "pyconfig.h")
endif()

# install library dependencies for various executables.
# the dependencies are searched only under the <install_location> and hence
# system libraries are not packaged.
set (reference_executable pvserver)
if (CATALYST_PYTHON)
  set (reference_executable pvbatch)
endif()

install(CODE
  "execute_process(COMMAND
    ${CMAKE_COMMAND}
      -Dexecutable:PATH=${install_location}/lib/paraview-${pv_version}/${reference_executable}
      -Ddependencies_root:PATH=${install_location}
      -Dtarget_root:PATH=\${CMAKE_INSTALL_PREFIX}/lib/paraview-${pv_version}
      -Dpv_version:STRING=${pv_version}
      -P ${CMAKE_CURRENT_LIST_DIR}/install_dependencies.cmake)"
  COMPONENT superbuild)

# install executables
set (executables pvserver pvdataserver pvrenderserver paraview-config)
if (CATALYST_PYTHON)
  set (executables ${executables} pvbatch pvpython)
endif()

foreach(executable IN LISTS executables)
  install(PROGRAMS "${install_location}/bin/${executable}"
    DESTINATION "bin"
    COMPONENT superbuild)
endforeach()

if (mpi_ENABLED AND NOT USE_SYSTEM_mpi)
  install(PROGRAMS "${install_location}/bin/mpiexec.hydra"
    DESTINATION "lib/paraview-${pv_version}"
    COMPONENT superbuild
    RENAME "mpiexec")
  foreach (hydra_exe hydra_nameserver hydra_persist hydra_pmi_proxy)
    install(PROGRAMS "${install_location}/bin/${hydra_exe}"
      DESTINATION "lib/paraview-${pv_version}"
      COMPONENT superbuild)
  endforeach()
endif()

add_test(NAME GenerateParaViewCatalystPackage
         COMMAND ${CMAKE_CPACK_COMMAND} -G TGZ -V
         WORKING_DIRECTORY ${SuperBuild_BINARY_DIR})
set_tests_properties(GenerateParaViewCatalystPackage PROPERTIES
                     # needed so that tests are run on typical paraview
                     # dashboards
                     LABELS "PARAVIEW"
                     TIMEOUT 3600) # increase timeout to 60 mins.
