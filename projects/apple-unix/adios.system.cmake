find_program(ADIOS_CONFIG adios_config)
if (NOT ADIOS_CONFIG)
  message(FATAL_ERROR "Unable to locate adios_config")
endif ()

superbuild_add_extra_cmake_args(
  -DADIOS_CONFIG:FILEPATH=${ADIOS_CONFIG})
