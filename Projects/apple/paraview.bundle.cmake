# set extra cpack variables before calling paraview.bundle.common
set (CPACK_GENERATOR DragNDrop)

# include some common stub.
include(paraview.bundle.common)
include(CPack)

install(CODE
  "
  set(PV_PYTHON_LIB_INSTALL_PREFIX
  \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/Python\")
  "
  COMPONENT superbuild)

# now fixup each of the applications.
# we only to paraview explicitly.
install(CODE "
              file(INSTALL DESTINATION \"\${CMAKE_INSTALL_PREFIX}\" USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
                   \"${install_location}/Applications/paraview.app\")
              file(WRITE \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/Resources/qt.conf\"
                         \"\")
              execute_process(
                COMMAND ${CMAKE_CURRENT_LIST_DIR}/fixup_bundle.py
                        \"\${CMAKE_INSTALL_PREFIX}/paraview.app\"
                        \"${install_location}/lib\"
                        \"${install_location}/plugins\")
   "
   COMPONENT superbuild)

install(CODE "
              # install six.py
              file(GLOB six-files \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/Python/site-packages/six.py*\")
              file(INSTALL DESTINATION \"\${PV_PYTHON_LIB_INSTALL_PREFIX}\"
                   USE_SOURCE_PERMISSIONS FILES
                   \${six-files})
             "
        COMPONENT superbuild)

if (numpy_ENABLED)
  # install numpy module into the application bundle.
  install(CODE "
                # install numpy
                file(GLOB numpy-root \"${install_location}/lib/python*/site-packages/numpy\")
                file(INSTALL DESTINATION \"\${PV_PYTHON_LIB_INSTALL_PREFIX}\"
                     USE_SOURCE_PERMISSIONS TYPE DIRECTORY FILES
                     \"\${numpy-root}\")
               "
          COMPONENT superbuild)
endif()

#-----------------------------------------------------------------------------
if (mpi_ENABLED AND NOT USE_SYSTEM_mpi)
  # install MPI executables (the dylib are already installed by a previous rule).
  install(CODE "
     file(INSTALL
       DESTINATION \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/MacOS\"
       USE_SOURCE_PERMISSIONS
       FILES \"${install_location}/bin/hydra_pmi_proxy\")

     file(INSTALL
       DESTINATION \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/MacOS\"
       USE_SOURCE_PERMISSIONS
       FILES \"${install_location}/bin/mpiexec.hydra\")

     file(RENAME
       \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/MacOS/mpiexec.hydra\"
       \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/MacOS/mpiexec\")

     # Fixup MPI bundled libraries
     execute_process(
       COMMAND
         ${CMAKE_INSTALL_NAME_TOOL} -change
           \"${install_location}/lib/libmpl.1.dylib\"
           @executable_path/../Libraries/libmpl.1.dylib
           \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/MacOS/mpiexec\"
     )
     execute_process(
       COMMAND
         ${CMAKE_INSTALL_NAME_TOOL} -change
           \"${install_location}/lib/libmpl.1.dylib\"
           @executable_path/../Libraries/libmpl.1.dylib
           \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/MacOS/hydra_pmi_proxy\"
     )

  "
  COMPONENT superbuild)
endif()
#-----------------------------------------------------------------------------

if (matplotlib_ENABLED)
  # install matplotlib module into the application bundle.
  install(CODE "
                # install matplotlib
                file(GLOB matplotlib-root \"${install_location}/lib/python*/site-packages/matplotlib\")
                file(INSTALL
                  DESTINATION \"\${PV_PYTHON_LIB_INSTALL_PREFIX}\"
                  USE_SOURCE_PERMISSIONS
                  TYPE DIRECTORY
                  FILES \"\${matplotlib-root}\")

                # install libpng (needed for matplotlib)
                file(GLOB png-libs \"${install_location}/lib/libpng*dylib\")
                foreach(png-lib \${png-libs})
                  file(INSTALL
                    DESTINATION
                      \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/Libraries\"
                    USE_SOURCE_PERMISSIONS
                    TYPE SHARED_LIBRARY
                    FILES \"\${png-lib}\")
                endforeach()

                # install libfreetype (needed for matplotlib)
                file(GLOB freetype-libs \"${install_location}/lib/libfreetype*dylib\")
                foreach(freetype-lib \${freetype-libs})
                  file(INSTALL
                    DESTINATION
                      \"\${CMAKE_INSTALL_PREFIX}/paraview.app/Contents/Libraries\"
                    USE_SOURCE_PERMISSIONS
                    TYPE SHARED_LIBRARY
                    FILES \"\${freetype-lib}\")
                endforeach()

                # fixup matplotlib to find the bundled libraries.
                execute_process(
                  COMMAND
                    ${CMAKE_INSTALL_NAME_TOOL} -change
                      libpng14.14.dylib
                      @executable_path/../Libraries/libpng14.14.dylib
                      \"\${PV_PYTHON_LIB_INSTALL_PREFIX}/matplotlib/_png.so\"
                )
                execute_process(
                  COMMAND
                    ${CMAKE_INSTALL_NAME_TOOL} -change
                      \"${install_location}/lib/libfreetype.6.dylib\"
                      @executable_path/../Libraries/libfreetype.6.dylib
                      \"\${PV_PYTHON_LIB_INSTALL_PREFIX}/matplotlib/ft2font.so\"
                )
               "
          COMPONENT superbuild)
endif()

if (CUSTOMIZE_DMG)
  install(CODE "
               # put the dmg customizations into the package
               execute_process(
                 COMMAND ${CMAKE_COMMAND} -E tar xzv ${CMAKE_CURRENT_LIST_DIR}/dmg_customizer.tar.gz
                 WORKING_DIRECTORY \"\${CMAKE_INSTALL_PREFIX}\")
               "
          COMPONENT superbuild)
endif()

add_test(NAME GenerateParaViewPackage
         COMMAND ${CMAKE_CPACK_COMMAND} -G DragNDrop -V
         WORKING_DIRECTORY ${SuperBuild_BINARY_DIR})
set_tests_properties(GenerateParaViewPackage PROPERTIES
                     # needed so that tests are run on typical paraview
                     # dashboards
                     LABELS "PARAVIEW"
                     TIMEOUT 1200) # increase timeout to 20 mins.
