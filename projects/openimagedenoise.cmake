superbuild_add_project(openimagedenoise
  DEPENDS tbb cxx11
)

superbuild_apply_patch(openimagedenoise fix-openmpsimd
    "Fix missing compiler flag in openimagedenoise")
