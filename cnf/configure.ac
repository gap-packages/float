#############################################################################
##
#W  configure.ac                                            Laurent Bartholdi
##
#Y Copyright (C) 2012, Laurent Bartholdi
##
#############################################################################

AC_PREREQ(2.68)
LT_PREREQ([2.4.2])
AC_INIT(img,,laurent.bartholdi@gmail.com)
AC_CONFIG_SRCDIR([src/img_dll.c])
AC_CONFIG_AUX_DIR([cnf])
AC_CONFIG_MACRO_DIR([cnf/m4])
AC_CONFIG_HEADERS([src/config.h:cnf/config.h.in])
LT_INIT([disable-static dlopen win32-dll])

AC_PREFIX_DEFAULT([${PWD}])

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_JAVAC
AC_CANONICAL_TARGET
AX_CC_MAXOPT

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([float.h stdlib.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_C_INLINE

# Locates GAP
AC_FIND_GAP
AC_FILD_GAP_GMP

AC_SYS_IS_CYGWIN
AC_SYS_IS_DARWIN

# External libraries configuration
EXTERN="\$(CURDIR)/bin/$TARGET/extern"
MAKE_LIBTARGETS=""

AC_CHECK_MPFR
AC_CHECK_MPFI
AC_CHECK_MPC
AC_CHECK_CXSC
AC_CHECK_FPLLL

################################################################
# generate files

mkdir -p bin/$GAPARCH
CONFIG_STATUS=bin/$GAPARCH/config.status

AC_CONFIG_FILES([$GAP_MAKEFILE:cnf/Makefile.in])

if test "$GAP_MAKEFILE" != Makefile; then
    ln -sf "$GAP_MAKEFILE" Makefile
fi

AC_OUTPUT

# LEFTOVERS...

echo using MPFR directory... $MPFRDIR
echo using MPFI directory... $MPFIDIR
echo using MPC directory... $MPCDIR
echo using FPLLL directory... $FPLLLDIR
echo using CXSC directory... $CXSCDIR

WITHGMP=""
INCLGMP=""
LINKGMP=""
if test "$GMPINCLUDE" != ""; then
   WITHGMP="$WITHGMP --with-gmp-include=$GMPINCLUDE"
   INCLGMP="$GMP_CFLAGS"
fi
if test "$GMPLIB" != ""; then
   WITHGMP="$WITHGMP --with-gmp-lib=$GMPLIB"
   LINKGMP="-L$GMPLIB"
fi
WITHMPFR=""
INCLMPFR=""
LINKMPFR=""
if test "$MPFRINCLUDE" != ""; then
   WITHMPFR="$WITHMPFR --with-mpfr-include=$MPFRINCLUDE"
   INCLMPFR="-I$MPFRINCLUDE"
fi
if test "$MPFRLIB" != ""; then
   WITHMPFR="$WITHMPFR --with-mpfr-lib=$MPFRLIB"
   LINKMPFR="-L$MPFRLIB"
fi

# prevent parallel make on mpfr, mpc, mpfi before mpfr is compiled
if test "$MPFRDIR" = extern; then MPFRDEPEND=mpfrlib; fi

if test "$MPFRDIR" = extern -o "$MPFIDIR" = extern -o "$MPCDIR" = extern -o "$FPLLLDIR" = extern; then
    GACFLAGS="$GACFLAGS -p -I$EXTERN/include"
    MP_FLOAT_LIB="$MP_FLOAT_LIB -L -L$EXTERN/lib -L -Wl,-rpath,$EXTERN/lib"
fi

if test "$CXSCDIR" = extern; then
    GACFLAGS="$GACFLAGS -p -I$EXTERN/include"
    CXSC_FLOAT_LIB="$CXSC_FLOAT_LIB -L -L$EXTERN/lib -L -Wl,-rpath,$EXTERN/lib"
fi
