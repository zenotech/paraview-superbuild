superbuild_set_revision(llvm
  URL     "http://www.paraview.org/files/dependencies/llvm-3.8.1.src.tar.xz"
  URL_MD5 538467e6028bbc9259b1e6e015d25845)

superbuild_set_revision(glproto
  URL     "http://www.paraview.org/files/dependencies/glproto-1.4.17.tar.bz2"
  URL_MD5 5565f1b0facf4a59c2778229c1f70d10)

superbuild_set_revision(mesa
    URL     "http://www.paraview.org/files/dependencies/mesa-13.0.3.tar.xz"
    URL_MD5 24e3fa52c95139dfa9ff5085d0c2ead6)
get_property(mesa_revision GLOBAL PROPERTY mesa_revision)
superbuild_set_revision(osmesa ${mesa_revision})

superbuild_set_revision(glu
  URL     "http://www.paraview.org/files/dependencies/glu-9.0.0.tar.gz"
  URL_MD5 bbc57d4fe3bd3fb095bdbef6fcb977c4)

superbuild_set_revision(adios
  URL     "http://www.paraview.org/files/dependencies/adios-1.8-439f0fb6.tar.bz2"
  URL_MD5 a88701c77a7ead5daadd8d8aff70556a)

superbuild_set_revision(mxml
  URL     "http://www.paraview.org/files/dependencies/mxml-2.9.tar.gz"
  URL_MD5 e21cad0f7aacd18f942aa0568a8dee19)

superbuild_set_revision(silo
  URL     "http://www.paraview.org/files/dependencies/silo-4.9.1-bsd.tar.gz"
  URL_MD5 465d2a0a8958b088cde83fb2a5a7eeef)

superbuild_set_revision(cgns
  URL     "http://www.paraview.org/files/dependencies/cgns-3.3.0.tar.xz"
  URL_MD5 01690e4e2b0e2105ee117032f4ee5b0c)

superbuild_set_revision(genericio
  URL     "http://www.paraview.org/files/dependencies/genericio-master-a15ffc76cfa9f9674f933e8cb5ffc97a97fd7b27.zip"
  URL_MD5 daea4ea2076fb6a1b8ccded8e861e1be)

superbuild_set_revision(acusolve
  GIT_REPOSITORY "https://kwgitlab.kitware.com/paraview/acusolvereaderplugin.git"
  GIT_TAG        origin/master)

set(paraview_doc_ver_series "5.3")
set(paraview_doc_ver "${paraview_doc_ver_series}.0")
superbuild_set_revision(paraviewusersguide
  URL     "http://www.paraview.org/files/v${paraview_doc_ver_series}/ParaViewGuide-${paraview_doc_ver}.pdf"
  URL_MD5 08b1d0dafbe50f2241da7a4a4e2b0b75)
superbuild_set_revision(paraviewgettingstartedguide
  URL     "http://www.paraview.org/files/v${paraview_doc_ver_series}/ParaViewGettingStarted-${paraview_doc_ver}.pdf"
  URL_MD5 7ce54ce8a8b36c746035c2b228713074)
superbuild_set_revision(paraviewtutorial
  URL     "http://www.paraview.org/files/v${paraview_doc_ver_series}/ParaViewTutorial.pdf"
  URL_MD5 1b3d975eac73bca412414efb2af9974c)
superbuild_set_revision(paraviewtutorialdata
  URL     "http://www.paraview.org/files/data/ParaViewTutorialData.tar.gz"
  URL_MD5 ff7ceab8cfc674b227c0bba392d1ed3c)

# Other than the `git` and `source` selections, the name of the selection
# should be the version number of the selection. See
# `superbuild_setup_variables` in `CMakeLists.txt` for the logic which relies
# on this assumption.
superbuild_set_selectable_source(paraview
  SELECT 5.3.0-RC2
    URL     "http://www.paraview.org/files/v5.3/ParaView-v5.3.0-RC2.tar.gz"
    URL_MD5 6134ef2b9bc094ed4e25f6d994e60311
  SELECT 5.3.0-RC1
    URL     "http://www.paraview.org/files/v5.3/ParaView-v5.3.0-RC1.tar.gz"
    URL_MD5 43a331c8dfdac3ef881c6f9cc25b3792
  SELECT 5.2.0 DEFAULT
    URL "http://www.paraview.org/files/v5.2/ParaView-v5.2.0.tar.gz"
    URL_MD5 4570d1a2a183026adb65b73c7125b8b0
  SELECT git CUSTOMIZABLE
    GIT_REPOSITORY "https://gitlab.kitware.com/paraview/paraview.git"
    GIT_TAG        "origin/master"
  SELECT source CUSTOMIZABLE
    SOURCE_DIR "source-paraview")
get_property(paraview_revision GLOBAL
  PROPERTY paraview_revision)
superbuild_set_revision(catalyst
  ${paraview_revision})
unset(paraview_revision)

superbuild_set_revision(vrpn
  # https://github.com/vrpn/vrpn.git
  URL     "http://www.paraview.org/files/dependencies/vrpn-a545ef6415f0026aabdbdb1d7fdbefeb91c47d4f.tar.bz2"
  URL_MD5 e1686f664c00519a251a50d6a8e328d5)

superbuild_set_revision(vortexfinder2
  # https://github.com/hguo/vortexfinder2.git
  URL     "http://www.paraview.org/files/dependencies/vortexfinder2-f9a31847c052a44cc1e4b592b9e3f3fe078b7bf9.tar.bz2"
  URL_MD5 da96a038e00d08e4571f64488e9e4d16)

#------------------------------------------------------------------------------
# Optional Plugins. Doesn't affect ParaView binaries at all even if missing
# or disabled.
#------------------------------------------------------------------------------

superbuild_set_revision(socat
  URL     "http://www.paraview.org/files/dependencies/socat-1.7.3.1.tar.bz2"
  URL_MD5 334e46924f2b386299c9db2ac22bcd36)

set(ispc_version "1.9.1")
if (WIN32)
  set(ispc_file "http://www.paraview.org/files/dependencies/ispc-v${ispc_version}-windows-vs2013.zip")
  set(ispc_md5 "ae836b2cb4b7610e92a84fb1feaef72f")
elseif (APPLE)
  set(ispc_file "http://www.paraview.org/files/dependencies/ispc-v${ispc_version}-osx.tar.gz")
  set(ispc_md5 "6f9b6524d7a96c1be728b1b0a9158360")
else ()
  set(ispc_file "http://www.paraview.org/files/dependencies/ispc-v${ispc_version}-linux.tar.gz")
  set(ispc_md5 "5d801d90bafaf9800cfbeab18a33a58f")
endif ()
superbuild_set_revision(ispc
  URL     "${ispc_file}"
  URL_MD5 "${ispc_md5}")

superbuild_set_revision(vtkm
  URL     "http://www.paraview.org/files/dependencies/vtkm-d32f3457d8049a79cc59fb02c3dfb7879ef90ee3.tar.bz2"
  URL_MD5 20dfbed7381bd4d460ad63c429cc2bea)

superbuild_set_revision(ospray
  URL     "http://www.paraview.org/files/dependencies/ospray-v1.1.2.tar.gz"
  URL_MD5 7f1911b845a27ac146bb3a97e0e6206e)

superbuild_set_revision(paraviewwebvisualizer
  URL     "http://www.paraview.org/files/dependencies/visualizer-2.0.18.tar.gz"
  URL_MD5 40c4f5fb0a9c3b6508086a834b039aaf)

superbuild_set_revision(paraviewweblightviz
  URL     "http://www.paraview.org/files/dependencies/light-viz-1.16.4.tar.gz"
  URL_MD5 724849431759d30ec0077f99937f1537)

superbuild_set_revision(boxlib
  URL     "http://www.paraview.org/files/dependencies/boxlib-c114717e6c47188a0812804addcab61d7605ef89.tar.bz2"
  URL_MD5 fb96e9b2c347c9b790d0eab4ba810e14)
