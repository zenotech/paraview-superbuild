set(paraviewweb_depends)
if (WIN32)
  list(APPEND paraviewweb_depends
    pywin32)
endif ()

superbuild_add_dummy_project(paraviewweb
  DEPENDS
    python
    paraviewwebglance
    paraviewweblite
    paraviewwebvisualizer
    paraviewwebdivvy
    pythonwslink
    pythonautobahn
    pythonconstantly
    pythonhyperlink
    pythonincremental
    pythonsetuptools
    pythonsix
    pythontwisted
    pythontxaio
    pythonwslink
    pythonzopeinterface
    ${paraviewweb_depends})
