# This is a config file for building ParaView on a Knights Landing
# development platform at Kitware.  The machine runs
# CentOS 7 with compilers and modules from OpebnHPC.  The following
# modules are to be loaded before building:
#
# intel impi boost hdf5 numpy
#
# substitute intel and impi with compiler and MPI modules of choice.

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
include(Kitware-Camelot-Common)

set(ENABLE_osmesa ON CACHE BOOL "")
