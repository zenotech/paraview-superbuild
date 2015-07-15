# script to "bundle" paraview.

# setting PARAVIEW_INSTALL_MANUAL_PDF ensures that paraview.bundle.common
# will download and install the manual pdf.
set (PARAVIEW_INSTALL_MANUAL_PDF TRUE)
include(paraview.bundle.common)
include(CPack)

# install all ParaView's shared libraries.
install(DIRECTORY "${install_location}/lib/paraview-${pv_version}"
  DESTINATION "lib"
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
if (python_ENABLED)
  set (reference_executable pvbatch)
endif()
if (qt4_ENABLED OR qt5_ENABLED)
  set (reference_executable paraview)
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

# simply other miscellaneous dependencies.

if ((qt4_ENABLED AND NOT USE_SYSTEM_qt4) OR (qt5_ENABLED AND NOT USE_SYSTEM_qt))
  install(DIRECTORY
    # install all qt plugins (including sqllite).
    # FIXME: we can reconfigure Qt to be built with inbuilt sqllite support to
    # avoid the need for plugins.
    "${install_location}/plugins/"
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
set (executables pvserver pvdataserver pvrenderserver)
if (python_ENABLED)
  set (executables ${executables} pvbatch pvpython)
  # we are not building pvblot for now. Disable it.
  # set (executables ${executables} pvblot)
endif()
if (qt4_ENABLED OR qt5_ENABLED)
  set (executables ${executables} paraview)
endif()

foreach(executable ${executables})
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

if (qt4_ENABLED OR qt5_ENABLED)
  install(DIRECTORY "${install_location}/share/appdata"
    DESTINATION "share"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild)
  install(DIRECTORY "${install_location}/share/applications"
    DESTINATION "share"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild)
  install(DIRECTORY "${install_location}/share/icons"
    DESTINATION "share"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild)
endif ()

# Add ParaViewWeb www directory if available
if(python_ENABLED)
  install(DIRECTORY "${install_location}/share/paraview-${pv_version}/www"
    DESTINATION "share/paraview-${pv_version}"
    USE_SOURCE_PERMISSIONS
    COMPONENT superbuild)
endif()

add_test(NAME GenerateParaViewPackage
         COMMAND ${CMAKE_CPACK_COMMAND} -G TGZ -V
         WORKING_DIRECTORY ${SuperBuild_BINARY_DIR})
set_tests_properties(GenerateParaViewPackage PROPERTIES
                     # needed so that tests are run on typical paraview
                     # dashboards
                     LABELS "PARAVIEW"
                     TIMEOUT 3600) # increase timeout to 60 mins.
