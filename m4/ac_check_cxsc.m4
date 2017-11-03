# check for cxsc library
# sets CXSC_CFLAGS, CXSC_LDFLAGS and CXSC_LIBS,
# and CXSC_WITH, CXSC_DEPEND,
# and CXSC=yes/no

AC_DEFUN([AC_CHECK_CXSC],[
temp_LIBS="$LIBS"
temp_CPPFLAGS="$CPPFLAGS"
temp_LDFLAGS="$LDFLAGS"
CXSC=unknown
CXSC_WITH=""
CXSC_DEPEND=""

AC_ARG_WITH(cxsc,
 [  --with-cxsc=<location>
    Location at which the CXSC library was installed.
    If the argument is omitted, the library is assumed to be reachable
    under the standard search path (/usr, /usr/local,...).  Otherwise
    you must give the <path> to the directory which contains the
    library..],
 [if test "$withval" = no; then
    CXSC=no
  elif test "$withval" = yes; then
    CXSC=yes
  else
    CXSC_WITH="$CXSC_WITH --with-cxsc=$withval"
    CXSC=yes
    CXSC_CFLAGS="-I$withval/include"; CXSC_LDFLAGS="-L$withval/lib"
  fi]
)

AC_ARG_WITH(cxsc-include,
 [  --with-cxsc-include=<location>
    Location at which the cxsc include files were installed.],
 [CXSC=yes
  CXSC_WITH="$CXSC_WITH --with-cxsc-include=$withval"
  CXSC_CFLAGS="-I$withval"]
)

AC_ARG_WITH(cxsc-lib,
 [  --with-cxsc-lib=<location>
    Location at which the cxsc library files were installed.
 ],
 [CXSC=yes
  CXSC_WITH="$CXSC_WITH --with-cxsc-lib=$withval"
  CXSC_LDFLAGS="-L$withval"]
)

if test "$CXSC" != no; then

CXSC_LIBS="-lcxsc"

AC_LANG_PUSH([C++])
temp_status=true
CPPFLAGS="$CPPFLAGS $CXSC_CFLAGS"
AC_CHECK_HEADER(real.hpp,,[temp_status=false])
LDFLAGS="$LDFLAGS $CXSC_LDFLAGS"
AC_CHECK_LIB(cxsc,z_zadd,,[temp_status=false])
AC_LANG_POP([C++])

if test "$temp_status" = false; then
    if test "$CXSC" = yes; then
        AC_MSG_ERROR([library cxsc not found. Using --with-cxsc, specify its location, or "no" to disable it.])
    else
        CXSC=no
    fi
else
    CXSC=yes
fi

fi

CPPFLAGS="$temp_CPPFLAGS"
LDFLAGS="$temp_LDFLAGS"
LIBS="$temp_LIBS"

if test "$CXSC" != no; then
    AC_DEFINE([USE_CXSC],1,[use CXSC library])
fi
AC_SUBST(CXSC_CFLAGS)
AC_SUBST(CXSC_LDFLAGS)
AC_SUBST(CXSC_LIBS)
AM_CONDITIONAL([WITH_CXSC_IS_YES],[test x"$CXSC" != xno])
])
