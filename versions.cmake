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
  URL "http://zlib.net/zlib-1.2.7.tar.gz"
  URL_MD5 60df6a37c56e7c1366cca812414f7b85)
# NOTE: if updating zlib version, fix patch in zlib.cmake


add_revision(png
  URL "http://paraview.org/files/v3.98/dependencies/libpng-1.4.8.tar.gz"
  URL_MD5 49c6e05be5fa88ed815945d7ca7d4aa9)

add_revision(freetype
  URL "http://paraview.org/files/v3.98/dependencies/freetype-2.4.8.tar.gz"
  URL_MD5 "5d82aaa9a4abc0ebbd592783208d9c76")

add_revision(szip
  URL "http://paraview.org/files/v3.98/dependencies/szip-2.1.tar.gz"
  URL_MD5 902f831bcefb69c6b635374424acbead)

add_revision(hdf5
  URL http://paraview.org/files/v3.98/dependencies/hdf5-1.8.9.tar.gz
  URL_MD5 d1266bb7416ef089400a15cc7c963218)

add_revision(silo
  URL "http://paraview.org/files/v3.98/dependencies/silo-4.8-bsd.tar.gz"
  URL_MD5 03e27c977f34dc6e9a5f3864153c24fe)

add_revision(cgns
  URL "http://downloads.sourceforge.net/project/cgns/cgnslib_3.1/cgnslib_3.1.3-4.tar.gz"
  URL_MD5 442bba32b576f3429cbd086af43fd4ae)

add_revision(ffmpeg
  URL "http://paraview.org/files/v3.98/dependencies/ffmpeg-0.6.5.tar.gz"
  URL_MD5 451054dae3b3d33a86c2c48bd12d56e7)

add_revision(libxml2
  URL "http://paraview.org/files/v3.98/dependencies/libxml2-2.7.8.tar.gz"
  URL_MD5 8127a65e8c3b08856093099b52599c86)

add_revision(fontconfig
  URL "http://paraview.org/files/v3.98/dependencies/fontconfig-2.8.0.tar.gz"
  URL_MD5 77e15a92006ddc2adbb06f840d591c0e)

add_revision(qt
  URL "http://releases.qt-project.org/qt4/source/qt-everywhere-opensource-src-4.8.2.tar.gz"
  URL_MD5 3c1146ddf56247e16782f96910a8423b)

if (WIN32)
  add_revision(python
    URL "http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz"
    URL_MD5 "2cf641732ac23b18d139be077bd906cd")
else()
  add_revision(python
    URL "http://paraview.org/files/v3.98/dependencies/Python-2.7.2.tgz"
    URL_MD5 "0ddfe265f1b3d0a8c2459f5bf66894c7")
endif()

add_revision(numpy
  URL "http://paraview.org/files/dependencies/numpy-1.6.2.tar.gz"
  URL_MD5 95ed6c9dcc94af1fc1642ea2a33c1bba)

add_revision(matplotlib
  URL "http://paraview.org/files/v3.98/dependencies/matplotlib-1.1.1_notests.tar.gz"
  URL_MD5 30ee59119599331bf1f3b6e838fee9a8)

add_revision(boost
  URL "http://downloads.sourceforge.net/project/boost/boost/1.50.0/boost_1_50_0.tar.gz"
  URL_MD5 dbc07ab0254df3dda6300fd737b3f264)

add_revision(manta
  URL "http://paraview.org/files/v3.98/dependencies/manta-r2439.tar.gz"
  URL_MD5 fbf4107fe2f6d7e8a5ae3dda71805bdc)

if (UNIX)
  add_revision(mpi
    URL "http://paraview.org/files/v3.98/dependencies/mpich2-1.4.1p1.tar.gz"
    URL_MD5 b470666749bcb4a0449a072a18e2c204)
elseif (WIN32)
  add_revision(mpi
    URL http://www.open-mpi.org/software/ompi/v1.6/downloads/openmpi-1.6.2.tar.gz
    URL_MD5 351845a0edd8141feb30d31edd59cdcd)
endif()

add_revision(mesa
  URL http://paraview.org/files/v3.98/dependencies/MesaLib-7.11.2.tar.gz
  URL_MD5 b9e84efee3931c0acbccd1bb5a860554)

add_revision(paraview
  GIT_REPOSITORY git://paraview.org/ParaView.git
  GIT_TAG "master")

if (TRUST_SVN_CERTIFICATES_AUTOMATICALLY)
  add_revision(diy
     SVN_REPOSITORY https://svn.mcs.anl.gov/repos/diy/trunk
     SVN_REVISION -r144
     SVN_TRUST_CERT 1)
else()
  add_revision(diy
     SVN_REPOSITORY https://svn.mcs.anl.gov/repos/diy/trunk
     SVN_REVISION -r144)
endif()

add_revision(qhull
    GIT_REPOSITORY git://github.com/gzagaris/gxzagas-qhull.git
    GIT_TAG master)

#------------------------------------------------------------------------------
# Optional Plugins. Doesn't affect ParaView binaries at all even if missing
# or disabled.
#------------------------------------------------------------------------------

add_revision(cosmologytools
    GIT_REPOSITORY git://public.kitware.com/cosmologytools.git
    GIT_TAG master)

add_revision(acusolve
  GIT_REPOSITORY git://kwsource.kitwarein.com/paraview/acusolvereaderplugin.git
  GIT_TAG master)

add_revision(vistrails
  GIT_REPOSITORY git://kwsource.kitwarein.com/paraview/vistrails.git
  GIT_TAG master)

#add_revision(mili_plugin
# URL ${CMAKE_CURRENT_SOURCE_DIR}/Externals/mili)

add_revision(nektar_plugin
  GIT_REPOSITORY git://gitorious.org/nektarplugin/nektarplugin.git
  GIT_TAG master)

