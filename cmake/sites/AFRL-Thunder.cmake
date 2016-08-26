list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
include(DoD-SGI-ICE-X)

set(FREETYPE_INCLUDE_DIR_freetype2 /usr/include/freetype2    CACHE PATH     "")
set(FREETYPE_INCLUDE_DIR_ft2build  /usr/include              CACHE PATH     "")
set(FREETYPE_LIBRARY_RELEASE       /usr/lib64/libfreetype.so CACHE FILEPATH "")
