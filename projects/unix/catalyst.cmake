set(PARAVIEW_CATALYST_EDITION "Essentials"
  CACHE STRING "The catalyst edition to build")
set_property(CACHE PARAVIEW_CATALYST_EDITION
  PROPERTY
    STRINGS Essentials Extras Rendering-Base)
option(PARAVIEW_CATALYST_PYTHON "Enable Python support in catalyst" ON)

set(catalyst_editions Base)
if (PARAVIEW_CATALYST_PYTHON)
  list(APPEND catalyst_editions
    Enable-Python)
endif ()
if (PARAVIEW_CATALYST_EDITION STREQUAL "Essentials")
  list(APPEND catalyst_editions
    Essentials)
elseif (PARAVIEW_CATALYST_EDITION STREQUAL "Extras")
  list(APPEND catalyst_editions
    Essentials
    Extras)
elseif (PARAVIEW_CATALYST_EDITION STREQUAL "Rendering-Base")
  list(APPEND catalyst_editions
    Essentials
    Extras
    Rendering-Base)
  if (PARAVIEW_CATALYST_PYTHON)
    list(APPEND catalyst_editions
      Rendering-Base-Python)
  endif ()
elseif (catalyst_enabled)
  message(FATAL_ERROR "Unknown catalyst edition set: ${PARAVIEW_CATALYST_EDITION}")
endif ()

set(catalyst_edition_args)
foreach (catalyst_edition IN LISTS catalyst_editions)
  list(APPEND catalyst_edition_args
    -i <SOURCE_DIR>/Catalyst/Editions/${catalyst_edition})
endforeach ()

set(catalyst_cmake_args
  -G "${CMAKE_GENERATOR}"
  -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=TRUE
  -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  -DCMAKE_PREFIX_PATH:PATH=<INSTALL_DIR>
  -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
  -DCMAKE_C_FLAGS:STRING=${project_c_flags}
  -DCMAKE_CXX_FLAGS:STRING=${project_cxx_flags}
  -DCMAKE_SHARED_LINKER_FLAGS:STRING=${project_ld_flags})

superbuild_add_project(catalyst
  DEPENDS mpi python
  CONFIGURE_COMMAND
    ${pv_python_executable} <SOURCE_DIR>/Catalyst/catalyze.py
      ${catalyst_edition_args}
      -r <SOURCE_DIR>
      -o <TMP_DIR>/catalyzed
  BUILD_COMMAND
    <TMP_DIR>/catalyzed/cmake.sh
      --cmake=${CMAKE_COMMAND}
      ${catalyst_cmake_args}
      <TMP_DIR>/catalyzed
  INSTALL_COMMAND
    ${CMAKE_COMMAND}
      --build <BINARY_DIR>
      --target install
      -- -j${SUPERBUILD_PROJECT_PARALLELISM})
