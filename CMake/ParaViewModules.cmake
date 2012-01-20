include(PVExternalProject)
include(CMakeParseArguments)

function(add_project name)
  cmake_parse_arguments(arg "REQUIRED;DEFAULT_OFF" "" "DEPENDS" ${ARGN})

  string(TOUPPER ${name} UNAME)
  if (arg_REQUIRED)
    set(ENABLE_${UNAME} ON)
  else()
    if (NOT arg_DEFAULT_OFF)
      option(ENABLE_${UNAME} "Enable sub-project '${name}'" ON)
    else()
      option(ENABLE_${UNAME} "Enable sub-project '${name}'" OFF)
    endif()
    mark_as_advanced(ENABLE_${UNAME})
  endif()

  if (ENABLE_${UNAME})
    # verify each of the required dependencies is enabled.
    foreach (required_dependency IN LISTS arg_DEPENDS)
      string (TOUPPER ${required_dependency} UREQUIRED_DEPENDENCY)
      if (NOT ENABLE_${UREQUIRED_DEPENDENCY})
        message(WARNING
          "${name} needs ${required_dependency} which is OFF, however."
          "Ignoring ENABLE_${UNAME}.")
        set (ENABLE_${UNAME} OFF)
        break()
      endif()
    endforeach()
  endif()

  if (ENABLE_${UNAME})
    include("${name}")
  else ()
    # add dummy target to dependencies work even with subproject is disabled.
    add_custom_target(${name})
    SET (NO_${UNAME} TRUE)
  endif()
endfunction()

function(add_external_project name)
  set (cmake_params)
  foreach (flag CMAKE_BUILD_TYPE
                CMAKE_C_COMPILER
                CMAKE_C_FLAGS_DEBUG
                CMAKE_C_FLAGS_MINSIZEREL
                CMAKE_C_FLAGS_RELEASE
                CMAKE_C_FLAGS_RELWITHDEBINFO
                CMAKE_CXX_COMPILER
                CMAKE_CXX_FLAGS_DEBUG
                CMAKE_CXX_FLAGS_MINSIZEREL
                CMAKE_CXX_FLAGS_RELEASE
                CMAKE_CXX_FLAGS_RELWITHDEBINFO)
    if (${${flag}})
      set (cmake_params ${cmake_params} -D${flag}:STRING=${${flag}})
    endif()
  endforeach()

  PVExternalProject_Add(${name} ${ARGN}
    PREFIX ${name}
    DOWNLOAD_DIR ${download_location}
    INSTALL_DIR ${install_location}
    PROCESS_ENVIRONMENT
      LDFLAGS "${ldflags}"
      CPPFLAGS "${cppflags}"
      CXXFLAGS "${cxxflags}"
      CFLAGS "${cflags}"
      LD_LIBRARY_PATH "${ld_library_path}"
      CMAKE_PREFIX_PATH "${prefix_path}"
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${prefix_path}
      -DCMAKE_PREFIX_PATH:PATH=${prefix_path} 
      -DCMAKE_C_FLAGS:STRING=${cflags}
      -DCMAKE_CXX_FLAGS:STRING=${cppflags}
      -DCMAKE_SHARED_LINKER_FLAGS:STRING=${ldflags}
      ${cmake_params}
    )
endfunction()
