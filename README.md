[![Build Status](https://github.com/gap-packages/float/workflows/CI/badge.svg?branch=master)](https://github.com/gap-packages/float/actions?query=workflow%3ACI+branch%3Amaster)
[![Code Coverage](https://codecov.io/github/gap-packages/float/coverage.svg?branch=master&token=)](https://codecov.io/gh/gap-packages/float)

# The Float package

This is the README file for the GAP package "Float"

This package implements floating-point numbers, with arbitrary precision,
based on the C libraries MPFR, MPFI, MPC, FPLLL and CXSC.

The package is distributed in source form, and does not require anything
else than a running GAP 4.7 or later. For updates, check the package
website at <https://github.com/gap-packages/float/>.
  
## Installation

To use the package, your must first compile it; this is done by invoking
`./configure` and then `make` in the main directory (where this file is).
`./configure` may be invoked with argument `--with-gaproot=<location>` to
specify the location where GAP is installed. The default is `../..`.

This package requires external libraries, at least one of mpfr, mpfi, mpc, fplll or
cxsc. If they were installed at standard locations, they will automatically be
found; otherwise, their location can be specified with these `./configure` switches:
- `--with-mpfr=<location>`
- `--with-mpfi=<location>`
- `--with-mpc=<location>`
- `--with-fplll=<location>`
- `--with-cxsc=<location>`

The include and library directories of the named library are then assumed to
be `<location>/include` resp. `<location>/lib` Alternatively, the include and
library directories can be specified with `--with-mpfr-include=<location>` and
`--with-mpfr-lib=<location>`, etc.

Most systems either come with these libraries, or supply a simple method for
installing them. For instance, on Ubuntu the command

    apt-get install libmpfr-dev libmpfi-dev libmpc-dev libfplll-dev

and on a mac with Homebrew the command

    brew install mpfr mpfi libmpc fplll

should install the specified four libraries.

## Usage

Once the package has been compiled, it may be used within GAP by typing

    LoadPackage("Float");

The "Float" package banner should appear on the screen.
New floating-point handlers may be then set by typing

    SetFloats(MPFR,1000);

to have 1000-bits floating-point numbers. For details on how to use the Float
package, please consult the documentation. It is in the `doc` subdirectory,
see `manual.pdf`.

## License

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
<https://www.gnu.org/licenses/>.
