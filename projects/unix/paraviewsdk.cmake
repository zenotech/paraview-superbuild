superbuild_add_dummy_project(paraviewsdk
  DEPENDS paraview)

function (paraviewsdk_check_system_usage project)
  if (${project}_enabled AND NOT USE_SYSTEM_${project})
    message(WARNING "Please use a system ${project} or disable ${project} to enable SDK deployment!")
  endif ()
endfunction ()

if (paraviewsdk_enabled)
  paraviewsdk_check_system_usage(qt4)
  paraviewsdk_check_system_usage(qt5)
  #paraviewsdk_check_system_usage(python)
  #paraviewsdk_check_system_usage(mpi)
endif ()
