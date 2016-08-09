# script to "bundle" paraview.

#------------------------------------------------------------------------------
# include common stuff.
include(paraview.bundle.common)

# set NSIS install specific stuff.

# URL to website providing assistance in installing your application.
set (CPACK_NSIS_HELP_LINK "http://paraview.org/Wiki/ParaView")
set (CPACK_NSIS_MENU_LINKS
  "bin/paraview.exe" "ParaView ${pv_version_long}"
  "bin/pvserver.exe" "pvserver ${pv_version_long} (Server)"
  "bin/pvdataserver.exe" "pvdataserver ${pv_version_long} (Data-Server)"
  "bin/pvrenderserver.exe" "pvrenderserver ${pv_version_long} (Render-Server)")
if (python_ENABLED)
  set (CPACK_NSIS_MENU_LINKS ${CPACK_NSIS_MENU_LINKS}
    "bin/pvpython.exe" "pvpython ${pv_version_long} (Python Shell)")
endif()
if (paraviewgettingstartedguide_ENABLED)
  list(APPEND CPACK_NSIS_MENU_LINKS
    "doc/GettingStarted.pdf" "ParaView Getting Started Guide ${pv_version_long}")
  install(FILES ${paraviewgettingstartedguide_pdf} DESTINATION "doc" COMPONENT ParaView)
endif()
if (paraviewusersguide_ENABLED)
  list(APPEND CPACK_NSIS_MENU_LINKS
       "doc/Guide.pdf" "ParaView Guide (CE) ${pv_version_long}")
  install(FILES ${paraviewusersguide_pdf} DESTINATION "doc" COMPONENT ParaView)
endif()
if (paraviewtutorial_ENABLED)
  list(APPEND CPACK_NSIS_MENU_LINKS
       "doc/Tutorial.pdf" "ParaView Tutorial ${pv_version_long}")
  install(FILES ${paraviewtutorial_pdf} DESTINATION "doc" COMPONENT ParaView)
endif()
if (paraviewtutorialdata_ENABLED)
  install(DIRECTORY "${install_location}/data/"
          DESTINATION "data"
          COMPONENT "ParaView")
endif()

#FIXME: need a pretty icon.
#set (CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_LIST_DIR}/paraview.ico")
#set (CPACK_NSIS_MUI_FINISHPAGE_RUN "bin/paraview.exe")

#------------------------------------------------------------------------------

# install paraview executables to bin.
foreach(executable
  paraview pvdataserver pvrenderserver pvserver)
  install(PROGRAMS "${install_location}/bin/${executable}.exe"
    DESTINATION "bin"
    COMPONENT ParaView)
endforeach()

if (python_ENABLED)
  foreach(executable
    pvbatch pvpython)
    install(PROGRAMS "${install_location}/bin/${executable}.exe"
      DESTINATION "bin"
      COMPONENT ParaView)
  endforeach()
endif()

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
  install(DIRECTORY "${install_location}/bin/Lib"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView)

  # install python dlls.
  install(DIRECTORY "${install_location}/bin/"
          DESTINATION "bin"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView
          FILES_MATCHING PATTERN "python*.dll")

  # Move the png and zlib dlls into the installed matplotlib package so that it
  # can find them at runtime.
  install(DIRECTORY "${install_location}/bin/"
          DESTINATION "bin/Lib/site-packages/matplotlib"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView
          FILES_MATCHING PATTERN "libpng*.dll")
  install(DIRECTORY "${install_location}/bin/"
          DESTINATION "bin/Lib/site-packages/matplotlib"
          USE_SOURCE_PERMISSIONS
          COMPONENT ParaView
          FILES_MATCHING PATTERN "zlib*.dll")
endif()

if ((qt4_ENABLED AND NOT USE_SYSTEM_qt4) OR (qt5_ENABLED AND NOT USE_SYSTEM_qt))
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

# install system runtimes.
set(CMAKE_INSTALL_SYSTEM_RUNTIME_DESTINATION "bin")
include(InstallRequiredSystemLibraries)

#-----------------------------------------------------------------------------
# include CPack at end so that all COMPONENTs specified in install rules are
# correctly detected.
include(CPack)

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
