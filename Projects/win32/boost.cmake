# 8.0 and below unsupported anyways.
if (MSVC90)
  set(msvc_ver 9.0)
elseif (MSVC10)
  set(msvc_ver 10.0)
elseif (MSVC11)
  set(msvc_ver 11.0)
elseif (MSVC12)
  set(msvc_ver 12.0)
elseif (MSVC13)
  set(msvc_ver 13.0)
else ()
  message(FATAL_ERROR "Unrecognized MSVC version")
endif ()

add_external_project(boost
  DEPENDS zlib
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/bootstrap.bat
  BUILD_COMMAND <SOURCE_DIR>/b2 --prefix=<INSTALL_DIR> --with-date_time --toolset=msvc-${msvc_ver} install
  INSTALL_COMMAND ""
)
