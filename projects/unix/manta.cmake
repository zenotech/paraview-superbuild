include("${CMAKE_CURRENT_LIST_DIR}/../manta.cmake")

superbuild_apply_patch(manta fix-missing-includes
  "Add missing includes of unistd.h")
superbuild_apply_patch(manta fix-missing-link
  "Link to the dl library")
