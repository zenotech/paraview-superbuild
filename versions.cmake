superbuild_set_revision(eigen
  # https://gitlab.com/libeigen/eigen/-/releases
  URL     "https://www.paraview.org/files/dependencies/eigen-3.4.0.tar.bz2"
  URL_MD5 132dde48fe2b563211675626d29f1707)

superbuild_set_revision(silo
  # https://github.com/LLNL/Silo/releases/tag/v4.11
  URL     "https://www.paraview.org/files/dependencies/silo-4.11-bsd-smalltest.tar.gz"
  URL_MD5 db5ac16cf8a84a40c3f9e80ca7f8dc6a)

superbuild_set_revision(genericio
  # https://git.cels.anl.gov/hacc/genericio/-/releases
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

# The main branch is always pulled even when release is built.
superbuild_set_selectable_source(paraviewtranslations
  SELECT git CUSTOMIZABLE DEFAULT
  GIT_REPOSITORY "https://gitlab.kitware.com/paraview/paraview-translations.git"
  GIT_TAG        "origin/main"
  )

# Other than the `git` and `source` selections, the name of the selection
# should be the version number of the selection. See
# `superbuild_setup_variables` in `CMakeLists.txt` for the logic which relies
# on this assumption.
superbuild_set_selectable_source(paraview
  # NOTE: When updating this selection, also update the default version in
  # README.md and the PARAVIEW_VERSION_DEFAULT variable in CMakeLists.txt.
  SELECT 5.11.1
    URL     "https://www.paraview.org/files/v5.11/ParaView-v5.11.1.tar.xz"
    URL_MD5 57d87137fd02e3491ea4167c72cf7794
  SELECT git CUSTOMIZABLE DEFAULT
    GIT_REPOSITORY "https://gitlab.kitware.com/paraview/paraview.git"
    GIT_TAG        "origin/master"
  SELECT source CUSTOMIZABLE
    SOURCE_DIR "source-paraview")

# This is a trimmed TTK archive:
# Removed: hidden files (CI, git, clang...)
# Removed: image files (png)
# Removed: doc/
# Removed: examples/
# Removed: scripts/
# Removed: standalone/
superbuild_set_revision(ttk
  # https://github.com/topology-tool-kit/ttk/releases
  URL     "https://www.paraview.org/files/dependencies/ttk-1.2.0-trimmed.zip"
  URL_MD5 fea1d3cb38b32aa9cd7edeec0b7321a1)

superbuild_set_revision(vrpn
  # https://github.com/vrpn/vrpn/releases
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
  # http://www.dest-unreach.org/socat/
  URL     "https://www.paraview.org/files/dependencies/socat-1.7.4.4.tar.gz"
  URL_MD5 db119a830a34ed4b0dacb0bb90baeb0e)

superbuild_set_revision(openvr
  # https://github.com/ValveSoftware/openvr/releases
  URL     "https://www.paraview.org/files/dependencies/openvr_1.14.15_win_thin.tar.gz"
  URL_MD5 200a7896e81ecc981825dded25ae568d)

superbuild_set_revision(paraviewwebvisualizer
  # https://github.com/Kitware/visualizer/releases
  URL     "https://www.paraview.org/files/dependencies/pvw-visualizer-3.2.2.tgz"
  URL_MD5 527f6cceb1088d111580aff09124eef6)

superbuild_set_revision(paraviewweblite
  # https://github.com/Kitware/paraview-lite/releases
  URL     "https://www.paraview.org/files/dependencies/paraview-lite-1.5.0.tgz"
  URL_MD5 86085d39d8d3d12fd6699b29f61c64ea)

superbuild_set_revision(paraviewwebglance
  # https://github.com/Kitware/glance/releases
  URL     "https://www.paraview.org/files/dependencies/paraview-glance-4.17.1.tgz"
  URL_MD5 54734de753d95ccdb5ba326a85bcf16f)

superbuild_set_revision(paraviewwebdivvy
  # https://github.com/Kitware/divvy/releases
  # Run: `npm view pvw-divvy dist.tarball`
  # URL looks like: https://registry.npmjs.org/pvw-divvy/-/pvw-divvy-1.4.0.tgz
  URL     "https://www.paraview.org/files/dependencies/pvw-divvy-1.4.0.tgz"
  URL_MD5 6d44a5ef69c7e0668c71a26eb943cf1e)

superbuild_set_revision(las
  # https://liblas.org/download.html
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
  # https://github.com/Looking-Glass/LookingGlassCoreSDK/releases
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
  # https://gmsh.info/#Download
  URL     "https://www.paraview.org/files/dependencies/gmsh-4.11.1-source.tgz"
  URL_MD5 681ccfa83213921884ede92a80191ba2)

if (WIN32)
  set(nvidiaindex_platform "windows-x64")
  set(nvidiaindex_2_1_md5 "f6efc09092771eb0bfb375a503a95c04")
  set(nvidiaindex_2_2_md5 "93bb894e7951227862ea308f7d6e2e18")
  set(nvidiaindex_2_3_md5 "f7374dfe3eec789b07957e4924fa029f")
  set(nvidiaindex_2_4_md5 "a11b9056683c52efe9f1d706e2926235")
  set(nvidiaindex_5_9_md5 "a778def725f20f7151778f684b19211b")
  set(nvidiaindex_5_9_1_md5 "4a2e39ca0820d6d342347b8f1c198f9e")
  set(nvidiaindex_5_10_md5 "91ff7eb462049b43f25f48778d1058b9")
  set(nvidiaindex_5_11_1_md5 "1c2dd496467ed7feeb46ce0a29b08d52")
elseif (UNIX AND NOT APPLE)
  if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "ppc64le")
    set(nvidiaindex_platform "linux-ppc64le")
    set(nvidiaindex_5_9_md5 "a6f1aa8847c3eeeceacec41bd98838ca")
    set(nvidiaindex_5_9_1_md5 "cb538a85c7a0b280f7cd05530b0205b5")
    set(nvidiaindex_5_10_md5 "09ae050780c694711b0f1ab058dfd5e3")
    set(nvidiaindex_5_11_1_md5 "99a270b09a4551c281a95e5246598676")
  else ()
    set(nvidiaindex_platform "linux")
    set(nvidiaindex_2_1_md5 "9fd5af702af6a6a6f2aba3a960703fb3")
    set(nvidiaindex_2_2_md5 "b97518f8b5d05497455e90ba5a0712f1")
    set(nvidiaindex_2_3_md5 "9c57d22f065f2ac7c978e6e6e06ebb69")
    set(nvidiaindex_2_4_md5 "39bb55a5bb5f8ba1e8f44fa68dc703d3")
    set(nvidiaindex_5_9_md5 "32599d5298a43ee9d4497886b79bdd65")
    set(nvidiaindex_5_9_1_md5 "23b5a9044bfeac812ed76cf5b3e8a35b")
    set(nvidiaindex_5_10_md5 "2fdc03e3674a41b37488f8bfc4965ec2")
    set(nvidiaindex_5_11_1_md5 "b54780c65ac6e903680db19f04641acf")
  endif ()
endif ()
# XXX(index): New version tarballs may be created given an IndeX deliverable
# and the `Scripts/index/extract-index.sh` script.
superbuild_set_selectable_source(nvidiaindex
  # XXX(index): Adding a new version? The Windows bundle script needs to know
  # too (nvrtc-builtins).
  SELECT 5.11.1 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/nvidia-index-libs-5.11.1.20230328-${nvidiaindex_platform}.tar.bz2"
    URL_MD5 "${nvidiaindex_5_11_1_md5}"
  SELECT 5.10
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
# are available from NVIDIA at the URLs in the comments in each revision set.
if (WIN32)
  set(nvidiaoptix_platform "win64")
  set(nvidiaoptix_md5 "1cc3026f4a1fc945e7158e8a66f8f9bd")
elseif (UNIX AND NOT APPLE)
  set(nvidiaoptix_platform "linux64")
  set(nvidiaoptix_md5 "b5e9cdcb691ad7813e4e24986579a1ef")
endif ()
superbuild_set_revision(nvidiaoptix
  # https://developer.nvidia.com/designworks/optix/download
  URL     "https://www.paraview.org/files/dependencies/internal/NVIDIA-OptiX-SDK-6.0.0-${nvidiaoptix_platform}-25650775.tar.gz"
  URL_MD5 "${nvidiaoptix_md5}")

superbuild_set_revision(nvidiamdl
  # https://developer.nvidia.com/mdl-sdk
  URL     "https://www.paraview.org/files/dependencies/internal/mdl-sdk-314800.830.tar.bz2"
  URL_MD5 "d500a122918741eb418887d66e03325b")

superbuild_set_revision(visrtx
  # https://github.com/NVIDIA/VisRTX/releases
  URL     "https://www.paraview.org/files/dependencies/visrtx-v0.1.6.tar.gz"
  URL_MD5 "c5fef9abd9d56bbbf2c222f0b0943e41")

superbuild_set_revision(rapidjson
  # https://github.com/Tencent/rapidjson/releases
  URL     "https://www.paraview.org/files/dependencies/rapidjson-1.1.0.tar.gz"
  URL_MD5 "badd12c511e081fec6c89c43a7027bce")

superbuild_set_revision(mili
  URL     "https://www.paraview.org/files/dependencies/mili-15.1.tar.gz"
  URL_MD5 "8848db9a5e692c010806d64b8c5e46a4")

superbuild_set_revision(zstd
  # https://github.com/facebook/zstd/releases
  URL     "https://www.paraview.org/files/dependencies/zstd-1.5.5.tar.gz"
  URL_MD5 "63251602329a106220e0a5ad26ba656f")

superbuild_set_revision(blosc
  # https://github.com/Blosc/c-blosc/releases
  URL     "https://www.paraview.org/files/dependencies/blosc-1.21.5.tar.gz"
  URL_MD5 "5097ee61dc1f25281811f5a55b91b2e4")

superbuild_set_revision(zfp
  # https://github.com/LLNL/zfp/releases
  URL     "https://www.paraview.org/files/dependencies/zfp-1.0.0.tar.gz"
  URL_MD5 "152b09067749f0f487f62a58d6c29920")

superbuild_set_revision(zeromq
  # Current: https://sourceforge.net/projects/zeromq.mirror/files/v4.3.4/
  # Future: https://github.com/zeromq/libzmq/releases
  URL     "https://www.paraview.org/files/dependencies/zeromq-4.3.4.tar.gz"
  URL_MD5 "c897d4005a3f0b8276b00b7921412379")

superbuild_set_selectable_source(adios2
  # https://github.com/ornladios/ADIOS2/releases
  SELECT v2.9.1 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/adios-v2.9.1.tar.gz"
    URL_MD5 "716ea25b2eca18eb7d35df68856d4640"
  SELECT git CUSTOMIZABLE
    GIT_REPOSITORY "https://github.com/ornladios/ADIOS2.git"
    GIT_TAG        "origin/master")

superbuild_set_revision(libfabric
  # https://github.com/ofiwg/libfabric/releases
  URL     "https://www.paraview.org/files/dependencies/libfabric-1.18.1.tar.bz2"
  URL_MD5 "1cca59cf18b3b7a8254668606e3014c5")

superbuild_set_revision(abseil
  # https://github.com/abseil/abseil-cpp/releases
  URL     "https://www.paraview.org/files/dependencies/abseil-20230802.0.tar.gz"
  URL_MD5 "f40605e07aa804aa82e7090f12db7e34")

superbuild_set_revision(protobuf
  # https://github.com/protocolbuffers/protobuf/releases
  URL     "https://www.paraview.org/files/dependencies/protobuf-24.1.tar.gz"
  URL_MD5 "95dc2473e40769cec9857e1a0826cf90")

superbuild_set_revision(tiff
  # https://gitlab.com/libtiff/libtiff/-/releases
  URL     "https://www.paraview.org/files/dependencies/tiff-4.5.1.tar.xz"
  URL_MD5 d8b8622f93e09435737a61e574e5dd48)

superbuild_set_revision(geotiff
  # https://github.com/OSGeo/libgeotiff/releases
  URL     "https://www.paraview.org/files/dependencies/libgeotiff-1.7.1.tar.gz"
  URL_MD5 22879ac6f83460605f9c39147a2ccc7a)

superbuild_set_revision(proj
  # https://github.com/OSGeo/PROJ/releases
  URL     "https://www.paraview.org/files/dependencies/proj-9.2.1.tar.gz"
  URL_MD5 c8e878049ef27330ac94624e1a75b0db)

superbuild_set_revision(jsonc
  # https://github.com/json-c/json-c/tags
  URL     "https://www.paraview.org/files/dependencies/json-c-0.17-20230812.tar.gz"
  URL_MD5 6d724389b0a08c519d9dd6e2fac7efb8)

superbuild_set_revision(gdal
  # https://github.com/OSGeo/gdal/releases
  URL     "https://www.paraview.org/files/dependencies/gdal-3.7.1.tar.gz"
  URL_MD5 e13a09602cefc5c91bde193a34345ef9)

superbuild_set_revision(pdal
  # https://github.com/PDAL/PDAL/releases
  URL     "https://www.paraview.org/files/dependencies/PDAL-2.5.1-src.tar.bz2"
  URL_MD5 a4bb3751daeb111aca7f0b30a58b45c5)

superbuild_set_revision(xerces
  # https://github.com/apache/xerces-c/tags
  URL     "https://www.paraview.org/files/dependencies/xerces-c-3.2.4.tar.xz"
  URL_MD5 63bf3c8b5a76e180fe97afeddee1d21e)

superbuild_set_revision(curl
  # https://github.com/curl/curl/releases
  URL     "https://www.paraview.org/files/dependencies/curl-7.88.1.tar.xz"
  URL_MD5 8bea0c58428578f397471fe209fad6ab)

superbuild_set_revision(launchers
  SOURCE_DIR "${CMAKE_CURRENT_LIST_DIR}/launchers")

superbuild_set_revision(openpmd
  # https://pypi.org/project/openPMD-api/#history
  URL     "https://www.paraview.org/files/dependencies/openPMD-api-0.15.2.tar.gz"
  URL_MD5 "31f85620215b9bc86b70b1ad96ba4588")

superbuild_set_revision(pythonpkgconfig
  # https://pypi.org/project/pkgconfig/#history
  URL     "https://www.paraview.org/files/dependencies/pkgconfig-1.5.5.tar.gz"
  URL_MD5 "12523e11b91b050ca49975cc033689a4")

superbuild_set_revision(h5py
  # https://pypi.org/project/h5py/#history
  URL     "https://www.paraview.org/files/dependencies/h5py-3.9.0.tar.gz"
  URL_MD5 "138d72aa1324c28a37842bc99467dfba")

superbuild_set_revision(openvdb
  # https://github.com/AcademySoftwareFoundation/openvdb/releases
  URL "https://www.paraview.org/files/dependencies/openvdb-8.2.0.tar.gz"
  URL_MD5 2852fe7176071eaa18ab9ccfad5ec403)

superbuild_set_selectable_source(catalyst
  SELECT git CUSTOMIZABLE DEFAULT
    GIT_REPOSITORY "https://gitlab.kitware.com/paraview/catalyst.git"
    GIT_TAG        "v2.0.0-rc4"
    )

superbuild_set_revision(cdi
  # https://code.mpimet.mpg.de/projects/cdi/files
  URL     "https://www.paraview.org/files/dependencies/cdi-2.1.0.tar.gz"
  URL_MD5 "31304b1d487d0350c57cda00d2d757c3")

superbuild_set_revision(occt
  # https://git.dev.opencascade.org/gitweb/?p=occt.git pick the tag you want, and download a snapshot.
  # current: 7.4.0p1
  # Extract, delete docs, tests, and sample data, and recompress as .tar.bz2
  URL     "https://www.paraview.org/files/dependencies/occt-7.4.0p1-stripped.tar.bz2"
  URL_MD5 24b95c5d55558ba087b9565f30c67718)

superbuild_set_revision(medfile
  # Fill out this form: https://www.salome-platform.org/?page_id=2430
  URL           "https://www.paraview.org/files/dependencies/med-5.0.0.tar.bz2"
  DOWNLOAD_NAME medfile-5.0.0.tar.bz2
  URL_MD5       3c5ae8a37d7971658870b77caad1d73b)

superbuild_set_revision(medcoupling
  # https://git.salome-platform.org/gitweb/?p=tools/medcoupling.git;a=summary, pick the tag you want,
  # click on snapshot to download an archive.
  # Current:  06f4a5b378e649182161d639b3a05ead43eba660 / medcoupling-06f4a5b.tar.gz
  URL           "https://www.paraview.org/files/dependencies/medcoupling-06f4a5b.tar.gz"
  DOWNLOAD_NAME medcoupling-06f4a5b.tar.gz
  URL_MD5       002e769ffbfe5c4b93c7d931d1b82a1a)

superbuild_set_revision(medconfiguration
  # https://git.salome-platform.org/gitweb/?p=tools/configuration.git;a=summary, pick the tag you want,
  # click on snapshot to download an archive.
  # Current: V9_10_0 / configuration-25f724f.tar.gz
  URL           "https://www.paraview.org/files/dependencies/configuration-27b2639.tar.gz"
  DOWNLOAD_NAME medconfiguration-27b2639.tar.gz
  URL_MD5       98670c18d604af55b67a4f7f3d38b7c4)

superbuild_set_revision(medreader
  # https://git.salome-platform.org/gitweb/?p=modules/paravis.git;a=summary, pick the tag you want,
  # click on snapshot to download an archive.
  # Current: 10af7126b07b636a9fdb7c9d879e6390998c7da4 / paravis-10af712.tar.gz
  URL           "https://www.paraview.org/files/dependencies/paravis-10af712.tar.gz"
  DOWNLOAD_NAME paravis-10af712.tar.gz
  URL_MD5       75234547c6fee0188720394450a6f861)

superbuild_set_revision(openxrremoting
  # https://www.nuget.org/packages/Microsoft.Holographic.Remoting.OpenXr/
  URL           "https://www.paraview.org/files/dependencies/microsoft.holographic.remoting.openxr.2.8.1.nupkg"
  URL_MD5       eebf01614d89e91783114edd1bccaa59)
