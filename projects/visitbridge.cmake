if (UNIX AND NOT APPLE)
  superbuild_add_dummy_project(visitbridge
    DEPENDS boost glu)
else ()
  superbuild_add_dummy_project(visitbridge
    DEPENDS boost)
endif ()
