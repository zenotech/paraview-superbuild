superbuild_add_project(mili
  CAN_USE_SYSTEM
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    ""
)

set(_build_subdir <SOURCE_DIR>/MILI-build)

# Split out building of code into a separate step because the working
# directory is different from the configure step.
superbuild_project_add_step("custom-build"
  COMMAND
    make opt fortran=false
  COMMENT
    "Building mili"
  DEPENDEES
    configure
  WORKING_DIRECTORY
    ${_build_subdir}
)

# Mili's make install command is broken. Just grab what we need.
superbuild_project_add_step("custom-install"
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${_build_subdir}/lib_opt/libeprtf.a
    ${_build_subdir}/lib_opt/libmili.a
    ${_build_subdir}/lib_opt/libtaurus.a
    <INSTALL_DIR>/lib
  COMMAND ${CMAKE_COMMAND} -E make_directory
    <INSTALL_DIR>/include/mili
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    ${_build_subdir}/include/eprtf.h
    ${_build_subdir}/include/gahl.h
    ${_build_subdir}/include/list.h
    ${_build_subdir}/include/mili.h
    ${_build_subdir}/include/mili_endian.h
    ${_build_subdir}/include/mili_enum.h
    ${_build_subdir}/include/mili_fparam.h
    ${_build_subdir}/include/mili_internal.h
    ${_build_subdir}/include/misc.h
    ${_build_subdir}/include/mr.h
    ${_build_subdir}/include/partition.h
    ${_build_subdir}/include/sarray.h
    ${_build_subdir}/include/taurus_db.h
    <INSTALL_DIR>/include/mili
  COMMENT
    "Installing mili"
  DEPENDEES
    build
)

if (UNIX)
  superbuild_apply_patch(mili unix-patch1 "Mili Unix patch 1")
  if (APPLE)
    # Patches derived from VisIt build
    # https://portal.nersc.gov/project/visit/releases/3.0.0/build_visit3_0_0
    superbuild_apply_patch(mili darwin-patch1 "Mili Darwin patch 1")
    superbuild_apply_patch(mili darwin-patch2 "Mili Darwin patch 2")
    superbuild_apply_patch(mili darwin-patch3 "Mili Darwin patch 3")
  endif()

  superbuild_add_extra_cmake_args(
    -DMili_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/mili
    -DMili_LIBRARY:PATH=<INSTALL_DIR>/lib/libmili.a
  )
endif()
