superbuild_add_project(cinemaexport
  LICENSE_FILES
    license.md
  SPDX_LICENSE_IDENTIFIER
    "BSD-3-Clause-LANL-USGov"
  SPDX_COPYRIGHT_TEXT
    Copyright (c) 2024, Triad National Security, LLC
  DEPENDS paraview embree
  DEPENDS_OPTIONAL openmp
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_LIBDIR:PATH=lib
    -DUSE_EMBREE3:BOOL=ON
  )
