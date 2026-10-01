This file describes changes in the float package.

## 1.0.10 (2026-05-27)

- Declare the needed system packages (MPC, MPFI, MPFR) in `PackageInfo.g`
  (#102)

## 1.0.9 (2025-08-26)

- Fix compilation with C-XSC by disambiguating the type name `complex` (#101)

## 1.0.8 (2025-08-25)

- Fix compilation with C23 compilers (#99)
- Let `configure` fail on a dependency missing from Homebrew only if it was
  requested explicitly, e.g. via `--with-mpfi` (#100)

## 1.0.7 (2025-03-10)

- Detect MPFR, MPFI, MPC and fplll installed via Homebrew (#98)
- Fix a compilation error in the fplll code caused by a clash with `std::set`

## 1.0.6 (2025-03-09)

- Fix `AvailabilityTest` returning `fail` instead of `false` when the kernel
  extension is missing

## 1.0.5 (2024-08-30)

- Require GAP >= 4.12
- Use GAP's kernel extension API to check for and load the compiled module,
  and raise an error if loading it fails (#94)
- Remove use of the deprecated `set_unexpected` (#92)

## 1.0.4 (2024-01-11)

- Fix compilation against fplll versions whose `fplll.h` no longer opens the
  `fplll` namespace (#84)
- Use explicit conversions when calling `cxsc::pow()` (#81)
- Locate the GAP executable via `sysinfo.gap` when building (#89)
- Prefer the MathJax version of the HTML manual, and update links in the
  manual (#87, #88)

## 1.0.3 (2022-02-15)

- Fix building on Cygwin (#79)

## 1.0.2 (2021-12-13)

- Fix compiler errors and warnings with C-XSC support (#75)
- Stop compiling with `AX_CC_MAXOPT` optimization flags (#76)

## 1.0.1 (2021-11-26)

- Fix potential crashes after garbage collection in `EXTREPOFOBJ_MPFR` and in
  MPC string conversion (#70, #72)
- Fix how compiler and linker flags of MPFR, MPFI, MPC, fplll and C-XSC are
  passed (#65)
- Stop defining `FPLLL_VERSION`, which clashes with `fplll.h` (#71)

## 1.0.0 (2021-11-23)

- Require GAP >= 4.11
- Shorten the package banner, now printed via `BannerFunction` (#58)

## 0.9.9 (2021-10-17)

- Add `Ceil`, `Floor`, `Round`, `Trunc` and `Frac` for MPFI floats, and
  document `FLOAT_PSEUDOFIELD`
- Fix `Argument` returning zero for MPC floats (#43)
- Raise an error instead of offering to return a replacement value for
  invalid arguments to kernel functions (#50)
- Make the build system compatible with autoconf >= 2.70 (#56)
- Clarify that the license is GPL 2 or later (#46)

## 0.9.1 (2018-06-14)

## 0.9.0 (2017-12-14)

## 0.8.0 (2017-11-03)

## 0.7.6 (2017-05-09)

## 0.7.5 (2017-02-18)

## 0.7.4 (2016-06-18)

## 0.7.3 (2016-05-11)

## 0.7.2 (2016-04-21)

## 0.7.1 (2016-03-03)

## 0.7.0 (2016-03-03)

## 0.6.3 (2014-09-03)

## 0.6.2 (2014-08-29)

## 0.6.1 (2014-06-21)

## 0.6.0 (2014-06-21)

## 0.5.18 (2014-01-27)

## 0.5.17 (2014-01-06)

## 0.5.16 (2014-01-03)

## 0.5.15 (2014-01-02)

## 0.5.14 (2014-01-01)

## 0.5.13 (2013-12-01)

## 0.5.12 (2013-11-18)

## 0.5.11 (2013-09-06)

## 0.5.10 (2013-05-16)

## 0.5.9 (2013-03-17)

## 0.5.8 (2013-03-07)

## 0.5.7 (2013-03-06)

## 0.5.6 (2013-03-05)

## 0.5.5 (2012-12-13)

## 0.5.4 (2012-12-12)

## 0.5.3 (2012-12-11)

## 0.5.2 (2012-11-27)

## 0.5.1 (2012-11-27)

## 0.5.0 (2012-11-19)

## 0.4.6 (2012-05-05)
