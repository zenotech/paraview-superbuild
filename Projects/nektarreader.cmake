
#make a dummy nektar reader project so that the user can enable
#or disable building paraview with support for the reader
add_external_dummy_project(nektarreader
  DEPENDS lapack mpi
)
