superbuild_add_project(catalyst
  CAN_USE_SYSTEM
  DEPENDS
    cxx11
  DEPENDS_OPTIONAL
    mpi
    numpy
  LICENSE_FILES
    License.txt
    3rdPartyLicenses.txt
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCATALYST_BUILD_TESTING:BOOL=OFF
    -DCATALYST_WRAP_PYTHON:BOOL=${numpy_enabled} # numpy is required by python wrappings on conduit
    -DCATALYST_WRAP_FORTRAN:BOOL=OFF
    -DCATALYST_USE_MPI:STRING=${mpi_enabled})
