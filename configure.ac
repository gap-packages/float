#############################################################################
##
#W  configure.ac                                            Laurent Bartholdi
##
#Y Copyright (C) 2012-2014, Laurent Bartholdi
##
#############################################################################

AC_PREREQ(2.65)
LT_PREREQ([2.4.2])
AC_INIT([float],[0.5.18],[laurent.bartholdi@gmail.com])
AC_CONFIG_SRCDIR([src/float.c])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADER([src/floatconfig.h:config.h.in])
AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE
LT_INIT([disable-static dlopen win32-dll])

AC_PREFIX_DEFAULT([${PWD}])

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AX_CC_MAXOPT

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([float.h stdlib.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE

# Locates GAP
AC_FIND_GAP
GMP_CFLAGS="$GAP_CPPFLAGS"
GMP_LDFLAGS="-L$GMP_ROOT/lib" # not very good, maybe the libraries are not there

AC_SYS_IS_CYGWIN
AC_SYS_IS_DARWIN

# External libraries configuration
EXTERN="\$(CURDIR)/bin/$TARGET/extern"
MAKE_LIBTARGETS=""

LT_LIB_M
AC_CHECK_MPFR
AC_CHECK_MPFI
AC_CHECK_MPC
AC_CHECK_CXSC
AC_CHECK_FPLLL

################################################################
# generate files

mkdir -p bin/$GAPARCH
##mkdir -p extern
##CONFIG_STATUS=bin/$GAPARCH/config.status
##
##AC_CONFIG_FILES([$GAP_MAKEFILE:Makefile.in])
##
##if test "$GAP_MAKEFILE" != Makefile; then
##    ln -sf "$GAP_MAKEFILE" Makefile
##fi

AC_CONFIG_FILES([
	Makefile
	src/Makefile
	doc/Makefile
	])
AC_OUTPUT
