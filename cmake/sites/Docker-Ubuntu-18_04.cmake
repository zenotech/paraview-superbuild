
# Where should ParaView get installed
set(CMAKE_INSTALL_PREFIX "/opt/paraview" CACHE PATH "")

# Where will superbuild download its source tarballs
set(superbuild_download_location "/home/pv-user/pvsb/downloads" CACHE PATH "")

# How do we get ParaView
message("Using paraview git tag: $ENV{PARAVIEW_TAG}")
set(paraview_FROM_GIT ON CACHE BOOL "")
set(paraview_GIT_TAG $ENV{PARAVIEW_TAG} CACHE STRING "")
set(paraview_SOURCE_SELECTION git CACHE STRING "")

# Build w/ either egl or osmesa
if("$ENV{RENDERING}" STREQUAL "egl")
  message('Builing with EGL rendering')

  set(ENABLE_egl ON CACHE BOOL "")
  set(USE_SYSTEM_egl ON CACHE BOOL "")
  set(EGL_INCLUDE_DIR "/usr/include" CACHE PATH "")
  set(EGL_LIBRARY "/usr/lib/x86_64-linux-gnu/libEGL.so" CACHE FILEPATH "")
  set(EGL_gldispatch_LIBRARY "/usr/lib/x86_64-linux-gnu/libGLdispatch.so" CACHE FILEPATH "")
  set(EGL_opengl_LIBRARY "/usr/lib/x86_64-linux-gnu/libOpenGL.so" CACHE FILEPATH "")

  set(PARAVIEW_EXTRA_CMAKE_ARGUMENTS "-DOpenGL_GL_PREFERENCE:STRING=GLVND" CACHE STRING "")

  # If we have support for EGL, index and rtx would be nice eventually too
  set(ENABLE_nvidiaindex OFF CACHE BOOL "")
  set(ENABLE_visrtx OFF CACHE BOOL "")
else()
  message('Builing with OSMESA rendering')
  set(ENABLE_osmesa ON CACHE BOOL "")
  set(mesa_USE_SWR ON CACHE BOOL "")
endif()

# General rendering/graphics options
set(ENABLE_mesa OFF CACHE BOOL "")

# Don't build launchers for mesa or mpi
set(ENABLE_launchers OFF CACHE BOOL "")

# Some general options
set(BUILD_SHARED_LIBS ON CACHE BOOL "")
set(CMAKE_BUILD_TYPE $ENV{BUILD_TYPE} CACHE STRING "")
set(BUILD_TESTING ON CACHE BOOL "")

# ParaView related
set(ENABLE_paraview ON CACHE BOOL "")
set(ENABLE_paraviewweb ON CACHE BOOL "")
set(ENABLE_paraviewgettingstartedguide OFF CACHE BOOL "")
set(ENABLE_paraviewtutorial OFF CACHE BOOL "")
set(ENABLE_paraviewusersguide OFF CACHE BOOL "")
set(ENABLE_paraviewtutorialdata OFF CACHE BOOL "")

# Python related
set(ENABLE_python ON CACHE BOOL "")
if("$ENV{PYTHON_VERSION}" STREQUAL "2")
  set(ENABLE_python2 ON CACHE BOOL "")
  set(USE_SYSTEM_python2 ON CACHE BOOL "")
  set(ENABLE_python3 OFF CACHE BOOL "")
  set(USE_SYSTEM_python3 OFF CACHE BOOL "")
else()
  set(ENABLE_python2 OFF CACHE BOOL "")
  set(USE_SYSTEM_python2 OFF CACHE BOOL "")
  set(ENABLE_python3 ON CACHE BOOL "")
  set(USE_SYSTEM_python3 ON CACHE BOOL "")
endif()
set(USE_SYSTEM_pythonsetuptools ON CACHE BOOL "")
set(ENABLE_matplotlib ON CACHE BOOL "")
set(ENABLE_scipy ON CACHE BOOL "")

# VTK-m related
set(ENABLE_vtkm ON CACHE BOOL "")
set(vtkm_SOURCE_SELECTION for-git CACHE STRING "")

# Disable Qt5 stuff
set(ENABLE_qt5 OFF CACHE BOOL "")
set(USE_SYSTEM_qt5 OFF CACHE BOOL "")

# Other options
set(ENABLE_ospray ON CACHE BOOL "")
set(ENABLE_netcdf OFF CACHE BOOL "")
set(ENABLE_hdf5 ON CACHE BOOL "")
set(ENABLE_szip ON CACHE BOOL "")
set(ENABLE_visitbridge ON CACHE BOOL "")
set(ENABLE_ffmpeg ON CACHE BOOL "")
set(ENABLE_vistrails ON CACHE BOOL "")
set(ENABLE_mpi ON CACHE BOOL "")
set(ENABLE_silo ON CACHE BOOL "")
set(ENABLE_xdmf3 ON CACHE BOOL "")
set(ENABLE_h5py ON CACHE BOOL "")
set(ENABLE_numpy ON CACHE BOOL "")
set(ENABLE_cosmotools ON CACHE BOOL "")
set(DIY_SKIP_SVN ON CACHE BOOL "")
set(ENABLE_glu ON CACHE BOOL "")
set(ENABLE_tbb ON CACHE BOOL "")
set(ENABLE_boost ON CACHE BOOL "")
set(ENABLE_vortexfinder2 OFF CACHE BOOL "")
set(USE_NONFREE_COMPONENTS ON CACHE BOOL "")
set(ENABLE_las ON CACHE BOOL "")
set(ENABLE_acusolve ON CACHE BOOL "")
set(ENABLE_fontconfig ON CACHE BOOL "")

# FIXME: We should be able to have these, but they didn't work at some point
set(ENABLE_vrpn OFF CACHE BOOL "")

set(CTEST_USE_LAUNCHERS TRUE CACHE BOOL "")
