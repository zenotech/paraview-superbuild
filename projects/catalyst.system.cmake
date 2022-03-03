find_package(catalyst COMPONENTS SDK REQUIRED)

superbuild_add_extra_cmake_args(-Dcatalyst_DIR=${catalyst_DIR})
