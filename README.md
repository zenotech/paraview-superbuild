![ParaView-Superbuild](Documentation/img/paraview100.png)

# Introduction

ParaView-Superbuild, henceforth referred to as "superbuild", is a project to
build ParaView and its dependencies. ParaView itself can be easily built using
CMake as long as the required external dependencies are available on the build
machine. However, ParaView's several external dependencies, e.g. Qt, CGNS,
FFMPEG, etc. can be very tedious to build. Also, if you want to generate
redistributable binaries, you need to take extra care when building and
packaging these dependencies. To make our lives easier in supporting both these
use-cases, the superbuild project was born.

Although primarily designed to build the official ParaView binaries, the
superbuild has since been regularly used to build and install ParaView
on various supercomputing systems.

# Obtaining the source

To obtain the superbuild source locally, clone this repository using
[Git](https://git-scm.org).

    $ git clone --recursive https://gitlab.kitware.com/paraview/paraview-superbuild.git

# Building

The superbuild can be built with a Makefiles or Ninja CMake generator. The IDE
generators (Xcode and Visual Studio) are not supported.

## Building a specific version

The superbuild project uses the same versioning scheme as ParaView,
and gets tagged for every release of ParaView.  For example, to build
ParaView version 5.2.0, checkout the `v5.2.0` tag of ParaView and
superbuild.

Currently available tags are shown
[here](https://gitlab.kitware.com/paraview/paraview-superbuild/tags).

To checkout a specific tag from the superbuild git repository:

    $ cd paraview-superbuild
    $ git fetch origin # ensure you have the latest state from the main repo
    $ git checkout v5.2.0 # replace `v5.2.0` with tag name of your choice
    $ git submodule update

At this point, your superbuild has all of the *rules* that were used
when building the selected version of ParaView. Also, note that it's
possible to build a version of ParaView using a different superbuild
version.  For example, you could use superbuild `v5.2.0`, to build the
latest master (i.e., development) version of ParaView, or a custom
branch.  This is done by first checking out the superbuild for the
appropriate version and then setting the CMake variables that affect
which ParaView source is to be used.  There are several ways to
control how superbuild finds its source packages:

 1. If you want to use git to checkout ParaView source (default), then set
    `paraview_SOURCE_SELECTION` to `git`, ensure `paraview_GIT_REPOSITORY` is
    pointing to the ParaView git repository you want to clone (by default it is
    set to the offical ParaView repository) and then set the `paraview_GIT_TAG`
    to be a specific tagname or branch available for the selected git
    repository. Use `master` for latest development code, `v5.2.0` for the
    5.2.0 release, `release` for latest stable release, or a specific ParaView
    commit SHA. In this setup, when building the superbuild, it will clone and
    checkout the appropriate revision from the ParaView git repository automatically.
 2. Instead of letting superbuild do the cloning and updating of the ParaView
    source, you can also manually check it out and keep it updated as needed.
    To use this configuration, set `paraview_SOURCE_SELECTION` to `source`, and
    set `paraview_SOURCE_DIR` to point to a custom ParaView source tree. See 'offline
    builds' below for instructions to download needed dependency packages.
 3. Another option is to use a source tarball of a ParaView release. For that,
    set `paraview_SOURCE_SELECTION` to the version to build such as `5.2.0`.
    The superbuild offers the lastest stable release as well as release
    candidate in preparation for the release. This is the best way to build a
    released version of ParaView.

**NOTE:** If you switch to a superbuild version older than 5.2, the instructions
described on this page are not relevant since the superbuild was refactored and
changed considerably for 5.2. For older versions, refer to instructions on the
[Wiki](http://www.paraview.org/Wiki/index.php?title=ParaView/Superbuild&oldid=59804).

**ALSO NOTE:** Since this README is expected to be updated for each version,
once you checkout a specfic version, you may want to refer to the README for
that specific version.

## Projects and Features

The superbuild contains multiple projects which may be used to enable
different features within the resulting ParaView build. Most projects involve
downloading and adding the feature to the resulting package, but there are a
few which are used just to enable features within ParaView itself.

The `catalyst` and `paraview` projects are mutually exclusive (the libraries
conflict in the install tree). One of these two projects must be enabled.
The `catalyst` package is only available on Linux.

The `paraviewsdk` project enables the building of a package which includes
headers and libraries suitable for developing against ParaView. It is only available
on Linux (at the moment).

The `paraviewweb` project adds web services into the resulting package.

The `paraviewgettingstartedguide`, `paraviewtutorial`, `paraviewtutorialdata`,
and `paraviewusersguide` packages add documentation to the package.

ParaView supports multiple rendering engines including `egl`, `mesa`,
`osmesa`, and `qt4`. All of these are incompatible with each other. In
addition, the `egl` renderer requires the `OpenGL2` rendering backend. If none
of these are chosen, a UI-less ParaView will be built (basically just
`pvpython`). `qt5` is also available, but is not known to be ready. On Windows
and macOS, only the `qt` packages are available.

The `python` package is available to enable Python support in the package. In
addition, the `matplotlib` and `numpy` packages are available.

The following packages enable other features within ParaView:

  * `adios`: Enable readers and writers for visualization data in the ADIOS
    file format.
  * `boxlib`: Enable reading the boxlib3D file format.
  * `cosmotools`: Enables Cosmo file format readers and related filters and
    algorithms.
  * `ffmpeg`: Video encoding library for macOS and Linux.
  * `ospray`: A ray tracing rendering backend from Intel.
  * `silo`: Support reading the silo file format.
  * `tbb`: Improved parallel processing support within various VTK and
    ParaView filters and algorithms.
  * `visitbridge`: Enables readers for file formats provided from the VisIt
    project.
  * `vortexfinder2`: A collection of tools to visualize and analyze vortices.
  * `vrpn`: Virtual reality support.
  * 'vtkm': VTK-m Accelerator Filters
  * `xdmf3`: A meta file format built on top of HDF5.

## Offline builds

The superbuild has a `download-all` target that will download all of
the files from the network that are necessary for the currently
configured build. By default, they are placed into the `downloads`
directory of the build tree.  This superbuild-plus-downloads tree may
then be copied to a non-networked machine and pointed at using the
`superbuild_download_location` variable (or placed in the default
location).

## Installing

The superbuild supports the `install` target by selecting a template package
using the `SUPERBUILD_DEFAULT_INSTALL` variable. The default and availability
depends on the platform and selected projects, but valid values for this
include:

  * `paraview/ZIP`
  * `paraview/DragNDrop`
  * `paraview/TGZ`
  * `catalyst/TGZ`
  * `paraviewsdk/TGZ`

The CMake cache editors (`ccmake` and `cmake-gui`) have dropdown options for
the supported options.

The selected package logic will be used to install ParaView and its
dependencies into `CMAKE_INSTALL_PREFIX` rather than being placed into a
package. For example, the `DragNDrop` generator creates `.app` bundles which
will be created whereas the `TGZ` and `ZIP` generators use the standard
`bin/`, `lib/`, etc. directories.

### Caveats

If using the `git` source selection for ParaView, the build will rerun when
using the `install` target due to limitations in the external project
mechanisms and the way CPack works. There are two ways to avoid this:

  * the `SUPERBUILD_OFFLINE_BUILD` option may be set to `ON` to unlink the git
    update step from the configure/build steps; or
  * the initial build can just be run using the `install` target instead of
    the usual `make && make install` pattern.

## External plugins

The superbuild supports building more plugins into ParaView using the
`paraviewexternalplugins` project. As an example, to build two external
plugins `a` and `b`, the following settings should be used:

  * `ENABLE_paraviewexternalplugins:BOOL=ON`: Enables building using external
    plugins.
  * `paraview_PLUGINS_EXTERNAL:STRING=a;b`: The list of plugins to build.
  * `paraview_PLUGIN_a_PATH:PATH=/path/to/plugin/a`: The path to plugin `a`'s
    source directory. It must contain a `plugins.cmake` to be picked up by
    ParaView.
  * `paraview_PLUGIN_b_PATH:PATH=/path/to/plugin/b`: Same as above, but for
    plugin `b`.

## CMake Variables

### Style Guide

Note that currently not all project and configuration variables follow this
style guide but any new projects should use this convention while any
existing projects and configuration variables will transition to this over
time.

  * All references to a given project name will be lowercase.
  * Underscores will be used as word seperators in variable names.
  * All project specific configuration variables will be lower-case project
    name followed by upper-case setting name.
    Examples include:
      * `mesa_USE_SWR` : Enable the OpenSWR driver for (OS)Mesa.
      * `ospray_BUILD_ISA` : Select the SIMD architecture used to build OSPray.
  * Internal variables used within a given project's projectname.cmake file
    will be all lower-case.
  * Multiple versions:
      * Use the `superbuild_set_selectable_source` macro to allow multiple
        versions of a given project.
      * Specify source selection versions as numeric, i.e. without any "v" or
        "V" prefix.
      * If the project is going through a release candidate cycle, add the
        available RCs as additional sources as they become availabe.  Once
        a final release is made, replace all the RCs with the updated release.

### Build Variables

  * `superbuild_download_location` (default `${CMAKE_BINARY_DIR}/downloads`):
    The location to store downloaded source artifacts. Usually, it is changed
    so that it is preserved across a wipe of the build directory.
  * `SUPERBUILD_PROJECT_PARALLELISM` (default based on the number of available
    processors): When using a Makefiles generator, subproject builds use `-j`
    explicitly with this number.
  * `ENABLE_xxx` (generally, default `OFF`): If selected, the `xxx` project
    will be built within the superbuild. See above for descriptions of the
    various projects. `ENABLE_` flags are not shown for projects which must be
    enabled due to a project depending on it (e.g., `qt4` requires `png`, so
    enabling `qt4` will hide the `ENABLE_png` option).
  * `USE_SYSTEM_xxx` (default `OFF`): If selected, the `xxx` project from the
    build environment is used instead of building it within the superbuild.
    Not all projects support system copies (the flag is not available if so).

The following flags affect ParaView directly:

  * `paraview_SOURCE_SELECTION` (default `5.2.0`): The source to use for
    ParaView itself. The version numbers use the source tarballs from the
    website for the release. The `source` selection uses the
    `paraview_SOURCE_DIR` variable to look at a checked out ParaView source
    directory. The `git` selection has the superbuild clone and builds a
    checkout of ParaView from git repository controlled by the
    `paraview_GIT_REPOSITORY` and `paraview_GIT_TAG` variables. By default, the
    `master` branch of the main repository is used.

    **Note**: When using the `source` selection, incremental builds to the
    superbuild may not rebuild ParaView even if the source tree has changed.
    This is because the superbuild is "blind" to the source tree other than
    its existence.
  * `CMAKE_BUILD_TYPE_paraview` (default is the same as the superbuild):
    ParaView may be built with a different build type (e.g., `Release` vs.
    `RelWithDebInfo`) as the rest of the superbuild using this variable.
  * `PARAVIEW_RENDERING_BACKEND` (default `OpenGL2`): The rendering backend to
    use with ParaView.
  * `PARAVIEW_BUILD_WEB_DOCUMENTATION` (default `OFF`): Have ParaView build
    its HTML documentation.
  * `mesa_USE_SWR` (default `ON`): If `mesa` is enabled, this enables
    Intel's software rasterization backend (x86 only).

The following flags affect Catalyst:

  * `PARAVIEW_CATALYST_EDITION` (default `Essentials`): The edition of
    Catalyst to build (also available: `Extras` and `Rendering-Base`).
  * `PARAVIEW_CATALYST_PYTHON` (default `ON`): Enable Python support in
    Catalyst.

### Packaging Variables

  * `PARAVIEW_PACKAGE_SUFFIX` (default based on selected options): The suffix
    for the name generated by the package.
  * `paraview_PLUGINS_AUTOLOAD`: List of plugins to autoload in the packaged
    ParaView.

# Packaging

The packages may be built using the `cpack-paraview` tests via `ctest`. The
easiest way to build all available packages is to run `ctest -R cpack`.

# Learning Resources

* General information is available at the [ParaView Homepage][].

* Community discussion takes place on the [ParaView Mailing Lists][].

* Commercial [support][Kitware Support] and [training][Kitware Training]
  are available from [Kitware][].

[ParaView Homepage]: http://www.paraview.org
[ParaView Mailing Lists]: http://www.paraview.org/mailing-lists/
[Kitware]: http://www.kitware.com/
[Kitware Support]: http://www.kitware.com/products/support.html
[Kitware Training]: http://www.kitware.com/products/protraining.php

# Reporting Bugs

If you have found a bug:

1. If you have a patch, please read the [CONTRIBUTING.md][] document.

2. Otherwise, please join one of the [ParaView Mailing Lists][] and ask
   about the expected and observed behaviors to determine if it is
   really a bug.

3. Finally, if the issue is not resolved by the above steps, open
   an entry in the [ParaView Issue Tracker][].

[ParaView Issue Tracker]: http://www.paraview.org/Bug

# License

Like ParaView, ParaView-Superbuild is distributed under the OSI-approved BSD
3-clause License. See [Copyright.txt][] for details. For additional licenses,
refer to [ParaView Licenses][].

[Copyright.txt]: Copyright.txt
[ParaView Licenses]: http://www.paraview.org/paraview-license/

# Contributing

See [CONTRIBUTING.md][] for instructions to contribute.

[CONTRIBUTING.md]: CONTRIBUTING.md
