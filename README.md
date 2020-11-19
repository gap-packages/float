![CI](https://github.com/gap-packages/float/workflows/CI/badge.svg)
[![Build Status](https://travis-ci.org/gap-packages/float.svg?branch=master)](https://travis-ci.org/gap-packages/float)
[![Code Coverage](https://codecov.io/github/gap-packages/float/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/float)

# The Float package

This is the README file for the GAP package "Float"

This package implements floating-point numbers, with arbitrary precision,
based on the C libraries MPFR, MPFI, MPC and CXSC.

The package is distributed in source form, and does not require anything
else than a running GAP 4.7 or later. For updates, check the package
website at https://github.com/gap-packages/float/.
  
To use the package, your must first compile it; this is done by invoking
`./configure` and then `make` in the main directory (where this file is).
`./configure` may be invoked with arguments `--with-gaproot`, `--with-gaparch`
and `CONFIGNAME` to specify the location and variant of GAP installed.
By default, the configuration script searches `../..` and `/usr/local/src/gap`.

This package requires external libraries, at least one of mpfr, mpfi, mpc or
icxsc. If they were installed at standard locations, they will automatically be
found; otherwise, their location can be specified with `./configure' switches
`--with-mpfr=<location>', `--with-mpfi=<location>', `--with-mpc=<location>' and
`--with-cxsc=<location>', specifying at which prefix they are installed.
Alternatively, the include and library directories can be specified with
`--with-mpfr-include=<location>' and `--with-mpfr-lib=<location>', etc.

Most systems either come with these libraries, or supply a simple method of
installing them. For instance, on Ubuntu the command
`apt-get install libmpfr-dev libmpfi-dev libmpc-dev libfplll-dev'
and on a mac with Homebrew the commands
`brew tap brewsci/science; brew install mpfr mpfi libmpc brewsci/science/fplll'
should install the required libraries.

Once the package has been compiled, it may be used within GAP by typing

    LoadPackage("Float");

The "Float" package banner should appear on the screen.
New floating-point handlers may be then set by typing

    SetFloats(MPFR,1000);

to have 1000-bits floating-point numbers. For details on how to use the Float
package, please consult the documentation. It is in the `doc` subdirectory,
see `manual.pdf`.

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or any
later version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program, in the file COPYING.  If not, see
<http://www.gnu.org/licenses/>.

  Laurent Bartholdi, Göttingen, 6 January 2014
