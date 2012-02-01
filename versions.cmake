# This maintains the links for all sources used by this superbuild.
# Simply update this file to change the revision.
# One can use different revision on different platforms.
# e.g.
# if (UNIX)
#   ..
# else (APPLE)
#   ..
# endif()

add_revision(zlib
  URL "http://paraview.org/files/v3.14/dependencies/zlib-1.2.5.tar.gz"
  URL_MD5 c735eab2d659a96e5a594c9e8541ad63)

# Can't use PNG 1.5 since Qt 4.6.* is making use of deprecated API.
#  URL "ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.5.7.tar.gz"
#  URL_MD5 944b56a84b65d94054cc73d7ff965de8
add_revision(png
  URL "http://paraview.org/files/v3.14/dependencies/libpng-1.4.8.tar.gz"
  URL_MD5 49c6e05be5fa88ed815945d7ca7d4aa9)

add_revision(freetype
  URL "http://paraview.org/files/v3.14/dependencies/freetype-2.4.8.tar.gz"
  URL_MD5 "5d82aaa9a4abc0ebbd592783208d9c76")

add_revision(szip
  URL "http://paraview.org/files/v3.14/dependencies/szip-2.1.tar.gz"
  URL_MD5 902f831bcefb69c6b635374424acbead)

add_revision(hdf5
  URL "http://paraview.org/files/v3.14/dependencies/hdf5-1.8.8.tar.gz"
  URL_MD5 1196e668f5592bfb50d1de162eb16cff)

# 3.12 binaries are using this customized silo, not sure why. It doesn't build
# correctly on linux. I'm changing the code to use the standard silo binary.
# URL http://paraview.org/files/misc/silo-4.8-bsd.tar.gz"
add_revision(silo
  URL "http://paraview.org/files/v3.14/dependencies/silo-4.8-bsd.tar.gz"
  URL_MD5 03e27c977f34dc6e9a5f3864153c24fe)

add_revision(cgns
  URL "http://paraview.org/files/v3.14/dependencies/cgnslib_2.5-5.tar.gz"
  URL_MD5 ae2a2e79b99d41c63e5ed5f661f70fd9)

add_revision(ffmpeg
  URL "http://paraview.org/files/v3.14/dependencies/ffmpeg-0.6.5.tar.gz"
  URL_MD5 451054dae3b3d33a86c2c48bd12d56e7)

add_revision(libxml2
  URL "http://paraview.org/files/v3.14/dependencies/libxml2-2.7.8.tar.gz"
  URL_MD5 8127a65e8c3b08856093099b52599c86)

add_revision(fontconfig
  URL "http://paraview.org/files/v3.14/dependencies/fontconfig-2.8.0.tar.gz"
  URL_MD5 77e15a92006ddc2adbb06f840d591c0e)

add_revision(qt
  URL "http://paraview.org/files/v3.14/dependencies/qt-everywhere-opensource-src-4.6.4.tar.gz"
  URL_MD5 8ac880cc07a130c39607b65efd5e1421)

add_revision(python
  URL "http://paraview.org/files/v3.14/dependencies/Python-2.7.2.tgz"
  URL_MD5 "0ddfe265f1b3d0a8c2459f5bf66894c7")

add_revision(numpy
  URL "http://paraview.org/files/v3.14/dependencies/numpy-1.6.1.tar.gz"
  URL_MD5 2bce18c08fc4fce461656f0f4dd9103e)

add_revision(boost
  URL "http://downloads.sourceforge.net/project/boost/boost/1.45.0/boost_1_45_0.tar.gz"
  URL_MD5 739792c98fafb95e7a6b5da23a30062c)

add_revision(manta
  URL "http://paraview.org/files/v3.14/dependencies/manta-r2439.tar.gz"
  URL_MD5 fbf4107fe2f6d7e8a5ae3dda71805bdc)

add_revision(mpich2
  URL "http://paraview.org/files/v3.14/dependencies/mpich2-1.4.1p1.tar.gz"
  URL_MD5 b470666749bcb4a0449a072a18e2c204)

add_revision(mesa
  URL http://paraview.org/files/v3.14/dependencies/MesaLib-7.11.2.tar.gz
  URL_MD5 b9e84efee3931c0acbccd1bb5a860554)

add_revision(paraview
  GIT_REPOSITORY git://paraview.org/ParaView.git
  GIT_TAG v3.14.0)

set(userguide_url http://www.paraview.org/files/v3.14/ParaViewUsersGuide.v3.14.pdf)

#------------------------------------------------------------------------------
# Optional Plugins. Doesn't affect ParaView binaries at all even is missing
# or disabled.
#------------------------------------------------------------------------------

add_revision(acusolve_plugin
  GIT_REPOSITORY git://kwsource.kitwarein.com/paraview/acusolvereaderplugin.git
  GIT_TAG master)

add_revision(vistrails_plugin
  GIT_REPOSITORY git://kwsource.kitwarein.com/paraview/vistrails.git
  GIT_TAG master)

add_revision(mili_plugin
  GIT_REPOSITORY git://kwsource.kitwarein.com/paraview/mili.git
  GIT_TAG master)

