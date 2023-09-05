set(libraries
  libeprtf
  libmili
  libtaurus)

foreach (library IN LISTS libraries)
  file(INSTALL "${build_subdir}/lib_opt/${library}.a"
    DESTINATION "${install_location}/lib")
endforeach ()

set(includes
  eprtf.h
  gahl.h
  list.h
  mili.h
  mili_endian.h
  mili_enum.h
  mili_fparam.h
  mili_internal.h
  misc.h
  mr.h
  partition.h
  sarray.h
  taurus_db.h)

foreach (include IN LISTS includes)
  file(READ_SYMLINK "${build_subdir}/include/${include}" real_header)
  file(INSTALL "${build_subdir}/include/${real_header}"
    DESTINATION "${install_location}/include/mili/")
endforeach ()
