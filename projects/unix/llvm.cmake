if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  superbuild_append_flags(
    cxx_flags "-diag-disable=177,597,873,1098,1292,2026,3373,3884"
    PROJECT_ONLY)
endif ()

superbuild_add_project(llvm
  CAN_USE_SYSTEM
  DEPENDS python cxx11
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=Release
    -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    -DLLVM_ENABLE_RTTI=ON
    -DLLVM_INSTALL_UTILS=ON
    -DLLVM_TARGETS_TO_BUILD:STRING=X86 # FIXME: When using this on PowerPC,
                                       #        this will need to be updated.
    -DPYTHON_EXECUTABLE=${superbuild_python_executable})


superbuild_apply_patch(${project} fix-static-assert
  "Fix the intel compiler being too sensitive about static asserts")

set(llvm_dir "<INSTALL_DIR>")
