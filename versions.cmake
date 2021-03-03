if (NOT APPLE OR paraview_superbuild_new_boost)
  superbuild_set_revision(boost
    URL     "https://www.paraview.org/files/dependencies/boost_1_71_0.tar.bz2"
    URL_MD5 4cdf9b5c2dc01fb2b7b733d5af30e558)
  set(boost_no_junction_patch_necessary TRUE)
endif()

superbuild_set_revision(expat
  URL     "https://www.paraview.org/files/dependencies/expat-2.2.9.tar.bz2"
  URL_MD5 875a2c2ff3e8eb9e5a5cd62db2033ab5)

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

set(paraview_doc_ver_series "5.9")
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
  # NOTE: When updating this selection, also update the default version in
  # README.md and the PARAVIEW_VERSION_DEFAULT variable in CMakeLists.txt.
  SELECT 5.9.0 DEFAULT
    URL     "https://www.paraview.org/files/v5.9/ParaView-v5.9.0.tar.xz"
    URL_MD5 a77e2c72d8a61f824a095c60a1183d16
  SELECT git CUSTOMIZABLE
    GIT_REPOSITORY "https://gitlab.kitware.com/paraview/paraview.git"
    GIT_TAG        "origin/master"
  SELECT source CUSTOMIZABLE
    SOURCE_DIR "source-paraview")

superbuild_set_revision(vrpn
  # https://github.com/vrpn/vrpn.git
  URL     "https://www.paraview.org/files/dependencies/vrpn-45375f61de4c1a7bb95fe5a9264ac48a5d395404.tar.bz2"
  URL_MD5 bce3ed067ea68c7cc115e3f2dfacc7ca)

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

if (WIN32)
  set(ispc_suffix "-windows.zip")
  set(ispc_md5 ad96f833c1429a292c40c4f4821985fe)
elseif (APPLE)
  set(ispc_suffix "-macOS.tar.gz")
  set(ispc_md5 c856ed3af19b948e83f4277b1a19766f)
else()
  set(ispc_suffix "-linux.tar.gz")
  set(ispc_md5 7ce4350f079c7eb8a1ce9d9908f5d85d)
endif()
superbuild_set_revision(ispc
  URL     "https://www.paraview.org/files/dependencies/ispc-v1.14.1${ispc_suffix}"
  URL_MD5 "${ispc_md5}")

superbuild_set_revision(embree
  URL     "https://www.paraview.org/files/dependencies/embree-v3.12.0.tar.gz"
  URL_MD5 f0db3c7029467fdc6d29709cb85fc607)

superbuild_set_revision(openvkl
  URL     "https://www.paraview.org/files/dependencies/openvkl-v0.11.0.tar.gz"
  URL_MD5 252980f79c3097599b2d8e643f9c5b8f)

superbuild_set_revision(ospray
  URL     "https://www.paraview.org/files/dependencies/ospray-v2.4.0.tar.gz"
  URL_MD5 8e6537b0dacb08fffb0778663e617886)

superbuild_set_revision(ospraymodulempi
  URL     "https://www.paraview.org/files/dependencies/ospraymodulempi-v2.4.0.tar.gz"
  URL_MD5 1f8f2214c09f539de88004e47bce22bd)

superbuild_set_revision(ospraymaterials
  URL     "https://www.paraview.org/files/data/OSPRayMaterials-0.3.tar.gz"
  URL_MD5 d256c17f70890d3477e90d35bf814c25)

superbuild_set_revision(openimagedenoise
  URL     "https://www.paraview.org/files/dependencies/oidn-v1.2.4.tar.gz"
  URL_MD5 501b787a5e2fcaf2dfd8a39d47ee03dd)

superbuild_set_revision(rkcommon
  URL     "https://www.paraview.org/files/dependencies/rkcommon-v1.5.1.tar.gz"
  URL_MD5 61f55e4d0d8efd48c8bc308bf5b4ee1f)

superbuild_set_revision(openvr
  URL     "https://www.paraview.org/files/dependencies/openvr_1.14.15_win_thin.zip"
  URL_MD5 7de59dee80edad6ce89df1913c6356e8)

superbuild_set_revision(paraviewwebvisualizer
  URL     "https://www.paraview.org/files/dependencies/pvw-visualizer-3.2.0.tgz"
  URL_MD5 363e2dff0ed5efe96aadb783cdca6ba0)

superbuild_set_revision(paraviewweblite
  URL     "https://www.paraview.org/files/dependencies/paraview-lite-1.4.4.tgz"
  URL_MD5 25bacf49b298c255c0c940ace9fce794)

superbuild_set_revision(paraviewwebglance
  URL     "https://www.paraview.org/files/dependencies/paraview-glance-4.4.2.tgz"
  URL_MD5 49aa62fc8d8b1b942e7fc8cb5e66d4db)

superbuild_set_revision(paraviewwebflow
  URL     "https://www.paraview.org/files/dependencies/paraview-flow-1.0.7.tgz"
  URL_MD5 50843ec3338687011a1d42018fde325d)

superbuild_set_revision(paraviewwebdivvy
  URL     "https://www.paraview.org/files/dependencies/pvw-divvy-1.3.17.tgz"
  URL_MD5 b04375b53d65e03cb9ee82bb86b77696)

superbuild_set_revision(las
  URL     "https://www.paraview.org/files/dependencies/libLAS-1.8.1.tar.bz2"
  URL_MD5 2e6a975dafdf57f59a385ccb87eb5919)

superbuild_set_revision(lookingglass
  URL     "https://www.paraview.org/files/dependencies/HoloPlayCore-0.1.1-Open-20200923.tar.gz"
  URL_MD5 b435316fa1f8454ba180e72608c3c28f)

superbuild_set_revision(gmsh
  URL     "https://www.paraview.org/files/dependencies/gmsh-gmsh_4_7_0.tar.gz"
  URL_MD5 b0fdb396065e1c73849da572235536ed)

if (WIN32)
  set(nvidiaindex_platform "windows-x64")
  set(nvidiaindex_2_1_md5 "f6efc09092771eb0bfb375a503a95c04")
  set(nvidiaindex_2_2_md5 "93bb894e7951227862ea308f7d6e2e18")
  set(nvidiaindex_2_3_md5 "f7374dfe3eec789b07957e4924fa029f")
  set(nvidiaindex_2_4_md5 "a11b9056683c52efe9f1d706e2926235")
  set(nvidiaindex_5_9_md5 "a778def725f20f7151778f684b19211b")
elseif (UNIX AND NOT APPLE)
  if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "ppc64le")
    set(nvidiaindex_platform "linux-ppc64le")
    set(nvidiaindex_5_9_md5 "a6f1aa8847c3eeeceacec41bd98838ca")
  else ()
    set(nvidiaindex_platform "linux")
    set(nvidiaindex_2_1_md5 "9fd5af702af6a6a6f2aba3a960703fb3")
    set(nvidiaindex_2_2_md5 "b97518f8b5d05497455e90ba5a0712f1")
    set(nvidiaindex_2_3_md5 "9c57d22f065f2ac7c978e6e6e06ebb69")
    set(nvidiaindex_2_4_md5 "39bb55a5bb5f8ba1e8f44fa68dc703d3")
    set(nvidiaindex_5_9_md5 "32599d5298a43ee9d4497886b79bdd65")
  endif ()
endif ()
superbuild_set_selectable_source(nvidiaindex
  # XXX(index): Adding a new version? The Windows bundle script needs to know
  # too (nvrtc-builtins).
  SELECT 5.9 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/nvidia-index-libs-5.9.20201204-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_5_9_md5}"
  SELECT 2.4
    URL     "https://www.paraview.org/files/dependencies/nvidia-index-libs-2.4.20200424-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_2_4_md5}"
  SELECT 2.3
    URL     "https://www.paraview.org/files/dependencies/nvidia-index-libs-2.3.20190820-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_2_3_md5}"
  SELECT 2.2
    URL     "https://www.paraview.org/files/dependencies/nvidia-index-libs-2.2.20181218-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_2_2_md5}"
  SELECT 2.1
    URL     "https://www.paraview.org/files/dependencies/nvidia-index-libs-2.1.20180314-${nvidiaindex_platform}.tar.bz2"
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
  URL     "https://www.paraview.org/files/dependencies/internal/NVIDIA-OptiX-SDK-6.0.0-${nvidiaoptix_platform}-25650775.tar.gz"
  URL_MD5 "${nvidiaoptix_md5}")

superbuild_set_revision(nvidiamdl
  URL     "https://www.paraview.org/files/dependencies/internal/mdl-sdk-314800.830.tar.bz2"
  URL_MD5 "d500a122918741eb418887d66e03325b")

superbuild_set_revision(visrtx
  URL     "https://www.paraview.org/files/dependencies/visrtx-v0.1.6.tar.gz"
  URL_MD5 "c5fef9abd9d56bbbf2c222f0b0943e41")

superbuild_set_revision(rapidjson
  URL     "https://www.paraview.org/files/dependencies/rapidjson-1.1.0.tar.gz"
  URL_MD5 "badd12c511e081fec6c89c43a7027bce")

superbuild_set_revision(mili
  URL     "https://www.paraview.org/files/dependencies/mili-15.1.tar.gz"
  URL_MD5 "8848db9a5e692c010806d64b8c5e46a4")

superbuild_set_revision(zfp
  URL     "https://www.paraview.org/files/dependencies/zfp-0.5.5.tar.gz"
  URL_MD5 "bc7e5fb1cd4345d17f7b9d470a1f23e7")

superbuild_set_selectable_source(adios2
  SELECT v2.6.0 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/adios-v2.6.0.tar.gz"
    URL_MD5 "63d9253891775107bd7a5255a979b4b4"
  SELECT git CUSTOMIZABLE
    GIT_REPOSITORY "https://github.com/ornladios/ADIOS2.git"
    GIT_TAG        "origin/master")

superbuild_set_revision(libfabric
  URL     "https://www.paraview.org/files/dependencies/libfabric-1.8.0.tar.bz2"
  URL_MD5 "c19c257856cb6e5094e73bf727e2d76c")

superbuild_set_revision(protobuf
  URL     "https://www.paraview.org/files/dependencies/protobuf-3.11.4.tar.gz"
  URL_MD5 "9b649590a4b74e93024ea3a28c0d3a22"
  SOURCE_SUBDIR cmake)

superbuild_set_revision(gdal
  # https://github.com/judajake/gdal-svn.git
  URL     "https://www.paraview.org/files/dependencies/gdal-98353693d6f1d607954220b2f8b040375e3d1744.tar.bz2"
  URL_MD5 5aa285dcc856f98ce44020ae1ae192cb)

superbuild_set_revision(launchers
  SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/launchers")

superbuild_set_revision(openpmd
  URL     "https://www.paraview.org/files/dependencies/openPMD-api-0.12.0-alpha.tar.gz"
  URL_MD5 "ada986539b4d2cc004888f161f41de85")

superbuild_set_revision(pythonpkgconfig
  URL     "https://www.paraview.org/files/dependencies/pkgconfig-1.5.2.tar.gz"
  URL_MD5 "0d889edf670b644bfeaa3bb9444169cb")

superbuild_set_revision(h5py
  URL     "https://www.paraview.org/files/dependencies/h5py-3.2.0.tar.gz"
  URL_MD5 "4b7ebc5d42bea9c264857a516c39ee3e")
