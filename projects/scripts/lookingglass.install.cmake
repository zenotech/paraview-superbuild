set(dir "lib")
if (WIN32)
  set(dir "bin")
  file(GLOB files "${source_dir}/HoloPlayCore/dylib/Win64/*")
elseif (APPLE)
  file(GLOB files "${source_dir}/HoloPlayCore/dylib/macos/libHoloPlayCore.dylib")
else ()
  file(GLOB files "${source_dir}/HoloPlayCore/dylib/linux/*")
endif ()

file(INSTALL ${files}
  DESTINATION "${install_dir}/${dir}")

file(GLOB headers "${source_dir}/HoloPlayCore/include/*")
file(INSTALL ${headers}
  DESTINATION "${install_dir}/include")
