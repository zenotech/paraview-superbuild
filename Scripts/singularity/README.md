# Introduction

The goal of this document is to describe how to build and run ParaView `Singularity` containers using the recipes in this directory.  These recipes have been tested with (and likely require) the latest stable version of `Singularity` available at the time of this writing, version `3.2`.  The documentation for this version is available [here](https://sylabs.io/guides/3.2/user-guide/).

The build recipes provided in this directory are very similar to those found in the `Scripts/docker/ubuntu/` directory, however there are some differences introduced as a result of some of the differences between `Singularity` and `Docker`.  One difference, noticeable immediately, is that `Singularity` does not allow for the provision of arguments or options at build time, perhaps for reasons of build reproducibility.  This results in extra work required to do any customization of the build, which is described in the first section.

## Building containers

To build a `Singularity` container using the recipes in this directory, you need to have `Singularity` installed.  The "Quick Start" section in the documentation linked above provides instructions for doing this.  Once it is properly installed, a build command looks like the following:

```
sudo /opt/singularity/bin/singularity build pv-release-egl.sif Singularity.egl
```

In the above command `pv-release-egl.sif` is the name you want to give the resulting container, and `Singularity.egl` is the name of the recipe file in the current directory.  To build an OSMesa version, use the `Singularity.osmesa` recipe:

```
sudo /opt/singularity/bin/singularity build pv-release-osmesa.sif Singularity.osmesa
```

### Customizing the build

The process of customizing the build is slightly more cumbersome with `Singularity` than it is with `Docker`.  Instead of specifying build arguments on the command line, the only way to change settings is to change values in your local working copy of one of the recipes (`Singularity.egl` or `Singularity.osmesa`).  The values that may be of interest to change can be found at the top of the `%post%` section of the recipes and include `RENDERING`, `PARAVIEW_TAG`, `SUPERBUILD_TAG`, `SUPERBUILD_REPO`, and `DEV_BUILD`.  The meanings of these options are the same as they are for the `Dockerfile`, which are described [here](/Scripts/docker/ubuntu/README.md).

Then just run the build commands as described in the section above.

## Container applications

`Singularity` gives us the ability to describe `apps` within the recipe which behave like documentable shortcuts to functionality in the container.  The apps we have built into the containers include `pvpython`, `pvbatch`, and `pvserver`, as well as the web applications which get built with the superbuild (`visualizer`, `lite`, `divvy`, and `flow`).

### Running the applications

To run one of the applications, the command has the form:

```
singularity run [--nv] --app <app-name> <container-name> [app-arguments]
```

The option `--nv` is needed when running a container where ParaView was built with `EGL` support. For example to run `pvpython` on a script you have in your current directory, you could just type (e.g.):

```
singularity run --nv --app pvpython pv-release-egl.sif testPythonScript.py
```

### Getting help on applications

To get help on one of the applications built into a container, type (e.g.):

```
singularity run-help --app visualizer pv-v5.6.1-egl.sif
```

Which will print the following help text:

```
    Run the ParaViewWeb Visualizer server.  The server python script (`pvw-visualizer.py`)
    as well as the `--content` arguments are already provided for you, but you may still
    want to provide other arguments such as `--data <path-to-data-dir>` (note that you
    must bind-mount that path when running singularity for the image to see it), or
    `--port <port-number>`.

    Example:

        $ singularity run --nv \
            --bind /<path-to-data-dir>:/data \
            --app visualizer \
            pv-release-egl.sif --data /data --port 9091
```

### Running a shell

To run a shell in the container, type (e.g.):

```
singularity shell pv-release-osmesa.sif
```

This will put you in a shell running within the specified container, which in this case will be expected in the current working directory.  By default, `Singularity` bind mounts the current working directory, so if you write files there, you'll see them when you leave the container.  Here's a small snippet to demonstrate:

```
$ ls -l | grep pv-release-osmesa
-rwxr-xr-x  1 me me 459804672 Jun 10 18:43 pv-release-osmesa.sif
$ singularity shell pv-release-osmesa.sif
Singularity pv-release-osmesa.sif:/home/me/some/directory> /opt/paraview/bin/pvpython
Python 2.7.15rc1 (default, Apr 15 2018, 21:51:34)
[GCC 7.3.0] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> from paraview.simple import *
>>> coneSrc = Cone()
>>> coneRepr = Show(coneSrc)
>>> coneView = Render()
>>> WriteImage('osmesacone.png')
>>> <Ctrl-D>
Singularity pv-release-osmesa.sif:/home/me/some/directory> exit
exit
$ ls -l | grep osmesacone
-rw-r--r--  1 me me      3896 Jun 19 16:01 osmesacone.png
```
