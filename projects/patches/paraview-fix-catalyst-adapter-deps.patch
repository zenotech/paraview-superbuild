commit 561f6f534804a9b088b293feb847857c7c551b5a
Author: Robert Maynard <robert.maynard@kitware.com>
Date:   Tue Nov 20 16:53:14 2018 -0500

    ParaView propagates CMAKE_PREFIX_PATH to Catalyst Adaptors.

    Fixes #18224
    ParaView uses add_custom_command to build all the catalyst adaptors.
    This means that any package find calls that occur when including
    ParaView's Config Module need to be part of the search path for
    the adaptor.

    The easiest way is to make sure that CMAKE_PREFIX_PATH is propagated
    through add_custom_command as it is the most common way of specifying
    where to search.

    Note: That as more projects move over to import targets this approach
    will continue to fail especially if they specify the search directories
    using `<Package>_ROOT`. Long term the catalyst adaptors will need to
    become an external project or stop using add_custom_command.

diff --git a/CoProcessing/Adaptors/BuildAdaptors.cmake b/CoProcessing/Adaptors/BuildAdaptors.cmake
index 82ddbe95af..9291893398 100644
--- a/CoProcessing/Adaptors/BuildAdaptors.cmake
+++ b/CoProcessing/Adaptors/BuildAdaptors.cmake
@@ -70,6 +70,7 @@ function(build_adaptor name languages)
                             -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
                             -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
                             -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
+                            -DCMAKE_PREFIX_PATH:STRING=${CMAKE_PREFIX_PATH}
                             ${language_options}
                             ${extra_params}
                             --no-warn-unused-cli
