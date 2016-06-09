add_external_project_or_use_system(llvm
  DEPENDS zlib python
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
    -DLLVM_BUILD_LLVM_DYLIB=ON
    -DLLVM_ENABLE_RTTI=ON
    -DLLVM_INSTALL_UTILS=ON
    -DLLVM_TARGETS_TO_BUILD:STRING=X86 # when using this on PowerPC, this will
                                       # need to be updated.
    -DPYTHON_EXECUTABLE=${pv_python_executable}
)
if(NOT USE_SYSTEM_llvm)
  set(LLVM_DIR "${install_location}" CACHE INTERNAL "")
endif()
