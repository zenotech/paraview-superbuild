if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  superbuild_append_flags(
    c_flags   "-diag-disable=11074,11076"
    PROJECT_ONLY)
  superbuild_append_flags(
    cxx_flags "-diag-disable=68,177,188,191,597,654,873,1098,1125,1292,1875,2026,3373,3656,3884,11074,11076"
    PROJECT_ONLY)
endif ()

# Check the target processor to configure LLVM properly. Possible
# targets are: AArch64, AMDGPU, ARM, BPF, Hexagon, Mips, MSP430,
# NVPTX, PowerPC, Sparc, SystemZ, X86, XCore.
# See https://llvm.org/docs/GettingStarted.html.
string(TOLOWER "${CMAKE_SYSTEM_PROCESSOR}" cmake_system_processor)
if (cmake_system_processor MATCHES "x.*64")
  set(target_architecture "X86")
elseif (cmake_system_processor MATCHES "ppc64")
  set(target_architecture "PowerPC")
else()
  message(FATAL_ERROR
    "Could not configure LLVM for the target system processor '${CMAKE_SYSTEM_PROCESSOR}'.")
endif()

superbuild_add_project(llvm
  CAN_USE_SYSTEM
  DEPENDS python cxx11
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=Release
    -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    -DLLVM_ENABLE_RTTI=ON
    -DLLVM_INSTALL_UTILS=ON
    -DLLVM_ENABLE_LIBXML2=OFF
    -DLLVM_TARGETS_TO_BUILD:STRING=${target_architecture}
    -DPYTHON_EXECUTABLE=${superbuild_python_executable})


superbuild_apply_patch(${project} workaround-intel-build-failures
  "Fix build failures with the Intel compiler")

set(llvm_dir "<INSTALL_DIR>")
