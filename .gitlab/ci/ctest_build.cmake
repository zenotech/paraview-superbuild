include("${CMAKE_CURRENT_LIST_DIR}/gitlab_ci.cmake")

# Read the files from the build directory.
ctest_read_custom_files("${CTEST_BINARY_DIRECTORY}")

# Pick up from where the configure left off.
ctest_start(APPEND)

include(ProcessorCount)
ProcessorCount(nproc)
if (NOT "$ENV{CTEST_MAX_PARALLELISM}" STREQUAL "")
  if (nproc GREATER "$ENV{CTEST_MAX_PARALLELISM}")
    set(nproc "$ENV{CTEST_MAX_PARALLELISM}")
  endif ()
endif ()

if (CTEST_CMAKE_GENERATOR STREQUAL "Unix Makefiles")
  set(CTEST_BUILD_FLAGS "-j${nproc} -l${nproc}")
elseif (CTEST_CMAKE_GENERATOR MATCHES "Ninja")
  set(CTEST_BUILD_FLAGS "-l${nproc}")
endif ()

set(targets_to_build "all")

set(num_warnings 0)
set(num_errors 0)
foreach (target IN LISTS targets_to_build)
    set(build_args)
    if (NOT target STREQUAL "all")
      list(APPEND build_args TARGET ${target})
    endif ()

    if (CTEST_CMAKE_GENERATOR MATCHES "Make")
      # Drop the `-i` flag without remorse.
      set(CTEST_BUILD_COMMAND "make -j 4 ${CTEST_BUILD_FLAGS}")

      if (NOT target STREQUAL "all")
          set(CTEST_BUILD_COMMAND "${CTEST_BUILD_COMMAND} ${target}")
      endif ()
    endif ()

    ctest_build(
        NUMBER_WARNINGS num_warnings_target
        NUMBER_ERRORS num_errors_target
        RETURN_VALUE    build_result
        ${build_args})

    math(EXPR num_warnings "${num_warnings} + ${num_warnings_target}")
    math(EXPR num_errors "${num_errors} + ${num_errors_target}")

    ctest_submit(PARTS Build)
endforeach ()

file(GLOB logs
  "${CTEST_BINARY_DIRECTORY}/superbuild/*/stamp/*-build-*.log"
  "${CTEST_BINARY_DIRECTORY}/superbuild/*/stamp/*-install-*.log")
if (logs)
  list(APPEND CTEST_NOTES_FILES ${logs})
  ctest_submit(PARTS Notes)
endif ()

include("${CMAKE_CURRENT_LIST_DIR}/ctest_annotation.cmake")
if (DEFINED build_id)
  ctest_annotation_report("${CTEST_BINARY_DIRECTORY}/annotations.json"
    "Build Errors (${num_errors})" "https://open.cdash.org/viewBuildError.php?buildid=${build_id}"
    "Build Warnings (${num_warnings})" "https://open.cdash.org/viewBuildError.php?type=1&buildid=${build_id}"
  )
endif ()

if (build_result)
  message(FATAL_ERROR
    "Failed to build")
endif ()
