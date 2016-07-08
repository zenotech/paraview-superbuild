file(INSTALL
  ${source_dir}/dist/
  DESTINATION "${install_directory}/share/paraview/www/visualizer")
file(INSTALL
  ${source_dir}/server/pvw-visualizer.py
  DESTINATION "${install_directory}/bin")
