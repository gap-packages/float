# check for mpfi library
# sets MPFI_CPPFLAGS, MPFI_LDFLAGS and MPFI_LIBS,
# and MPFI_WITH, MPFI_DEPEND,
# and MPFI=yes/no

AC_DEFUN([AC_CHECK_MPFI],[
temp_LIBS="$LIBS"
temp_CPPFLAGS="$CPPFLAGS"
temp_LDFLAGS="$LDFLAGS"
MPFI=unknown
MPFI_WITH=""
MPFI_DEPEND=""

AC_ARG_WITH(mpfi,
 [  --with-mpfi=<location>
    Location at which the MPFI library was installed.
    If the argument is omitted, the library is assumed to be reachable
    under the standard search path (/usr, /usr/local,...).  Otherwise
    you must give the <path> to the directory which contains the
    library.],
 [if test "$withval" = no; then
    MPFI=no
  elif test "$withval" = yes; then
    MPFI=yes
  else
    MPFI_WITH="$MPFI_WITH --with-mpfi=$withval"
    MPFI=yes
    MPFI_CPPFLAGS="-I$withval/include"; MPFI_LDFLAGS="-L$withval/lib"
  fi]
)

AC_ARG_WITH(mpfi-include,
 [  --with-mpfi-include=<location>
    Location at which the mpfi include files were installed.],
 [MPFI=yes
  MPFI_WITH="$MPFI_WITH --with-mpfi-include=$withval"
  MPFI_CPPFLAGS="-I$withval"]
)

AC_ARG_WITH(mpfi-lib,
 [  --with-mpfi-lib=<location>
    Location at which the mpfi library files were installed.
 ],
 [MPFI=yes
  MPFI_WITH="$MPFI_WITH --with-mpfi-lib=$withval"
  MPFI_LDFLAGS="-L$withval"]
)

if test "$MPFI" != no; then

if test "$MPFR" = no; then
    AC_MSG_ERROR([Cannot have MPFI without having MPFR too.])
fi

MPFI_LIBS="-lmpfi"

AC_LANG_PUSH([C])
temp_status=true
CPPFLAGS="$CPPFLAGS $MPFI_CPPFLAGS $MPFR_CPPFLAGS"
AC_CHECK_HEADER(mpfi.h,,[temp_status=false],[#include <mpfr.h>])
LDFLAGS="$LDFLAGS $MPFI_LDFLAGS $MPFR_LDFLAGS"
AC_CHECK_LIB(mpfi,mpfi_sqrt,,[temp_status=false])
AC_LANG_POP([C])

if test "$temp_status" = false; then
    if test "$MPFI" = yes; then
        AC_MSG_ERROR([library mpfi not found. Using --with-mpfi, specify its location, or "no" to disable it.])
    else
        MPFI=no
    fi
else
    MPFI=yes
fi

fi

CPPFLAGS="$temp_CPPFLAGS"
LDFLAGS="$temp_LDFLAGS"
LIBS="$temp_LIBS"

if test "$MPFI" != no; then
    AC_DEFINE([USE_MPFI],1,[use MPFI library])
fi
AC_SUBST(MPFI_CPPFLAGS)
AC_SUBST(MPFI_LDFLAGS)
AC_SUBST(MPFI_LIBS)
AM_CONDITIONAL([WITH_MPFI_IS_YES],[test x"$MPFI" != xno])
])
