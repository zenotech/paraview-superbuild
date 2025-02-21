superbuild_add_project(openturns
  DEPENDS lapack
  DEPENDS_OPTIONAL tbb
  LICENSE_FILES
    LICENSE
    COPYING
    COPYING.LESSER
    COPYING.cephes
    COPYING.cobyla
    COPYING.dsfmt
    COPYING.ev3
    COPYING.exprtk
    COPYING.faddeeva
    COPYING.kendall
    COPYING.kissfft
    COPYING.tnc
  SPDX_LICENSE_IDENTIFIER
    LGPL-3.0-or-later AND MIT AND BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright 2005-2024 Airbus-EDF-IMACS-ONERA-Phimeca"
    "Copyright (C) 2007 Takashi Takekawa."
    "Copyright (c) 2003-2010 Mark Borgerding"
    "Copyright (c) 1999-2023 Arash Partow"
    "Copyright (c) 1992, Michael J. D. Powell"
    "Copyright (c) 2004, Jean-Sebastien Roy"
    "Copyright (C) 2010 David Simcha"
    "Copyright (c) 2012 Massachusetts Institute of Technology"
    "Copyright 1984, 1995, 2000 by Stephen L. Moshier"
    "Copyright (C) 2008-2010 Leo Liberti"
    "Copyright (c) 2002-2005, Jean-Sebastien Roy"
  CMAKE_ARGS
    -DBUILD_PYTHON=OFF
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DBUILD_TESTING=OFF
    -DUSE_BISON=OFF
    -DUSE_BONMIN=OFF
    -DUSE_BOOST=OFF
    -DUSE_CERES=OFF
    -DUSE_CMINPACK=OFF
    -DUSE_CUBA=OFF
    -DUSE_CXX17=OFF
    -DUSE_DLIB=OFF
    -DUSE_DOXYGEN=OFF
    -DUSE_FLEX=OFF
    -DUSE_HDF5=OFF
    -DUSE_IPOPT=OFF
    -DUSE_LIBXML2=OFF
    -DUSE_MPC=OFF
    -DUSE_MPFR=OFF
    -DUSE_MUPARSER=OFF
    -DUSE_NANOFLANN=OFF
    -DUSE_NLOPT=OFF
    -DUSE_OPENBLAS=OFF
    -DUSE_OPENMP=OFF
    -DUSE_PAGMO=OFF
    -DUSE_PRIMESIEVE=OFF
    -DUSE_SPECTRA=OFF
)
