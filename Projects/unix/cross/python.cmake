add_external_project(python
  CMAKE_ARGS
    -DCMAKE_TOOLCHAIN_FILE=${PYTHON_TOOLCHAIN_FILE}
    -DCMAKE_BUILD_TYPE:STRING=Release
    -DBUILD_SHARED=OFF
    -DBUILD_STATIC=ON
    -DPY_VERSION_PATCH=3
    -C ${SuperBuild_CMAKE_DIR}/crosscompile/python_modules.cmake
    ${PYTHON_OPTIONS}
    -C ${PYTHON_TRYRUN_FILE}
    ../$source
  )

set (pv_python_executable "${install_location}/bin/python" CACHE INTERNAL "" FORCE)
