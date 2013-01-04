# script to "bundle" paraview.

#------------------------------------------------------------------------------
# include common stuff.

# setting PARAVIEW_INSTALL_MANUAL_PDF ensures that paraview.bundle.common
# will download and install the manual pdf.
set (PARAVIEW_INSTALL_MANUAL_PDF TRUE)
include(paraview.bundle.common)

# set NSIS install specific stuff.

# URL to website providing assistance in installing your application.
set (CPACK_NSIS_HELP_LINK "http://paraview.org/Wiki/ParaView")
set (CPACK_NSIS_MENU_LINKS
  "doc/ParaViewManual.v${pv_version}.pdf" "ParaView User's Manual"
  "bin/paraview.exe" "ParaView"
  "bin/pvserver.exe" "pvserver (Server)"
  "bin/pvdataserver.exe" "pvdataserver (Data-Server)"
  "bin/pvrenderserver.exe" "pvrenderserver (Render-Server)")
if (python_ENABLED)
  set (CPACK_NSIS_MENU_LINKS ${CPACK_NSIS_MENU_LINKS}
    "bin/pvpython.exe" "pvpython (Python Shell)")
endif()

#FIXME: need a pretty icon.
#set (CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_LIST_DIR}/paraview.ico")
#set (CPACK_NSIS_MUI_FINISHPAGE_RUN "bin/paraview.exe")

#------------------------------------------------------------------------------

# install paraview executables to bin.
foreach(executable
  paraview pvbatch pvdataserver pvpython pvrenderserver pvserver)
  install(PROGRAMS "${install_location}/bin/${executable}.exe"
    DESTINATION "bin"
    COMPONENT ParaView)
endforeach()

# install all dlls to bin. This will install all VTK/ParaView dlls plus any
# other tool dlls that were placed in bin.
install(DIRECTORY "${install_location}/bin/"
        DESTINATION "bin"
        USE_SOURCE_PERMISSIONS
        COMPONENT ParaView
        FILES_MATCHING PATTERN "*.dll")

# install the .plugins file
install(FILES "${install_location}/bin/.plugins"
        DESTINATION "bin"
        COMPONENT ParaView)

# install python since (since python dlls are not in the install location)
if (python_ENABLED AND NOT USE_SYSTEM_python)
  # install the Python's modules.
  install(DIRECTORY "${SuperBuild_BINARY_DIR}/python/src/python/Lib"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView)

  # install python dlls.
  get_filename_component(python_bin_dir "${pv_python_executable}" PATH)
  install(DIRECTORY "${python_bin_dir}/"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView
          FILES_MATCHING PATTERN "python*.dll")

  # install python pyd objects (python dlls).
  file(GLOB pyd_files
       "${SuperBuild_BINARY_DIR}/python/src/python/PCbuild/*.pyd")
  install(FILES ${pyd_files}
          DESTINATION "bin/Lib"
          COMPONENT ParaView)

endif()

if (numpy_ENABLED)
  install(DIRECTORY "${install_location}/lib/site-packages/numpy"
          DESTINATION "bin/Lib/site-packages"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView)
endif()

if (matplotlib_ENABLED)
  install(DIRECTORY "${install_location}/lib/site-packages/matplotlib"
          DESTINATION "bin/Lib/site-packages"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView)
endif()

if (qt_ENABLED AND NOT USE_SYSTEM_qt)
  install(DIRECTORY
    # install all qt plugins (including sqllite).
    # FIXME: we can reconfigure Qt to be built with inbuilt sqllite support to
    # avoid the need for plugins.
    "${install_location}/plugins/"
    DESTINATION "bin"
    COMPONENT ParaView
    PATTERN "*.dll")
endif()

# install paraview python modules and others.
install(DIRECTORY "${install_location}/lib/paraview-${pv_version}"
        DESTINATION "lib"
        USE_SOURCE_PERMISSIONS
        COMPONENT ParaView
        PATTERN "*.lib" EXCLUDE)

#-----------------------------------------------------------------------------
if (mpi_ENABLED AND NOT USE_SYSTEM_mpi)
  # install MPI executables (the dlls are already installed by a previous rule).
  install(DIRECTORY "${install_location}/bin/"
        DESTINATION "bin"
        USE_SOURCE_PERMISSIONS
        COMPONENT ParaView
        FILES_MATCHING
          PATTERN "mpiexec.exe"
          PATTERN "mpirun.exe"
          PATTERN "ompi*.exe"
          PATTERN "opal*.exe"
          PATTERN "orte*.exe"
        )
  # install the mpi configuration files needed for mpiexec.
  install(DIRECTORY "${install_location}/etc/"
          DESTINATION "etc"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView)
  install(DIRECTORY "${install_location}/share/openmpi"
          DESTINATION "share"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView)
endif()
#-----------------------------------------------------------------------------

# install system runtimes.
set(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION "bin")
include(InstallRequiredSystemLibraries)

#-----------------------------------------------------------------------------
# include CPack at end so that all COMPONENTs specified in install rules are
# correctly detected.
include(CPack)

#-----------------------------------------------------------------------------
#if (mpich2_ENABLED AND NOT USE_SYSTEM_mpich2)
#  install(PROGRAMS "@install_location@/bin/mpiexec.hydra"
#    DESTINATION "lib/paraview-${pv_version}"
#    COMPONENT ParaView
#    RENAME "mpiexec")
#  foreach (hydra_exe hydra_nameserver hydra_persist hydra_pmi_proxy)
#    install(PROGRAMS "@install_location@/bin/${hydra_exe}"
#      DESTINATION "lib/paraview-${pv_version}"
#      COMPONENT ParaView)
#  endforeach()
#endif()

add_test(NAME GenerateParaViewPackage-NSIS
         COMMAND ${CMAKE_CPACK_COMMAND} -G NSIS -V
         WORKING_DIRECTORY ${SuperBuild_BINARY_DIR})

add_test(NAME GenerateParaViewPackage-ZIP
         COMMAND ${CMAKE_CPACK_COMMAND} -G ZIP -V
         WORKING_DIRECTORY ${SuperBuild_BINARY_DIR})

set_tests_properties(GenerateParaViewPackage-NSIS
                     GenerateParaViewPackage-ZIP
                     PROPERTIES
                     # needed so that tests are run on typical paraview
                     # dashboards
                     LABELS "PARAVIEW"
                     TIMEOUT 1200) # increase timeout to 20 mins.
