
# FIXME: I'm not sure I was successful in making Python use the zlib we built
# :(.
set (old_ldflags $ENV{LDFLAGS})
set (old_cppflags $ENV{CPPFLAGS})

set (ENV{LDFLAGS} ${old_ldflags} -L${internal_install_root}/lib)
set (ENV{CPPFLAGS} ${old_cppflags} -I${internal_install_root}/include)
ExternalProject_Add(
  python
  DEPENDS zlib png
  PREFIX python
  URL "http://python.org/ftp/python/2.7.2/Python-2.7.2.tgz"
  URL_MD5 "0ddfe265f1b3d0a8c2459f5bf66894c7"
  DOWNLOAD_DIR ${CMAKE_CURRENT_BINARY_DIR}/downloads
  CONFIGURE_COMMAND <SOURCE_DIR>/configure
                    --prefix=${internal_install_root}
                    --enable-unicode
  )

