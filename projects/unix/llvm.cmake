superbuild_add_project(llvm
  CAN_USE_SYSTEM
  DEPENDS python cxx11
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    -DLLVM_BUILD_LLVM_DYLIB=ON
    -DLLVM_ENABLE_RTTI=ON
    -DLLVM_INSTALL_UTILS=ON
    -DLLVM_TARGETS_TO_BUILD:STRING=X86 # FIXME: When using this on PowerPC,
                                       #        this will need to be updated.
    -DPYTHON_EXECUTABLE=${superbuild_python_executable})

set(llvm_dir "<INSTALL_DIR>")
