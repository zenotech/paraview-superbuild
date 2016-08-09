# script to "bundle" paraview.
include(paraview.bundle.common)
include(CPack)

# install all ParaView's shared libraries.
install(DIRECTORY "${install_location}/lib/paraview-${pv_version}"
  DESTINATION "lib"
  USE_SOURCE_PERMISSIONS
  COMPONENT superbuild)

if (paraviewgettingstartedguide_ENABLED)
  install(FILES ${paraviewgettingstartedguide_pdf}
          DESTINATION "share/paraview-${pv_version}/doc"
          COMPONENT superbuild)
endif()
if (paraviewusersguide_ENABLED)
  install(FILES ${paraviewusersguide_pdf}
          DESTINATION "share/paraview-${pv_version}/doc"
          COMPONENT superbuild)
endif()
if (paraviewtutorial_ENABLED)
  install(FILES ${paraviewtutorial_pdf}
          DESTINATION "share/paraview-${pv_version}/doc"
          COMPONENT superbuild)
endif()
if (paraviewtutorialdata_ENABLED)
  install(DIRECTORY "${install_location}/data"
          DESTINATION "share/paraview-${pv_version}"
          USE_SOURCE_PERMISSIONS
          COMPONENT superbuild)
endif()

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

if (ospray_ENABLED)
  install(DIRECTORY "${install_location}/lib/"
    DESTINATION "lib/paraview-${pv_version}"
    FILES_MATCHING PATTERN "libospray*")
endif()

# For linux, we optionally support bundling pre-built mesa binaries.
option(BUNDLE_PREBUILT_MESA_BINARIES
  "Enable to package prebuilt mesa binaries" OFF)
mark_as_advanced(BUNDLE_PREBUILT_MESA_BINARIES)

function(download_if_not_present url dest)
  if(NOT EXISTS "${dest}")
    file(DOWNLOAD "${url}" "${dest}" SHOW_PROGRESS)
  endif()
endfunction()

if (BUNDLE_PREBUILT_MESA_BINARIES)
  file(MAKE_DIRECTORY "${SuperBuild_BINARY_DIR}/mesa-downloads")
  download_if_not_present(
    "http://www.paraview.org/files/dependencies/mesa-llvm.tar.gz"
    "${SuperBuild_BINARY_DIR}/mesa-downloads/mesa-llvm.tar.gz")
  download_if_not_present(
    "http://www.paraview.org/files/dependencies/mesa-swr-avx.tar.gz"
    "${SuperBuild_BINARY_DIR}/mesa-downloads/mesa-swr-avx.tar.gz")
  download_if_not_present(
    "http://www.paraview.org/files/dependencies/mesa-swr-avx2.tar.gz"
    "${SuperBuild_BINARY_DIR}/mesa-downloads/mesa-swr-avx2.tar.gz")
  execute_process(
    COMMAND ${CMAKE_COMMAND} -E tar xzf mesa-llvm.tar.gz
    COMMAND ${CMAKE_COMMAND} -E tar xzf mesa-swr-avx.tar.gz
    COMMAND ${CMAKE_COMMAND} -E tar xzf mesa-swr-avx2.tar.gz
    WORKING_DIRECTORY ${SuperBuild_BINARY_DIR}/mesa-downloads)
  install(DIRECTORY ${SuperBuild_BINARY_DIR}/mesa-downloads/
          DESTINATION "lib/paraview-${pv_version}"
          PATTERN "*.tar.gz" EXCLUDE)
endif()

add_test(NAME GenerateParaViewPackage
         COMMAND ${CMAKE_CPACK_COMMAND} -G TGZ -V
         WORKING_DIRECTORY ${SuperBuild_BINARY_DIR})
set_tests_properties(GenerateParaViewPackage PROPERTIES
                     # needed so that tests are run on typical paraview
                     # dashboards
                     LABELS "PARAVIEW"
                     TIMEOUT 3600) # increase timeout to 60 mins.
