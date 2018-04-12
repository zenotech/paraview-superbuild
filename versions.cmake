superbuild_set_revision(expat
  URL     "http://www.paraview.org/files/dependencies/expat-2.2.5.tar.bz2"
  URL_MD5 789e297f547980fc9ecc036f9a070d49)

superbuild_set_revision(llvm
  URL     "https://www.paraview.org/files/dependencies/llvm-5.0.1.src.tar.xz"
  URL_MD5 3a4ec6dcbc71579eeaec7cb157fe2168)

superbuild_set_revision(glproto
  URL     "https://www.paraview.org/files/dependencies/glproto-1.4.17.tar.bz2"
  URL_MD5 5565f1b0facf4a59c2778229c1f70d10)

superbuild_set_revision(mesa
    URL     "https://www.paraview.org/files/dependencies/mesa-18.0.0-rc4.tar.xz"
    URL_MD5 195889b71ee88785d55b03d99e0034d3)
get_property(mesa_revision GLOBAL PROPERTY mesa_revision)
superbuild_set_revision(osmesa ${mesa_revision})

superbuild_set_revision(adios
  URL     "https://www.paraview.org/files/dependencies/adios-1.11.0.tar.gz"
  URL_MD5 5eead5b2ccf962f5e6d5f254d29d5238)

superbuild_set_revision(mxml
  URL     "https://www.paraview.org/files/dependencies/mxml-2.9.tar.gz"
  URL_MD5 e21cad0f7aacd18f942aa0568a8dee19)

superbuild_set_revision(silo
  URL     "https://www.paraview.org/files/dependencies/silo-4.10.2-bsd-smalltest.tar.gz"
  URL_MD5 d2a9023f63de361d91f94646d5d1974e)

superbuild_set_revision(genericio
  URL     "https://www.paraview.org/files/dependencies/genericio-master-a15ffc76cfa9f9674f933e8cb5ffc97a97fd7b27.zip"
  URL_MD5 daea4ea2076fb6a1b8ccded8e861e1be)

set(paraview_doc_ver_series "5.5")
set(paraview_doc_ver "${paraview_doc_ver_series}.1")
superbuild_set_revision(paraviewgettingstartedguide
  URL     "https://www.paraview.org/files/v${paraview_doc_ver_series}/ParaViewGettingStarted-${paraview_doc_ver}.pdf"
  URL_MD5 1bdadd4b5a62ba9f2de8eb0219ca858c)
superbuild_set_revision(paraviewtutorialdata
  URL     "https://www.paraview.org/files/data/ParaViewTutorialData.tar.gz"
  URL_MD5 ff7ceab8cfc674b227c0bba392d1ed3c)

# Other than the `git` and `source` selections, the name of the selection
# should be the version number of the selection. See
# `superbuild_setup_variables` in `CMakeLists.txt` for the logic which relies
# on this assumption.
superbuild_set_selectable_source(paraview
  # NOTE: When updating this selection, also update `README.md` and CMakeLists.txt.
  SELECT 5.5.1 DEFAULT
    URL     "http://www.paraview.org/files/v5.5/ParaView-v5.5.1.tar.gz"
    URL_MD5 a7d92a45837b67c3371006cc45163277
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
  URL     "https://www.paraview.org/files/dependencies/vrpn-a545ef6415f0026aabdbdb1d7fdbefeb91c47d4f.tar.bz2"
  URL_MD5 e1686f664c00519a251a50d6a8e328d5)

superbuild_set_revision(vortexfinder2
  # https://github.com/hguo/vortexfinder2.git
  URL     "https://www.paraview.org/files/dependencies/vortexfinder2-f9a31847c052a44cc1e4b592b9e3f3fe078b7bf9.tar.bz2"
  URL_MD5 da96a038e00d08e4571f64488e9e4d16)

#------------------------------------------------------------------------------
# Optional Plugins. Doesn't affect ParaView binaries at all even if missing
# or disabled.
#------------------------------------------------------------------------------

superbuild_set_revision(socat
  URL     "https://www.paraview.org/files/dependencies/socat-1.7.3.1.tar.bz2"
  URL_MD5 334e46924f2b386299c9db2ac22bcd36)

set(ispc_version "1.9.1")
if (WIN32)
  set(ispc_file "https://www.paraview.org/files/dependencies/ispc-v${ispc_version}-windows-vs2013.zip")
  set(ispc_md5 "ae836b2cb4b7610e92a84fb1feaef72f")
elseif (APPLE)
  set(ispc_file "https://www.paraview.org/files/dependencies/ispc-v${ispc_version}-osx.tar.gz")
  set(ispc_md5 "6f9b6524d7a96c1be728b1b0a9158360")
else ()
  set(ispc_file "https://www.paraview.org/files/dependencies/ispc-v${ispc_version}-linux.tar.gz")
  set(ispc_md5 "5d801d90bafaf9800cfbeab18a33a58f")
endif ()
superbuild_set_revision(ispc
  URL     "${ispc_file}"
  URL_MD5 "${ispc_md5}")

superbuild_set_revision(embree
  URL     "https://www.paraview.org/files/dependencies/embree-2.17.0.tar.gz"
  URL_MD5 3ea7a72546baee497ae8098bc12f3de6)

superbuild_set_revision(ospray
  URL     "https://www.paraview.org/files/dependencies/ospray-1.4.0.tar.gz"
  URL_MD5 2a3a4895c5ec2a42c7af86a51727fb53)
superbuild_set_revision(ospraymaterials
  URL     "https://www.paraview.org/files/data/OSPRayMaterials.tar.gz"
  URL_MD5 6f1d5d96e91b14222c462c890185dbc3)

superbuild_set_revision(openvr
  URL     "https://www.paraview.org/files/dependencies/openvr_1.0.10_win_thin.zip"
  URL_MD5 062a029869423808aebc32f85edf38e2)

superbuild_set_revision(paraviewwebvisualizer
  URL     "https://www.paraview.org/files/dependencies/visualizer-3.1.3.tar.gz"
  URL_MD5 5772b6981bf22b4a8f2810ee92cb6ef6)

superbuild_set_revision(paraviewweblightviz
  URL     "https://www.paraview.org/files/dependencies/light-viz-1.18.1.tar.gz"
  URL_MD5 091c2ffbe7480f52f93bd25616267c2b)

superbuild_set_revision(paraviewwebdivvy
  URL     "https://www.paraview.org/files/dependencies/divvy-1.3.14.tar.gz"
  URL_MD5 e9a0453a057588791e00efede43cfb91)

superbuild_set_revision(boxlib
  URL     "https://www.paraview.org/files/dependencies/boxlib-c114717e6c47188a0812804addcab61d7605ef89.tar.bz2"
  URL_MD5 fb96e9b2c347c9b790d0eab4ba810e14)

superbuild_set_revision(las
  URL     "https://www.paraview.org/files/dependencies/libLAS-1.8.1.tar.bz2"
  URL_MD5 2e6a975dafdf57f59a385ccb87eb5919)

set(nvidiaindex_version "2.1.20180314")
if (WIN32)
  superbuild_set_revision(nvidiaindex
    URL     "http://www.paraview.org/files/dependencies/nvidia-index-libs-${nvidiaindex_version}-vs2013-x64.tar.bz2"
    URL_MD5 f6efc09092771eb0bfb375a503a95c04)
elseif (UNIX AND NOT APPLE)
  superbuild_set_revision(nvidiaindex
    URL     "http://www.paraview.org/files/dependencies/nvidia-index-libs-${nvidiaindex_version}-linux.tar.bz2"
    URL_MD5 9fd5af702af6a6a6f2aba3a960703fb3)
endif ()
