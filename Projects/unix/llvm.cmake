if(NOT python_version_minimum OR python_version_minimum LESS 2.7)
  set(python_version_minimum 2.7 CACHE INTERNAL "Minimum python version" FORCE)
endif()

# LLVM requires C++11 but CMake didn't gain enough knowledge on how to
# do that properly with the Intel compiler until 3.6
if(CMAKE_CXX_COMPILER_ID MATCHES "Intel" AND
  CMAKE_VERSION VERSION_LESS 3.6)
  message(FATAL_ERROR "Building LLVM with the Intel compiler requires CMake >= 3.6")
endif()

add_external_project_or_use_system(llvm
  DEPENDS python
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    -DLLVM_BUILD_LLVM_DYLIB=ON
    -DLLVM_ENABLE_RTTI=ON
    -DLLVM_INSTALL_UTILS=ON
    -DLLVM_TARGETS_TO_BUILD:STRING=X86 # when using this on PowerPC, this will
                                       # need to be updated.
)

# This has to go in the CXX_FLAGS explicitly to ensure it's correctly
# propogated to the output of llvm-config.  Using the CMake property
# for CXX_STANDARD=11 is insufficient.
append_flags(CMAKE_CXX_FLAGS "${CMAKE_CXX11_STANDARD_COMPILE_OPTION}" PROJECT_ONLY)

if(NOT USE_SYSTEM_llvm)
  set(LLVM_DIR "${install_location}" CACHE INTERNAL "")
endif()
