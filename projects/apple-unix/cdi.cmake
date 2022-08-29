# netcdf required, either system or installed
set(cdi_netcdf_args "--with-netcdf=<INSTALL_DIR>")
if (USE_SYSTEM_netcdf)
    set(cdi_netcdf_args "--with-netcdf=yes")
endif ()

superbuild_add_project(cdi
  CAN_USE_SYSTEM
  LICENSE_FILES
  LICENSE
    DEPENDS netcdf
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
    --prefix=<INSTALL_DIR>
    ${cdi_netcdf_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install
  BUILD_IN_SOURCE 1)
