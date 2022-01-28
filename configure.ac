#############################################################################
##
#W  configure.ac                                            Laurent Bartholdi
##
#Y Copyright (C) 2012-2016, Laurent Bartholdi
##
#############################################################################

AC_PREREQ([2.69])
LT_PREREQ([2.4.2])
AC_INIT([float],[0.5.18],[laurent.bartholdi@gmail.com])
AC_CONFIG_SRCDIR([src/float.c])
AC_CONFIG_AUX_DIR([build-aux])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([src/floatconfig.h:config.h.in])
AC_CANONICAL_TARGET
AM_INIT_AUTOMAKE([foreign])
LT_INIT([disable-static dlopen win32-dll])

AC_PREFIX_DEFAULT([${PWD}])

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX

# Checks for header files.
AC_CHECK_HEADERS([float.h stdlib.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE

# Locates GAP
FIND_GAP

LT_LIB_M
AC_CHECK_MPFR
if test "$MPFR" = yes; then
    AC_CHECK_MPFI
    AC_CHECK_MPC
    AC_CHECK_FPLLL
else
    AM_CONDITIONAL([WITH_MPFI_IS_YES],[false])
    AM_CONDITIONAL([WITH_MPC_IS_YES],[false])
    AM_CONDITIONAL([WITH_FPLLL_IS_YES],[false])
fi
AC_CHECK_CXSC

dnl ##
dnl ## Detect Windows resp. Cygwin
dnl ##
case $host_os in
  *cygwin* ) CYGWIN=yes;;
         * ) CYGWIN=no;;
esac
AM_CONDITIONAL([SYS_IS_CYGWIN], [test "$CYGWIN" = "yes"])

################################################################
# generate files

mkdir -p bin/$GAPARCH
mkdir -p extern

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
	])
AC_OUTPUT
