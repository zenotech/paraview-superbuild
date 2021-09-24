# Using Intel Threading Building Blocks 2018 Update 2
set(tbb_ver_paraview "2019_20190410oss")
if (WIN32)
  set(tbb_file "tbb${tbb_ver_paraview}_win.zip")
  set(tbb_md5 63fc9feb34ec973b0c8ae439afb30f5e)
elseif (APPLE)
  set(tbb_file "tbb${tbb_ver_paraview}_mac.tgz")
  set(tbb_md5 d1420b7b6e1d2b9c7e737123bd7e8315)
else ()
  set(tbb_file "tbb${tbb_ver_paraview}_lin.tgz")
  set(tbb_md5 cb95ed04d2522e54d2327afd1c56938f)
endif ()

superbuild_set_revision(tbb
  URL     "https://www.paraview.org/files/dependencies/${tbb_file}"
  URL_MD5 "${tbb_md5}")

superbuild_set_revision(matplotlib
  URL "https://www.paraview.org/files/dependencies/matplotlib-3.2.1.tar.gz"
  URL_MD5 9186b1e9f1fc7d555f2abf64b35dea5b)

superbuild_set_revision(expat
  URL     "https://www.paraview.org/files/dependencies/expat-2.4.1.tar.xz"
  URL_MD5 a4fb91a9441bcaec576d4c4a56fa3aa6)

superbuild_set_revision(eigen
  URL     "https://www.paraview.org/files/dependencies/eigen-3.3.9.tar.xz"
  URL_MD5 c57578fd48359af3f214bac3239d7c80)

superbuild_set_revision(llvm
  URL     "https://www.paraview.org/files/dependencies/llvm-7.0.0.src.tar.xz"
  URL_MD5 e0140354db83cdeb8668531b431398f0)

superbuild_set_revision(glproto
  URL     "https://www.paraview.org/files/dependencies/glproto-1.4.17.tar.bz2"
  URL_MD5 5565f1b0facf4a59c2778229c1f70d10)

superbuild_set_revision(mesa
  URL     "https://www.paraview.org/files/dependencies/mesa-21.2.1.tar.xz"
  URL_MD5 5d8beb41eccad604296d1e2a6688dd6a)
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
  URL     "https://www.paraview.org/files/data/ParaViewTutorialData-20210924.tar.gz"
  URL_MD5 c344ad4e0c677206fc2489bfc7bff811)

# Other than the `git` and `source` selections, the name of the selection
# should be the version number of the selection. See
# `superbuild_setup_variables` in `CMakeLists.txt` for the logic which relies
# on this assumption.
superbuild_set_selectable_source(paraview
  # NOTE: When updating this selection, also update the default version in
  # README.md and the PARAVIEW_VERSION_DEFAULT variable in CMakeLists.txt.
  SELECT 5.10.0-RC1 DEFAULT
    URL     "https://www.paraview.org/files/v5.10/ParaView-v5.10.0-RC1.tar.xz"
    URL_MD5 5a47c5725ce7ee0217c6c937b7ccb7d8
  SELECT git CUSTOMIZABLE
    GIT_REPOSITORY "https://gitlab.kitware.com/paraview/paraview.git"
    GIT_TAG        "origin/master"
  SELECT source CUSTOMIZABLE
    SOURCE_DIR "source-paraview")

superbuild_set_revision(ttk
  URL     "https://www.paraview.org/files/dependencies/ttk-0.9.10-graphviz-fixes.zip"
  URL_MD5 0154338fbffa92927ecadf6350ae67c7)

superbuild_set_revision(vrpn
  # https://github.com/vrpn/vrpn.git
  URL     "https://www.paraview.org/files/dependencies/vrpn-45375f61de4c1a7bb95fe5a9264ac48a5d395404.tar.bz2"
  URL_MD5 bce3ed067ea68c7cc115e3f2dfacc7ca)

superbuild_set_revision(vortexfinder2
  # https://github.com/hguo/vortexfinder2.git
  URL     "https://www.paraview.org/files/dependencies/vortexfinder2-bb76f80ad08223d49fb42e828c1416daa19f7ecb.tar.bz2"
  URL_MD5 47d12a5103d66b5db782c43c5255b26b)

superbuild_set_revision(surfacetrackercut
  # https://github.com/conniejhe/Surface-Cutting
  URL     "https://www.paraview.org/files/dependencies/Surface-Cutting-7fc11213d828d5bce62577fe0bc3ca1dbdfc9124.zip"
  URL_MD5 b329f3cc3734d75e529573a09662982b)

#------------------------------------------------------------------------------
# Optional Plugins. Doesn't affect ParaView binaries at all even if missing
# or disabled.
#------------------------------------------------------------------------------

superbuild_set_revision(socat
  URL     "https://www.paraview.org/files/dependencies/socat-1.7.4.1.tar.gz"
  URL_MD5 780d14908dc1a6aa2790de376ab56b7a)

if (WIN32)
  set(ispc_suffix "windows.zip")
  set(ispc_md5 22d1e9fd03427b8e8a9d75ce56cfa495)
elseif (APPLE)
  set(ispc_suffix "macOS.tar.gz")
  set(ispc_md5 0ae980be5d319b38592c6ef5596c305d)
else()
  set(ispc_suffix "linux.tar.gz")
  set(ispc_md5 4665c577541003e31c8ce0afd64b6952)
endif()
superbuild_set_revision(ispc
  URL     "https://www.paraview.org/files/dependencies/ispc-v1.16.1-${ispc_suffix}"
  URL_MD5 "${ispc_md5}")

superbuild_set_revision(embree
  URL     "https://www.paraview.org/files/dependencies/embree-v3.13.1.tar.gz"
  URL_MD5 71453f1e9af48a95090112e493982898)

superbuild_set_revision(openvkl
  URL     "https://www.paraview.org/files/dependencies/openvkl-v1.0.0.tar.gz"
  URL_MD5 beec5106d281dbbab17ce9547fe69e79)

superbuild_set_revision(snappy
  URL     "https://www.paraview.org/files/dependencies/snappy-1.1.9.tar.gz"
  URL_MD5 213b6324b7790d25f5368629540a172c)

superbuild_set_revision(ospray
  URL     "https://www.paraview.org/files/dependencies/ospray-v2.7.0.tar.gz"
  URL_MD5 1e68a00fffee696f9075373ee3b7af3e)

superbuild_set_revision(ospraymaterials
  URL     "https://www.paraview.org/files/data/OSPRayMaterials-0.3.tar.gz"
  URL_MD5 d256c17f70890d3477e90d35bf814c25)

superbuild_set_revision(openimagedenoise
  URL     "https://www.paraview.org/files/dependencies/oidn-1.4.1.src.tar.gz"
  URL_MD5 df4007b0ab93b1c41cdf223b075d01c0)

superbuild_set_revision(rkcommon
  URL     "https://www.paraview.org/files/dependencies/rkcommon-v1.7.0.tar.gz"
  URL_MD5 1bd26e5aea9b1c4873fe8b8cec9a1d28)

superbuild_set_revision(openvr
  URL     "https://www.paraview.org/files/dependencies/openvr_1.14.15_win_thin.tar.gz"
  URL_MD5 200a7896e81ecc981825dded25ae568d)

superbuild_set_revision(paraviewwebvisualizer
  URL     "https://www.paraview.org/files/dependencies/pvw-visualizer-3.2.2.tgz"
  URL_MD5 527f6cceb1088d111580aff09124eef6)

superbuild_set_revision(paraviewweblite
  URL     "https://www.paraview.org/files/dependencies/paraview-lite-1.5.0.tgz"
  URL_MD5 86085d39d8d3d12fd6699b29f61c64ea)

superbuild_set_revision(paraviewwebglance
  URL     "https://www.paraview.org/files/dependencies/paraview-glance-4.17.1.tgz"
  URL_MD5 54734de753d95ccdb5ba326a85bcf16f)

superbuild_set_revision(paraviewwebflow
  URL     "https://www.paraview.org/files/dependencies/paraview-flow-1.0.7.tgz"
  URL_MD5 50843ec3338687011a1d42018fde325d)

superbuild_set_revision(paraviewwebdivvy
  URL     "https://www.paraview.org/files/dependencies/pvw-divvy-1.4.0.tgz"
  URL_MD5 6d44a5ef69c7e0668c71a26eb943cf1e)

superbuild_set_revision(las
  URL     "https://www.paraview.org/files/dependencies/libLAS-1.8.1.tar.bz2"
  URL_MD5 2e6a975dafdf57f59a385ccb87eb5919)

superbuild_set_revision(lookingglass
  URL     "https://www.paraview.org/files/dependencies/HoloPlayCore-0.1.1-Open-20200923.tar.gz"
  URL_MD5 b435316fa1f8454ba180e72608c3c28f)

superbuild_set_revision(gmsh
  URL     "https://www.paraview.org/files/dependencies/gmsh-4.8.4-source.tgz"
  URL_MD5 1e7212dfb1319d745ffb477a7a3ff124)

if (WIN32)
  set(nvidiaindex_platform "windows-x64")
  set(nvidiaindex_2_1_md5 "f6efc09092771eb0bfb375a503a95c04")
  set(nvidiaindex_2_2_md5 "93bb894e7951227862ea308f7d6e2e18")
  set(nvidiaindex_2_3_md5 "f7374dfe3eec789b07957e4924fa029f")
  set(nvidiaindex_2_4_md5 "a11b9056683c52efe9f1d706e2926235")
  set(nvidiaindex_5_9_md5 "a778def725f20f7151778f684b19211b")
  set(nvidiaindex_5_9_1_md5 "4a2e39ca0820d6d342347b8f1c198f9e")
  set(nvidiaindex_5_10_md5 "91ff7eb462049b43f25f48778d1058b9")
elseif (UNIX AND NOT APPLE)
  if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "ppc64le")
    set(nvidiaindex_platform "linux-ppc64le")
    set(nvidiaindex_5_9_md5 "a6f1aa8847c3eeeceacec41bd98838ca")
    set(nvidiaindex_5_9_1_md5 "cb538a85c7a0b280f7cd05530b0205b5")
    set(nvidiaindex_5_10_md5 "09ae050780c694711b0f1ab058dfd5e3")
  else ()
    set(nvidiaindex_platform "linux")
    set(nvidiaindex_2_1_md5 "9fd5af702af6a6a6f2aba3a960703fb3")
    set(nvidiaindex_2_2_md5 "b97518f8b5d05497455e90ba5a0712f1")
    set(nvidiaindex_2_3_md5 "9c57d22f065f2ac7c978e6e6e06ebb69")
    set(nvidiaindex_2_4_md5 "39bb55a5bb5f8ba1e8f44fa68dc703d3")
    set(nvidiaindex_5_9_md5 "32599d5298a43ee9d4497886b79bdd65")
    set(nvidiaindex_5_9_1_md5 "23b5a9044bfeac812ed76cf5b3e8a35b")
    set(nvidiaindex_5_10_md5 "2fdc03e3674a41b37488f8bfc4965ec2")
  endif ()
endif ()
superbuild_set_selectable_source(nvidiaindex
  # XXX(index): Adding a new version? The Windows bundle script needs to know
  # too (nvrtc-builtins).
  SELECT 5.10 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/nvidia-index-libs-5.10.20210901-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_5_10_md5}"
  SELECT 5.9.1
    URL     "https://www.paraview.org/files/dependencies/nvidia-index-libs-5.9.20210503-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_5_9_1_md5}"
  SELECT 5.9
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

superbuild_set_revision(zstd
  URL     "https://www.paraview.org/files/dependencies/zstd-1.5.0.tar.gz"
  URL_MD5 "d5ac89d5df9e81243ce40d0c6a66691d")

superbuild_set_revision(blosc
  URL     "https://www.paraview.org/files/dependencies/blosc-1.21.0.tar.gz"
  URL_MD5 "c32104bef76e5636cf0cedb40fd4d77b")

superbuild_set_revision(zfp
  URL     "https://www.paraview.org/files/dependencies/zfp-0.5.5.tar.gz"
  URL_MD5 "bc7e5fb1cd4345d17f7b9d470a1f23e7")

superbuild_set_revision(zeromq
  URL     "https://www.paraview.org/files/dependencies/zeromq-4.3.4.tar.gz"
  URL_MD5 "c897d4005a3f0b8276b00b7921412379")

superbuild_set_selectable_source(adios2
  SELECT v2.7.1 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/adios-v2.7.1.tar.gz"
    URL_MD5 "b78e02946c4ff481679063220f9fc961"
  SELECT git CUSTOMIZABLE
    GIT_REPOSITORY "https://github.com/ornladios/ADIOS2.git"
    GIT_TAG        "origin/master")

superbuild_set_revision(libfabric
  URL     "https://www.paraview.org/files/dependencies/libfabric-1.13.0.tar.bz2"
  URL_MD5 "4d8bf93ef50e833ffce36e7cd7294569")

superbuild_set_revision(protobuf
  URL     "https://www.paraview.org/files/dependencies/protobuf-3.17.3.tar.gz"
  URL_MD5 "d7f8e0e3ffeac721e18cdf898eff7d31"
  SOURCE_SUBDIR cmake)

superbuild_set_revision(gdal
  # https://github.com/judajake/gdal-svn.git
  URL     "https://www.paraview.org/files/dependencies/gdal-98353693d6f1d607954220b2f8b040375e3d1744.tar.bz2"
  URL_MD5 5aa285dcc856f98ce44020ae1ae192cb)

superbuild_set_revision(launchers
  SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/launchers")

superbuild_set_revision(openpmd
  URL     "https://www.paraview.org/files/dependencies/openPMD-api-0.14.1.tar.gz"
  URL_MD5 "1f64ab59529f18c704848eaf6e2147ff")

superbuild_set_revision(pythonpkgconfig
  URL     "https://www.paraview.org/files/dependencies/pkgconfig-1.5.5.tar.gz"
  URL_MD5 "12523e11b91b050ca49975cc033689a4")

superbuild_set_revision(h5py
  URL     "https://www.paraview.org/files/dependencies/h5py-3.3.0.tar.gz"
  URL_MD5 "2f83b8afd70ad59d3bb69c0d0b7d61b1")

superbuild_set_revision(ninja
  URL     "https://www.paraview.org/files/dependencies/ninja-1.10.2.tar.gz"
  URL_MD5 639f75bc2e3b19ab893eaf2c810d4eb4)

superbuild_set_revision(meson
  URL     "https://www.paraview.org/files/dependencies/meson-0.59.1.tar.gz"
  URL_MD5 9c8135ecde820094be2f42f457fb6535)

superbuild_set_revision(blosc
  URL "https://www.paraview.org/files/dependencies/c-blosc-1.21.0.tar.gz"
  URL_MD5 c32104bef76e5636cf0cedb40fd4d77b)

superbuild_set_revision(openvdb
  URL "https://www.paraview.org/files/dependencies/openvdb-8.1.0.tar.gz"
  URL_MD5 3c621d99498731bb4a6c645969c63996)
