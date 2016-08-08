superbuild_set_revision(llvm
  URL     "http://paraview.org/files/dependencies/llvm-3.8.1.src.tar.xz"
  URL_MD5 538467e6028bbc9259b1e6e015d25845)

superbuild_set_revision(manta
  URL     "http://paraview.org/files/dependencies/manta-r2439.tar.gz"
  URL_MD5 fbf4107fe2f6d7e8a5ae3dda71805bdc)

superbuild_set_revision(mesa
  URL     "http://paraview.org/files/dependencies/mesa-12.0.1.tar.xz"
  URL_MD5 972fd5ad5a63aeabf173fb9adefc6522)

get_property(mesa_revision GLOBAL
  PROPERTY mesa_revision)
superbuild_set_external_source(osmesa
  ${mesa_revision})
unset(mesa_revision)

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
  URL     "http://www.paraview.org/files/dependencies/cgnslib_3.1.3-4.tar.gz"
  URL_MD5 442bba32b576f3429cbd086af43fd4ae)

superbuild_set_revision(genericio
  GIT_REPOSITORY "https://kwgitlab.kitware.com/paraview/genericio.git"
  GIT_TAG        origin/master)

superbuild_set_revision(acusolve
  GIT_REPOSITORY "https://kwgitlab.kitware.com/paraview/acusolvereaderplugin.git"
  GIT_TAG        origin/master)

superbuild_set_revision(vistrails
  GIT_REPOSITORY "https://kwgitlab.kitware.com/paraview/vistrails.git"
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
  "http://www.paraview.org/files/v5.1/ParaView-v5.1.2.tar.gz"
  "44fb32fc8988fcdfbc216c9e40c3e925")

get_property(paraview_revision GLOBAL
  PROPERTY paraview_revision)
superbuild_set_external_source(catalyst
  ${paraview_revision})
unset(paraview_revision)

superbuild_set_revision(vrpn
  GIT_REPOSITORY "https://github.com/vrpn/vrpn.git"
  GIT_TAG        a545ef6415f0026aabdbdb1d7fdbefeb91c47d4f)

superbuild_set_revision(vortexfinder2
  #GIT_REPOSITORY "https://github.com/hguo/vortexfinder2.git"
  #GIT_TAG        2bdae9bfc0f36e1013a4b41c5d25c9e6ebbf1701)
  GIT_REPOSITORY "https://github.com/tjcorona/vortexfinder2.git"
  GIT_TAG        origin/master)

#------------------------------------------------------------------------------
# Optional Plugins. Doesn't affect ParaView binaries at all even if missing
# or disabled.
#------------------------------------------------------------------------------

superbuild_set_revision(portfwd
  URL     "http://www.paraview.org/files/dependencies/portfwd-0.29.tar.gz"
  URL_MD5 93161c91e12b0d67ca52dc13708a2f2f)

set(ispc_ver "1.9.0")
if (WIN32)
  set(ispc_file "https://sourceforge.net/projects/ispcmirror/files/v${ispc_ver}/ispc-v${ispc_ver}-windows-vs2013.zip")
  set(ispc_md5 "436101ac570b3d1e29f106e10d466c31")
elseif (APPLE)
  set(ispc_file "https://sourceforge.net/projects/ispcmirror/files/v${ispc_ver}/ispc-v${ispc_ver}-osx.tar.gz")
  set(ispc_md5 "2e95991e9d29e8d512b906a27e7775c5")
else ()
  set(ispc_file "http://sourceforge.net/projects/ispcmirror/files/v${ispc_ver}/ispc-v${ispc_ver}-linux.tar.gz")
  set(ispc_md5 "18e60e1b554fa08cace2a4e40102a908")
endif ()
superbuild_set_revision(ispc
  URL     "${ispc_file}"
  URL_MD5 "${ispc_md5}")

superbuild_set_revision(ospray
  GIT_REPOSITORY "https://github.com/mathstuf/ospray.git"
  GIT_TAG        origin/for/paraview)

superbuild_set_revision(paraviewwebvisualizer
  URL     "https://github.com/Kitware/visualizer/archive/v1.0.14.tar.gz"
  URL_MD5 c6d78419da091f7107d5895216194880)
