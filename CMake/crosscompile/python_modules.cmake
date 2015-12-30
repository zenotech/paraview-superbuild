# Instead of listing each module specifically, instead we turn on all
# possible modules as built-in and disable all external system libraries.

set(BUILD_EXTENSIONS_AS_BUILTIN ON  CACHE BOOL "" FORCE)
set(USE_SYSTEM_LIBRARIES OFF CACHE BOOL "" FORCE)

# The CMake build is a bit wonky so a few oither libs need to be ignored
# manually
set(HAVE_LIBCRYPT IGNORE CACHE FILEPATH "" FORCE)
set(HAVE_LIBNSL   IGNORE CACHE FILEPATH "" FORCE)
