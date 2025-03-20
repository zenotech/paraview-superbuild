set(paraviewweb_depends)
if (WIN32)
  list(APPEND paraviewweb_depends
    pywin32)
endif ()

superbuild_add_dummy_project(paraviewweb
  DEPENDS
    python3
    paraviewwebglance
    ${paraviewweb_depends})
