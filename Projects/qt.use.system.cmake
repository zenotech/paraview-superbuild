find_package(Qt5 REQUIRED
  COMPONENTS
    Core)

add_external_dummy_project(qt)

add_extra_cmake_args(
  -DPARAVIEW_QT_VERSION:STRING=5
  -DQt5_DIR:PATH=${Qt5_DIR}
)
