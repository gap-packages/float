# check for mpfr library
# sets MPFR_CPPFLAGS, MPFR_LDFLAGS and MPFR_LIBS,
# and MPFR=yes/no

AC_DEFUN([AC_CHECK_MPFR],[
temp_LIBS="$LIBS"
temp_CPPFLAGS="$CPPFLAGS"
temp_LDFLAGS="$LDFLAGS"
MPFR=unknown

AC_ARG_WITH([mpfr],
 [AS_HELP_STRING([--with-mpfr=<location>],
   [Location at which the MPFR library was installed.
    If the argument is omitted, the library is assumed to be reachable
    under the standard search path (/usr, /usr/local,...).  Otherwise
    you must give the <path> to the directory which contains the
    library.])],
 [if test "$withval" = no; then
    MPFR=no
  elif test "$withval" = yes; then
    MPFR=yes
  else
    MPFR=yes
    MPFR_CPPFLAGS="-I$withval/include"
    MPFR_LDFLAGS="-L$withval/lib"
  fi],
  [AS_IF([command -v brew --prefix mpfr >/dev/null 2>&1],[
    AC_MSG_NOTICE([BREW mpfr detected])
    withval=$(brew --prefix)
    MPFR=yes
    MPFR_CPPFLAGS="-I$withval/include"
    MPFR_LDFLAGS="-L$withval/lib"
  ])]
)

AC_ARG_WITH([mpfr-include],
 [AS_HELP_STRING([--with-mpfr-include=<location>],
   [Location at which the mpfr include files were installed.])],
 [MPFR=yes
  MPFR_CPPFLAGS="-I$withval"]
)

AC_ARG_WITH([mpfr-lib],
 [AS_HELP_STRING([--with-mpfr-lib=<location>],
   [Location at which the mpfr library files were installed.])],
 [MPFR=yes
  MPFR_LDFLAGS="-L$withval"]
)

if test "$MPFR" != no; then

MPFR_LIBS="-lmpfr"

AC_LANG_PUSH([C])
temp_status=true
CPPFLAGS="$CPPFLAGS $MPFR_CPPFLAGS"
AC_CHECK_HEADER(mpfr.h,,[temp_status=false])
LDFLAGS="$LDFLAGS $MPFR_LDFLAGS"
AC_CHECK_LIB(mpfr,mpfr_sqrt,,[temp_status=false])
AC_LANG_POP([C])

if test "$temp_status" = false; then
    if test "$MPFR" = yes; then
        AC_MSG_ERROR([library mpfr not found. Using --with-mpfr, specify its location, or "no" to disable it.])
    else
        MPFR=no
    fi
else
    MPFR=yes
fi

fi

CPPFLAGS="$temp_CPPFLAGS"
LDFLAGS="$temp_LDFLAGS"
LIBS="$temp_LIBS"

if test "$MPFR" != no; then
    AC_DEFINE([USE_MPFR],1,[use MPFR library])
fi
AC_SUBST(MPFR_CPPFLAGS)
AC_SUBST(MPFR_LDFLAGS)
AC_SUBST(MPFR_LIBS)
AM_CONDITIONAL([WITH_MPFR_IS_YES],[test x"$MPFR" != xno])
])
