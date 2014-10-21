find_package(Qt REQUIRED)

add_extra_cmake_args(
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE}
)
