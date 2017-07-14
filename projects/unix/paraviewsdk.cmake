superbuild_add_dummy_project(paraviewsdk
  DEPENDS paraview)

function (paraviewsdk_check_system_usage project)
  if (${project}_built_by_superbuild)
    message(FATAL_ERROR "Please use a system ${project} or disable ${project} to enable SDK deployment!")
  endif ()
endfunction ()

if (paraviewsdk_enabled)
  paraviewsdk_check_system_usage(qt5)
  paraviewsdk_check_system_usage(mpi)
endif ()
