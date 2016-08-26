find_path(MXML_INCLUDE_DIR mxml.h)
find_library(MXML_LIBRARY mxml)

if (NOT (MXML_INCLUDE_DIR AND MXML_LIBRARY))
  message(FATAL_ERROR "Unable to locate mxml")
endif ()
