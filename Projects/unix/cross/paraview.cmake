set(pythonexe)
#set(buildcmd)
if (${python_ENABLED})
  #tell paraview to do python build with the python made in host tools pass
  set(pythonexe "-DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_HOST_EXE}")
  #set(buildcmd "BUILD_COMMAND LD_LIBRARY_PATH=${PYTHON_HOST_LIBDIR}:$LD_LIBRARY_PATH bash -c make")
  set(pythoninc "-DPYTHON_INCLUDE_DIR:PATH=${install_location}/include/python2.7")
  set(pythonlib "-DPYTHON_LIBRARY:FILEPATH=${install_location}/lib/libpython2.7.a")
endif()

add_external_project(paraview
  DEPENDS
    mesa
  DEPENDS_OPTIONAL
    python

  CMAKE_ARGS
    -DCMAKE_TOOLCHAIN_FILE=${PARAVIEW_TOOLCHAIN_FILE}
    -DParaViewCompileTools_DIR=${PARAVIEW_HOSTTOOLS_DIR}
    -DPARAVIEW_ENABLE_PYTHON:BOOL=${python_ENABLED}
    -DVTK_USE_X:BOOL=FALSE
    -DOPENGL_INCLUDE_DIR:PATH=${install_location}/include
    -DOPENGL_gl_LIBRARY=
    -DOPENGL_glu_LIBRARY:FILEPATH=${install_location}/lib/libGLU.a
    -DVTK_OPENGL_HAS_OSMESA:BOOL=TRUE
    -DOSMESA_LIBRARY:FILEPATH=${install_location}/lib/libOSMesa.a
    -DOSMESA_INCLUDE_DIR:PATH=${install_location}/include
    -DBoost_INCLUDE_DIR:PATH=${BOOST_HOST_INCLUDEDIR}
    -DPARAVIEW_INSTALL_DEVELOPMENT_FILES:BOOL=${paraviewsdk_ENABLED}
    ${pythonexe}
    ${pythoninc}
    ${pythonlib}
    ${PARAVIEW_OPTIONS}
    -C ${PARAVIEW_TRYRUN_FILE}
)

conditionally_patch_for_crosscompilation(ParaView)
conditionally_patch_for_crosscompilation(VTK)
conditionally_patch_for_crosscompilation(Protobuf)
