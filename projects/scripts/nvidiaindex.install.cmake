if (WIN32)
  set(dir "bin")
else ()
  set(dir "lib")
endif ()

file(GLOB files "${source_dir}/lib/*")
file(INSTALL ${files}
  DESTINATION "${install_dir}/${dir}")

# Make a fake CUDA library. The installer will skip it, but one needs to be
# found for the fixup_bundle scripts.
if (WIN32)
  file(WRITE "${install_dir}/${dir}/nvcuda.dll" "")
else ()
  file(WRITE "${install_dir}/${dir}/libcuda.so.1" "")
endif ()
