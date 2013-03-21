set(pythonexe)
#set(buildcmd)
if (${python_ENABLED})
  #tell paraview to do python build with the python made in host tools pass
  set(pythonexe "-DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_HOST_EXE}")
  #set(buildcmd "BUILD_COMMAND LD_LIBRARY_PATH=${PYTHON_HOST_LIBDIR}:$LD_LIBRARY_PATH bash -c make")
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
    -DBOOST_INCLUDEDIR:PATH=${BOOST_HOST_INCLUDEDIR}
    ${pythonexe}
    ${PARAVIEW_OPTIONS}
    -C ${PARAVIEW_TRYRUN_FILE}

  #${buildcmd}

  INSTALL_COMMAND
    echo "Skipping install"

  LIST_SEPARATOR +
)

conditionally_patch_for_crosscompilation(ParaView)
conditionally_patch_for_crosscompilation(VTK)
conditionally_patch_for_crosscompilation(Protobuf)
