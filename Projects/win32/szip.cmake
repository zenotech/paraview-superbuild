add_external_project(szip
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
  PATCH_COMMAND
		# BUG: szip does not install ricehdf.h
		# replace the file with an appropriate version.
	  ${CMAKE_COMMAND} -E copy_if_different ${ParaViewSuperBuild_PROJECTS_DIR}/patches/szip.src.CMakeLists.txt
		                                      <SOURCE_DIR>/src/CMakeLists.txt
)

# any project depending on szip, inherits these cmake variables
add_extra_cmake_args(
    -DSZIP_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/szip.lib
    -DSZIP_INCLUDE_DIR:FILEPATH=<INSTALL_DIR>/include)
