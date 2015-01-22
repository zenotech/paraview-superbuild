if (APPLE)
  message(FATAL_ERROR "ABORT")
endif()

if(BUILD_SHARED_LIBS)
  set(shared_args --enable-shared --disable-static)
else()
  set(shared_args --disable-shared --enable-static)
endif()

add_external_project_or_use_system(python
  DEPENDS bzip2 zlib png
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --enable-unicode
                    ${shared_args}
  )
if (NOT CROSS_BUILD_STAGE STREQUAL "CROSS")
  # Pass the -rpath flag when building python to avoid issues running the
  # executable we built.
  append_flags(LDFLAGS "-Wl,-rpath,${install_location}/lib" PROJECT_ONLY)
endif()

set (pv_python_executable "${install_location}/bin/python" CACHE INTERNAL "" FORCE)

add_extra_cmake_args(
  -DVTK_PYTHON_VERSION=2.7
)
