superbuild_set_revision(expat
  URL     "http://www.paraview.org/files/dependencies/expat-2.2.6.tar.bz2"
  URL_MD5 ca047ae951b40020ac831c28859161b2)

superbuild_set_revision(llvm
  URL     "https://www.paraview.org/files/dependencies/llvm-7.0.0.src.tar.xz"
  URL_MD5 e0140354db83cdeb8668531b431398f0)

superbuild_set_revision(glproto
  URL     "https://www.paraview.org/files/dependencies/glproto-1.4.17.tar.bz2"
  URL_MD5 5565f1b0facf4a59c2778229c1f70d10)

superbuild_set_revision(mesa
  URL     "https://www.paraview.org/files/dependencies/mesa-18.2.2.tar.xz"
  URL_MD5 5931dd76a7533c7c5e702a4e5c00d3bb)
get_property(mesa_revision GLOBAL PROPERTY mesa_revision)
superbuild_set_revision(osmesa ${mesa_revision})

superbuild_set_revision(silo
  URL     "https://www.paraview.org/files/dependencies/silo-4.10.2-bsd-smalltest.tar.gz"
  URL_MD5 d2a9023f63de361d91f94646d5d1974e)

superbuild_set_revision(genericio
  URL     "https://www.paraview.org/files/dependencies/genericio-master-a15ffc76cfa9f9674f933e8cb5ffc97a97fd7b27.zip"
  URL_MD5 daea4ea2076fb6a1b8ccded8e861e1be)

set(paraview_doc_ver_series "5.7")
set(paraview_doc_ver "${paraview_doc_ver_series}.0")
superbuild_set_revision(paraviewgettingstartedguide
  URL     "https://www.paraview.org/files/v${paraview_doc_ver_series}/ParaViewGettingStarted-${paraview_doc_ver}.pdf"
  URL_MD5 392a29c111c5867b51e78bcb83e64198)
superbuild_set_revision(paraviewtutorialdata
  URL     "https://www.paraview.org/files/data/ParaViewTutorialData.tar.gz"
  URL_MD5 ff7ceab8cfc674b227c0bba392d1ed3c)

# Other than the `git` and `source` selections, the name of the selection
# should be the version number of the selection. See
# `superbuild_setup_variables` in `CMakeLists.txt` for the logic which relies
# on this assumption.
superbuild_set_selectable_source(paraview
  # NOTE: When updating this selection, also update `README.md` and CMakeLists.txt.
  SELECT 5.7.0 DEFAULT
    URL     "http://www.paraview.org/files/v5.7/ParaView-v5.7.0.tar.xz"
    URL_MD5 5f86cb2ab2e1efb415271f375f67e41b
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
  URL     "https://www.paraview.org/files/dependencies/vortexfinder2-bb76f80ad08223d49fb42e828c1416daa19f7ecb.tar.bz2"
  URL_MD5 47d12a5103d66b5db782c43c5255b26b)

#------------------------------------------------------------------------------
# Optional Plugins. Doesn't affect ParaView binaries at all even if missing
# or disabled.
#------------------------------------------------------------------------------

superbuild_set_revision(socat
  URL     "https://www.paraview.org/files/dependencies/socat-1.7.3.1.tar.bz2"
  URL_MD5 334e46924f2b386299c9db2ac22bcd36)

set(ispc_version "1.9.2")
if (WIN32)
  if (MSVC12)
    # for VS2013, we use older version of ISPC
    set(ispc_version "1.9.1")
    set(ispc_file "https://www.paraview.org/files/dependencies/ispc-v${ispc_version}-windows-vs2013.zip")
    set(ispc_md5 "ae836b2cb4b7610e92a84fb1feaef72f")
  else ()
    set(ispc_file "https://www.paraview.org/files/dependencies/ispc-v${ispc_version}-windows.zip")
    set(ispc_md5 "3bcfab1e48b64be2cd160e14eaa2f9ab")
  endif()
elseif (APPLE)
  set(ispc_file "https://www.paraview.org/files/dependencies/ispc-v${ispc_version}-osx.tar.gz")
  set(ispc_md5 "387cce62a6c63def5e6eb1c0a468a3db")
else ()
  set(ispc_file "https://www.paraview.org/files/dependencies/ispc-v${ispc_version}-linux.tar.gz")
  set(ispc_md5 "0178a33a065ae65d0be00be23871cf9f")
endif ()
superbuild_set_revision(ispc
  URL     "${ispc_file}"
  URL_MD5 "${ispc_md5}")

superbuild_set_revision(embree
  URL     "https://www.paraview.org/files/dependencies/embree-3.2.0.tar.gz"
  URL_MD5 f414fefe6167ba58102fd0eb06c9ee5b)

superbuild_set_revision(ospray
  URL     "https://www.paraview.org/files/dependencies/ospray-1.8.4.tar.gz"
  URL_MD5 359a56552d981d057bfbd3e97f4fc0b7)

superbuild_set_revision(ospraymaterials
  URL     "https://www.paraview.org/files/data/OSPRayMaterials-0.2.tar.gz"
  URL_MD5 3b2716318ec8bf719373f25737b0bddc)

superbuild_set_revision(openimagedenoise
  URL     "https://www.paraview.org/files/dependencies/oidn-0.8.1.src.tar.gz"
  URL_MD5 4951edc5422682b639595c9fc8dbadcc)

superbuild_set_revision(openvr
  URL     "https://www.paraview.org/files/dependencies/openvr_1.0.10_win_thin.zip"
  URL_MD5 062a029869423808aebc32f85edf38e2)

superbuild_set_revision(paraviewwebvisualizer
  URL     "https://www.paraview.org/files/dependencies/pvw-visualizer-3.2.0.tgz"
  URL_MD5 363e2dff0ed5efe96aadb783cdca6ba0)

superbuild_set_revision(paraviewweblite
  URL     "https://www.paraview.org/files/dependencies/paraview-lite-1.4.3.tgz"
  URL_MD5 2e5b5ce704c0bcacf31f9bd79c779f7d)

superbuild_set_revision(paraviewwebglance
  URL     "https://www.paraview.org/files/dependencies/paraview-glance-3.5.10.tgz"
  URL_MD5 b8307fcdbabacd8fd3ca471eab33353a)

superbuild_set_revision(paraviewwebflow
  URL     "https://www.paraview.org/files/dependencies/paraview-flow-1.0.7.tgz"
  URL_MD5 50843ec3338687011a1d42018fde325d)

superbuild_set_revision(paraviewwebdivvy
  URL     "https://www.paraview.org/files/dependencies/pvw-divvy-1.3.16.tgz"
  URL_MD5 481b18eb7b087a45e0269b7496b6b4db)

superbuild_set_revision(las
  URL     "https://www.paraview.org/files/dependencies/libLAS-1.8.1.tar.bz2"
  URL_MD5 2e6a975dafdf57f59a385ccb87eb5919)

if (WIN32)
  set(nvidiaindex_platform "windows-x64")
  set(nvidiaindex_2_1_md5 "f6efc09092771eb0bfb375a503a95c04")
  set(nvidiaindex_2_2_md5 "93bb894e7951227862ea308f7d6e2e18")
  set(nvidiaindex_2_3_md5 "f7374dfe3eec789b07957e4924fa029f")
elseif (UNIX AND NOT APPLE)
  set(nvidiaindex_platform "linux")
  set(nvidiaindex_2_1_md5 "9fd5af702af6a6a6f2aba3a960703fb3")
  set(nvidiaindex_2_2_md5 "b97518f8b5d05497455e90ba5a0712f1")
  set(nvidiaindex_2_3_md5 "9c57d22f065f2ac7c978e6e6e06ebb69")
endif ()
superbuild_set_selectable_source(nvidiaindex
  SELECT 2.3 DEFAULT
    URL     "http://www.paraview.org/files/dependencies/nvidia-index-libs-2.3.20190820-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_2_3_md5}"
  SELECT 2.2
    URL     "http://www.paraview.org/files/dependencies/nvidia-index-libs-2.2.20181218-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_2_2_md5}"
  SELECT 2.1
    URL     "http://www.paraview.org/files/dependencies/nvidia-index-libs-2.1.20180314-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_2_1_md5}")

# These two packages are only available at these URLs from inside Kitware. They
# are available from NVIDIA at these URLs:
#   - https://developer.nvidia.com/designworks/optix/download
#   - https://developer.nvidia.com/mdl-sdk
if (WIN32)
  set(nvidiaoptix_platform "win64")
  set(nvidiaoptix_md5 "1cc3026f4a1fc945e7158e8a66f8f9bd")
elseif (UNIX AND NOT APPLE)
  set(nvidiaoptix_platform "linux64")
  set(nvidiaoptix_md5 "b5e9cdcb691ad7813e4e24986579a1ef")
endif ()
superbuild_set_revision(nvidiaoptix
  URL     "http://www.paraview.org/files/dependencies/internal/NVIDIA-OptiX-SDK-6.0.0-${nvidiaoptix_platform}-25650775.tar.gz"
  URL_MD5 "${nvidiaoptix_md5}")

superbuild_set_revision(nvidiamdl
  URL     "http://www.paraview.org/files/dependencies/internal/mdl-sdk-314800.830.tar.bz2"
  URL_MD5 "d500a122918741eb418887d66e03325b")

superbuild_set_revision(visrtx
  URL     "http://www.paraview.org/files/dependencies/visrtx-v0.1.6.tar.gz"
  URL_MD5 "c5fef9abd9d56bbbf2c222f0b0943e41")

superbuild_set_revision(mili
  URL     "https://www.paraview.org/files/dependencies/mili-15.1.tar.gz"
  URL_MD5 "8848db9a5e692c010806d64b8c5e46a4")

superbuild_set_revision(zfp
  URL     "https://www.paraview.org/files/dependencies/zfp-0.5.5.tar.gz"
  URL_MD5 "bc7e5fb1cd4345d17f7b9d470a1f23e7")

superbuild_set_selectable_source(adios2
  SELECT v2.5.0 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/adios2-v2.5.0.tar.gz"
    URL_MD5 "a50a6bcd02a0a296484a213dca7f9a11"
  SELECT git CUSTOMIZABLE
    GIT_REPOSITORY "https://github.com/ornladios/ADIOS2.git"
    GIT_TAG        "origin/master")

superbuild_set_revision(libfabric
  URL     "http://www.paraview.org/files/dependencies/libfabric-1.8.0.tar.bz2"
  URL_MD5 "c19c257856cb6e5094e73bf727e2d76c")

superbuild_set_revision(protobuf
  GIT_REPOSITORY "https://github.com/protocolbuffers/protobuf"
  GIT_TAG 2.7.0
  SOURCE_SUBDIR cmake)
