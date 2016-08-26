superbuild_add_project(genericio
  DEPENDS mpi
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_PROGRAMS:BOOL=OFF)

superbuild_apply_patch(genericio add-install-rules
  "Add proper install rules")
