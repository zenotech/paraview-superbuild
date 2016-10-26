superbuild_set_revision(llvm
  URL     "http://paraview.org/files/dependencies/llvm-3.8.1.src.tar.xz"
  URL_MD5 538467e6028bbc9259b1e6e015d25845)

superbuild_set_selectable_source(mesa
  SELECT v12.0.3 DEFAULT
    URL     "http://paraview.org/files/dependencies/mesa-12.0.3.tar.xz"
    URL_MD5 1113699c714042d8c4df4766be8c57d8
  SELECT v13.0.0-rc2
    URL     "http://paraview.org/files/dependencies/mesa-13.0.0-rc2.tar.xz"
    URL_MD5 ac32eb49c8f5ba698013502a0aac79a5
  SELECT git
    GIT_REPOSITORY "https://gitlab.kitware.com/third-party/mesa.git"
    GIT_TAG        "origin/master")
get_property(mesa_revision GLOBAL
  PROPERTY mesa_revision)
superbuild_set_revision(osmesa
  ${mesa_revision})

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
  URL     "http://paraview.org/files/dependencies/silo-4.9.1-bsd.tar.gz"
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

set(paraview_doc_ver_series "5.1")
set(paraview_doc_ver "${paraview_doc_ver_series}.0")
superbuild_set_revision(paraviewusersguide
  URL     "http://www.paraview.org/files/v${paraview_doc_ver_series}/ParaViewGuide-${paraview_doc_ver}.pdf"
  URL_MD5 180d5065869789a119db60f38a8661f1)
superbuild_set_revision(paraviewgettingstartedguide
  URL     "http://www.paraview.org/files/v${paraview_doc_ver_series}/ParaViewGettingStarted-${paraview_doc_ver}.pdf"
  URL_MD5 7ce54ce8a8b36c746035c2b228713074)
superbuild_set_revision(paraviewtutorial
  URL     "http://www.paraview.org/files/v${paraview_doc_ver_series}/ParaViewTutorial.pdf"
  URL_MD5 4b1c410cd461f68a3bac5839c22bee93)
superbuild_set_revision(paraviewtutorialdata
  URL     "http://www.paraview.org/files/data/ParaViewTutorialData.tar.gz"
  URL_MD5 ff7ceab8cfc674b227c0bba392d1ed3c)

superbuild_set_external_source(paraview
  "https://gitlab.kitware.com/paraview/paraview.git" "origin/master"
  "http://www.paraview.org/files/v5.2/ParaView-v5.2.0-RC2.tar.gz"
  "01c8f00914707689284866c53a990384")

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
  # https://github.com/tjcorona/vortexfinder2.git
  URL     "http://www.paraview.org/files/dependencies/vortexfinder2-a960bf8d3e5d0dfdfd6669224950e7e55e36b6fa.tar.bz2"
  URL_MD5 16ed366bb6459252b1ad6a86eced9480)

#------------------------------------------------------------------------------
# Optional Plugins. Doesn't affect ParaView binaries at all even if missing
# or disabled.
#------------------------------------------------------------------------------

superbuild_set_revision(portfwd
  URL     "http://www.paraview.org/files/dependencies/portfwd-0.29.tar.gz"
  URL_MD5 93161c91e12b0d67ca52dc13708a2f2f)

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

superbuild_set_revision(ospray
  URL     "http://www.paraview.org/files/dependencies/ospray-v1.1.0.tar.gz"
  URL_MD5 77f177dd60a452d6b0e60c506e2bcc2a)

superbuild_set_revision(paraviewwebvisualizer
  URL     "http://www.paraview.org/files/dependencies/paraview-web-visualizer-v2.0.10.tar.gz"
  URL_MD5 895067cc7fa62a55b9d7af531e006a89)
