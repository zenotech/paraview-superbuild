if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  superbuild_append_flags(
    c_flags   "-diag-disable=11074,11076"
    PROJECT_ONLY)
  superbuild_append_flags(
    cxx_flags "-diag-disable=68,177,188,191,597,654,873,1098,1125,1292,1875,2026,3373,3656,3884,11074,11076"
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


superbuild_apply_patch(${project} workaround-intel-build-failures
  "Fix build failures with the Intel compiler")
superbuild_apply_patch(${project} fix-libxml2
  "Fix -lxml2-not-found problem")

set(llvm_dir "<INSTALL_DIR>")
