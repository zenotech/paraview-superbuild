if (NOT DEFINED "ENV{GITLAB_CI}")
  message(STATUS
    "This script is being run outside of GitLab-CI.")
else ()
  message(STATUS
    "This script is being run inside of GitLab-CI")
endif ()

# Set up the source and build paths.
if (NOT DEFINED "ENV{CI_PROJECT_DIR}")
  get_filename_component(project_dir "${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)
  set(CTEST_SOURCE_DIRECTORY "${project_dir}")
else()
  set(CTEST_SOURCE_DIRECTORY "$ENV{CI_PROJECT_DIR}")
endif()

set(CTEST_BINARY_DIRECTORY "${CTEST_SOURCE_DIRECTORY}/build")

if ("$ENV{CMAKE_CONFIGURATION}" STREQUAL "")
  message(FATAL_ERROR
    "The CMAKE_CONFIGURATION environment variable is required to know what "
    "cache initialization file to use.")
endif ()

# Set the build metadata.
set(CTEST_BUILD_NAME "$ENV{CI_PROJECT_NAME}-$ENV{CMAKE_CONFIGURATION}")
set(CTEST_SITE "gitlab-ci")

# Default to Release builds.
if (NOT "$ENV{CMAKE_BUILD_TYPE}" STREQUAL "")
  set(CTEST_BUILD_CONFIGURATION "$ENV{CMAKE_BUILD_TYPE}")
endif ()
if (NOT CTEST_BUILD_CONFIGURATION)
  set(CTEST_BUILD_CONFIGURATION "Release")
endif ()

# Default to using Ninja.
if (NOT "$ENV{CMAKE_GENERATOR}" STREQUAL "")
  set(CTEST_CMAKE_GENERATOR "$ENV{CMAKE_GENERATOR}")
endif ()
if (NOT CTEST_CMAKE_GENERATOR)
  set(CTEST_CMAKE_GENERATOR "Ninja")
endif ()

# Determine the track to submit to.
set(ctest_track "Experimental")
if (NOT "$ENV{CI_MERGE_REQUEST_ID}" STREQUAL "")
  if ("$ENV{CI_MERGE_REQUEST_TARGET_BRANCH_NAME}" STREQUAL "master")
    set(ctest_track "buildbot-packages")
  elseif ("$ENV{CI_MERGE_REQUEST_TARGET_BRANCH_NAME}" STREQUAL "release")
    set(ctest_track "buildbot-packages-release")
  endif ()
elseif ("$ENV{CI_PROJECT_PATH}" STREQUAL "paraview/paraview-superbuild")
  if ("$ENV{CI_COMMIT_REF_NAME}" STREQUAL "master")
    set(ctest_track "master-packages")
  elseif ("$ENV{CI_COMMIT_REF_NAME}" STREQUAL "release")
    set(ctest_track "release-packages")
  endif ()
endif ()
