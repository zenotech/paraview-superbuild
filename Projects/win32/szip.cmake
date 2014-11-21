add_external_project(szip
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
  PATCH_COMMAND
		# BUG: szip does not install ricehdf.h
		# replace the file with an appropriate version.
	  ${CMAKE_COMMAND} -E copy_if_different ${SuperBuild_PROJECTS_DIR}/patches/szip.src.CMakeLists.txt
		                                      <SOURCE_DIR>/src/CMakeLists.txt
)

# any project depending on szip, inherits these cmake variables
add_extra_cmake_args(
    -DSZIP_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/szip.lib
    -DSZIP_INCLUDE_DIR:FILEPATH=<INSTALL_DIR>/include)

# get_filename_component on line 10 is missing the 'component' (path).
# this patch fixes that.
add_external_project_step(patch_fix_install
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
  ${SuperBuild_PROJECTS_DIR}/patches/szip.config.cmake.SZIP-config.cmake.install.in
  <SOURCE_DIR>/config/cmake/SZIP-config.cmake.install.in
  DEPENDEES update # do after update
  DEPENDERS patch  # do before patch
  )
