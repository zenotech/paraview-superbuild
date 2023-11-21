find_package(CURL REQUIRED)

superbuild_add_extra_cmake_args(
  -DCURL_DIR:PATH=${CURL_DIR})
