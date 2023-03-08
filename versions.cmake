superbuild_set_revision(matplotlib
  URL "https://www.paraview.org/files/dependencies/matplotlib-3.2.1.tar.gz"
  URL_MD5 9186b1e9f1fc7d555f2abf64b35dea5b)

superbuild_set_revision(expat
  URL     "https://www.paraview.org/files/dependencies/expat-2.4.1.tar.xz"
  URL_MD5 a4fb91a9441bcaec576d4c4a56fa3aa6)

superbuild_set_revision(eigen
  URL     "https://www.paraview.org/files/dependencies/eigen-3.3.9.tar.xz"
  URL_MD5 c57578fd48359af3f214bac3239d7c80)

superbuild_set_revision(silo
  URL     "https://www.paraview.org/files/dependencies/silo-4.10.2-bsd-smalltest.tar.gz"
  URL_MD5 d2a9023f63de361d91f94646d5d1974e)

superbuild_set_revision(genericio
  URL     "https://www.paraview.org/files/dependencies/genericio-master-4fddf723bca61c87f51dba1d9f215dfdd6e5b31d.tar.xz"
  URL_MD5 0d06f2105b8479e7a4e5436c5f38ae71)

set(paraview_doc_ver_series "5.11")
set(paraview_doc_ver "${paraview_doc_ver_series}.0")
superbuild_set_revision(paraviewgettingstartedguide
  URL     "https://www.paraview.org/files/v${paraview_doc_ver_series}/ParaViewGettingStarted-${paraview_doc_ver}.pdf"
  URL_MD5 392a29c111c5867b51e78bcb83e64198)
superbuild_set_revision(paraviewtutorialdata
  URL     "https://www.paraview.org/files/data/ParaViewTutorialData-20220629.tar.gz"
  URL_MD5 f8cd0e93ecd16d2753d5b147a5711a7c)

# Other than the `git` and `source` selections, the name of the selection
# should be the version number of the selection. See
# `superbuild_setup_variables` in `CMakeLists.txt` for the logic which relies
# on this assumption.
superbuild_set_selectable_source(paraview
  # NOTE: When updating this selection, also update the default version in
  # README.md and the PARAVIEW_VERSION_DEFAULT variable in CMakeLists.txt.
  SELECT 5.11.1-RC1 DEFAULT
    URL     "https://www.paraview.org/files/v5.11/ParaView-v5.11.1-RC1.tar.xz"
    URL_MD5 d41e97f57f66f441618586e80111afa4
  SELECT git CUSTOMIZABLE
    GIT_REPOSITORY "https://gitlab.kitware.com/paraview/paraview.git"
    GIT_TAG        "origin/master"
  SELECT source CUSTOMIZABLE
    SOURCE_DIR "source-paraview")

superbuild_set_revision(ttk
  URL     "https://www.paraview.org/files/dependencies/ttk-1.1.0.zip"
  URL_MD5 3b98ccd4cc7734e89f78f4e9b367fcf9)

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
  URL "https://www.paraview.org/files/dependencies/Surface-Cutting-d808cb1493be2ea982cd80f21ff6a5d92e7ac890.zip"
  URL_MD5 098edb571179e034c93c5d4b41ffba5d)

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
  URL     "https://www.paraview.org/files/dependencies/openvkl-v1.0.1.tar.gz"
  URL_MD5 c6a9a222df0e7f21b49ea8081b509171)

superbuild_set_revision(snappy
  URL     "https://www.paraview.org/files/dependencies/snappy-1.1.9.tar.gz"
  URL_MD5 213b6324b7790d25f5368629540a172c)

superbuild_set_revision(ospray
  URL     "https://www.paraview.org/files/dependencies/ospray-v2.7.1.tar.gz"
  URL_MD5 e027ca7a5119300a0c94c3f9be38b58d)

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

superbuild_set_revision(paraviewwebdivvy
  URL     "https://www.paraview.org/files/dependencies/pvw-divvy-1.4.0.tgz"
  URL_MD5 6d44a5ef69c7e0668c71a26eb943cf1e)

superbuild_set_revision(las
  URL     "https://www.paraview.org/files/dependencies/libLAS-1.8.1.tar.bz2"
  URL_MD5 2e6a975dafdf57f59a385ccb87eb5919)

if (UNIX AND NOT APPLE)
  # Downgrade the version that Linux uses, because the latest version was
  # built with too new of a glibc version.
  set(lookingglass_file "HoloPlayCore-0.1.1-Open-20200923.tar.gz")
  set(lookingglass_md5 b435316fa1f8454ba180e72608c3c28f)
else ()
  set(lookingglass_file "LookingGlassCoreSDK-Open-20220819.tgz")
  set(lookingglass_md5 23a2a373c9d1c0f203251dc244f97f79)
endif ()
superbuild_set_revision(lookingglass
  URL     "https://www.paraview.org/files/dependencies/${lookingglass_file}"
  URL_MD5 "${lookingglass_md5}")

# license does not allow public distribution - external devs should download the SDK themselves.
# https://3dconnexion.com/us/software-developer-program/
if (WIN32)
  superbuild_set_revision(threedxwaresdk
    URL     "https://www.paraview.org/files/dependencies/internal/3DxWare_SDK_v4-0-2_r17624.zip"
    URL_MD5 92a2acf48b0f30066acf052d00f663fd)
elseif(APPLE)
  superbuild_set_revision(threedxwaresdk
    URL     "https://www.paraview.org/files/dependencies/internal/3DxWareMac_v10-7-2_r3454_MacOS.tgz"
    URL_MD5 b1dad69c070ae401d54fb36618c5f4b2)
endif()

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
  SELECT v2.8.3 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/adios-v2.8.3.tar.gz"
    URL_MD5 "80a36713332517b4ff0c927dedc0a662"
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

superbuild_set_revision(tiff
  URL     "https://www.paraview.org/files/dependencies/libtiff-v4.4.0.tar.bz2"
  URL_MD5 ba175e36b1f6929da1c3c676b98c5db3)

superbuild_set_revision(geotiff
  URL     "https://www.paraview.org/files/dependencies/libgeotiff-1.7.1.tar.gz"
  URL_MD5 22879ac6f83460605f9c39147a2ccc7a)

superbuild_set_revision(proj
  URL     "https://www.paraview.org/files/dependencies/proj-9.0.1.tar.gz"
  URL_MD5 d4eca355288bbfe35caaedbd595787dc)

superbuild_set_revision(jsonc
  URL     "https://www.paraview.org/files/dependencies/json-c-0.16-20220414.tar.gz"
  URL_MD5 4f3288a5f14e0e6abe914213f41234e0)

superbuild_set_revision(gdal
  URL     "https://www.paraview.org/files/dependencies/gdal-3.5.1.tar.gz"
  URL_MD5 90ec67df8648e36795937c07406815ea)

superbuild_set_revision(launchers
  SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/launchers")

superbuild_set_revision(openpmd
  URL     "https://www.paraview.org/files/dependencies/openPMD-api-0.14.3.tar.gz"
  URL_MD5 "1b840b111b24c3bad5e22a0405492613")

superbuild_set_revision(pythonpkgconfig
  URL     "https://www.paraview.org/files/dependencies/pkgconfig-1.5.5.tar.gz"
  URL_MD5 "12523e11b91b050ca49975cc033689a4")

superbuild_set_revision(h5py
  URL     "https://www.paraview.org/files/dependencies/h5py-3.3.0.tar.gz"
  URL_MD5 "2f83b8afd70ad59d3bb69c0d0b7d61b1")

superbuild_set_revision(openvdb
  URL "https://www.paraview.org/files/dependencies/openvdb-8.2.0.tar.gz"
  URL_MD5 2852fe7176071eaa18ab9ccfad5ec403)

superbuild_set_selectable_source(catalyst
  SELECT git CUSTOMIZABLE DEFAULT
    GIT_REPOSITORY "https://gitlab.kitware.com/paraview/catalyst.git"
    GIT_TAG        "3f7871c0a2e737cb9ed35fc1c2208456fcc00a0e"
    )
