add_external_project(python
  CMAKE_ARGS
    -DCMAKE_TOOLCHAIN_FILE=${PYTHON_TOOLCHAIN_FILE}
    -DCMAKE_BUILD_TYPE:STRING=Release
    -DPYTHON_BUILD_LIB_SHARED:BOOL=OFF
    -DWITH_THREAD:BOOL=0
    -DHAVE_GETGROUPS:BOOL=0
    -DHAVE_SETGROUPS:BOOL=0
    -DENABLE_IPV6:BOOL=0
    -C ${SuperBuild_CMAKE_DIR}/crosscompile/python_modules.cmake
    ${PYTHON_OPTIONS}
    -C ${PYTHON_TRYRUN_FILE}
    ../$source
  )

add_external_project_step(patch1
    COMMENT "CMakeifying."
    COMMAND sh "${SuperBuild_CMAKE_DIR}/crosscompile/patcher.sh" "<SOURCE_DIR>" -p4 "${SuperBuild_CMAKE_DIR}/crosscompile/add_cmake_files_to_python2-7-3.patch"
    DEPENDEES update
    DEPENDERS patch)

conditionally_patch_for_crosscompilation(Python)

set (pv_python_executable "${install_location}/bin/python" CACHE INTERNAL "" FORCE)
