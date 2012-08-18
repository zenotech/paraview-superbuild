

# set extra cpack variables before calling paraview.bundle.common
set (CPACK_GENERATOR DragNDrop)

# include some common stub.
include(paraview.bundle.common)


# now fixup each of the applications.
# we only to paraview explicitly.
install(CODE
  "include(BundleUtilities)
   fixup_bundle(\"${install_location}/Applications/paraview.app\" \"\" \"${install_location}/lib\")
   file(INSTALL DESTINATION \"\${CMAKE_INSTALL_PREFIX}\" TYPE DIRECTORY FILES
                \"${install_location}/Applications/paraview.app\")
   "
   COMPONENT superbuild)
