set (extra_commands)
if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  #set the platform to be clang if on apple and not gcc
  set(extra_commands --cc=clang)
endif()

add_external_project(
  ffmpeg
  DEPENDS zlib
  CONFIGURE_COMMAND "<SOURCE_DIR>/configure
                    --prefix=<INSTALL_DIR>
                    --disable-avdevice
                    --disable-bzlib
                    --disable-decoders
                    --disable-doc
                    --disable-ffplay
                    --disable-ffprobe
                    --disable-ffserver
                    --disable-network
                    --disable-static
                    --enable-shared
                    --disable-yasm
                    \"--extra-cflags=${cppflags}\"
                    \"--extra-ldflags=${ldflags}\"
                    ${extra_commands}"
  BUILD_IN_SOURCE 1
)
unset(extra_commands)
