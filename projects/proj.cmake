superbuild_add_project(proj
  DEPENDS
    cxx11 nlohmannjson sqlite
  LICENSE_FILES
    COPYING
  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DBUILD_APPS:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DENABLE_CURL:BOOL=OFF
    -DENABLE_TIFF:BOOL=OFF
    -DNLOHMANN_JSON_ORIGIN:STRING=external)

superbuild_apply_patch(proj cstdint-includes
  "Add missing cstdint includes")
