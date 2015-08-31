superbuild_set_revision(qhull
  GIT_REPOSITORY "https://github.com/mathstuf/qhull.git"
  GIT_TAG        origin/next)

superbuild_set_revision(llvm
  URL     "http://paraview.org/files/dependencies/llvm-3.8.1.src.tar.xz"
  URL_MD5 538467e6028bbc9259b1e6e015d25845)

superbuild_set_revision(osmesa
  URL     "http://paraview.org/files/dependencies/mesa-12.0.1.tar.xz"
  URL_MD5 972fd5ad5a63aeabf173fb9adefc6522)

superbuild_set_revision(manta
  URL     "http://paraview.org/files/dependencies/manta-r2439.tar.gz"
  URL_MD5 fbf4107fe2f6d7e8a5ae3dda71805bdc)

superbuild_set_revision(mesa
  URL     "http://paraview.org/files/dependencies/mesa-12.0.1.tar.xz"
  URL_MD5 972fd5ad5a63aeabf173fb9adefc6522)

superbuild_set_revision(diy
  GIT_REPOSITORY "https://gitlab.kitware.com/paraview/diy.git"
  GIT_TAG        origin/for/paraview) # r178 + patch

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

add_revision(vrpn
  GIT_REPOSITORY "https://github.com/vrpn/vrpn.git"
  GIT_TAG a545ef6415f0026aabdbdb1d7fdbefeb91c47d4f)

# ----------------------------------------------------------------------------
# You choose to download ParaView source form GIT or other URL/FILE tarball
option(ParaView_FROM_GIT "If enabled then the repository is fetched from git" ON)
cmake_dependent_option(ParaView_FROM_SOURCE_DIR "Enable to use existing ParaView source." OFF
  "NOT ParaView_FROM_GIT" OFF)

if (ParaView_FROM_GIT)
  # Download PV from GIT
  add_customizable_revision(paraview
    GIT_REPOSITORY https://gitlab.kitware.com/paraview/paraview.git
    GIT_TAG "master")
else()
  if (ParaView_FROM_SOURCE_DIR)
    add_customizable_revision(paraview
      SOURCE_DIR "ParaViewSource")
  else()
    # Variables to hold the URL and MD5 (optional)
    add_customizable_revision(paraview
      URL "http://www.paraview.org/files/v5.1/ParaView-v5.1.2.tar.gz"
      URL_MD5 "44fb32fc8988fcdfbc216c9e40c3e925")
  endif()
endif()

add_revision(catalyst ${paraview_revision})

#------------------------------------------------------------------------------
# Optional Plugins. Doesn't affect ParaView binaries at all even if missing
# or disabled.
#------------------------------------------------------------------------------

if (USE_NONFREE_COMPONENTS)
  add_revision(genericio
    GIT_REPOSITORY https://kwgitlab.kitware.com/paraview/genericio.git
    GIT_TAG master)

  add_revision(cosmotools
    GIT_REPOSITORY git://public.kitware.com/cosmotools.git
    GIT_TAG v0.13)

  add_revision(acusolve
    GIT_REPOSITORY https://kwgitlab.kitware.com/paraview/acusolvereaderplugin.git
    GIT_TAG master)

  add_revision(vistrails
    GIT_REPOSITORY https://kwgitlab.kitware.com/paraview/vistrails.git
    GIT_TAG master)
endif ()

#add_customizable_revision(vortexfinder2
#  GIT_REPOSITORY https://github.com/hguo/vortexfinder2.git
#  GIT_TAG 2bdae9bfc0f36e1013a4b41c5d25c9e6ebbf1701)
add_customizable_revision(vortexfinder2
  GIT_REPOSITORY https://github.com/tjcorona/vortexfinder2.git
  GIT_TAG master)

add_revision(portfwd
  URL "http://www.paraview.org/files/dependencies/portfwd-0.29.tar.gz"
  URL_MD5 93161c91e12b0d67ca52dc13708a2f2f)

set(ispc_file "")
set(ispc_md5 "")
if (WIN32)
  set(ispc_file
    "https://sourceforge.net/projects/ispcmirror/files/v1.9.0/ispc-v1.9.0-windows-vs2013.zip")
  set(ispc_md5 "436101ac570b3d1e29f106e10d466c31")
elseif (APPLE)
  set(ispc_file
    "https://sourceforge.net/projects/ispcmirror/files/v1.9.0/ispc-v1.9.0-osx.tar.gz")
  set(ispc_md5 "2e95991e9d29e8d512b906a27e7775c5")
else ()
  set(ispc_file
    "http://sourceforge.net/projects/ispcmirror/files/v1.9.0/ispc-v1.9.0-linux.tar.gz")
  set(ispc_md5 "18e60e1b554fa08cace2a4e40102a908")
endif ()
add_revision(ispc
  URL "${ispc_file}"
  URL_MD5 "${ispc_md5}"
  )

add_revision(ospray
  GIT_REPOSITORY "https://github.com/ospray/ospray.git"
  GIT_TAG "v0.10.0")

add_revision(paraviewusersguide
  URL "http://www.paraview.org/files/v5.1/ParaViewGuide-5.1.0.pdf")
add_revision(paraviewgettingstartedguide
  URL "http://www.paraview.org/files/v5.1/ParaViewGettingStarted-5.1.0.pdf")
add_revision(paraviewtutorial
  URL "http://www.paraview.org/files/v5.1/ParaViewTutorial.pdf")
add_revision(paraviewtutorialdata
  URL "http://www.paraview.org/files/data/ParaViewTutorialData.tar.gz")
