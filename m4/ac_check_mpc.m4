# check for mpc library
# sets MPC_CFLAGS, MPC_LDFLAGS and MPC_LIBS,
# and MPC_WITH, MPC_DEPEND,
# and MPC=yes/no

AC_DEFUN([AC_CHECK_MPC],[
temp_LIBS="$LIBS"
temp_CPPFLAGS="$CPPFLAGS"
temp_LDFLAGS="$LDFLAGS"
MPC=unknown
MPC_WITH=""
MPC_DEPEND=""

AC_ARG_WITH(mpc,
 [  --with-mpc=<location>
    Location at which the MPC library was installed.
    If the argument is omitted, the library is assumed to be reachable
    under the standard search path (/usr, /usr/local,...).  Otherwise
    you must give the <path> to the directory which contains the
    library.],
 [if test "$withval" = no; then
    MPC=no
  elif test "$withval" = yes; then
    MPC=yes
  else
    MPC_WITH="$MPC_WITH --with-mpc=$withval"
    MPC=yes
    MPC_CFLAGS="-I$withval/include"; MPC_LDFLAGS="-L$withval/lib"
  fi]
)

AC_ARG_WITH(mpc-include,
 [  --with-mpc-include=<location>
    Location at which the mpc include files were installed.],
 [MPC=yes
  MPC_WITH="$MPC_WITH --with-mpc-include=$withval"
  MPC_CFLAGS="-I$withval"]
)

AC_ARG_WITH(mpc-lib,
 [  --with-mpc-lib=<location>
    Location at which the mpc library files were installed.
 ],
 [MPC=yes
  MPC_WITH="$MPC_WITH --with-mpc-lib=$withval"
  MPC_LDFLAGS="-L$withval"]
)

if test "$MPC" != no; then

if test "$MPFR" = no; then
    AC_ERROR([Cannot have MPC without having MPFR too.])
fi

MPC_LIBS="-lmpc"

AC_LANG_PUSH([C])
temp_status=true
CPPFLAGS="$CPPFLAGS $MPC_CFLAGS $MPFR_CFLAGS"
AC_CHECK_HEADER(mpc.h,,[temp_status=false],[#include <mpfr.h>])
LDFLAGS="$LDFLAGS $MPC_LDFLAGS $MPFR_CFLAGS"
AC_CHECK_LIB(mpc,mpc_sqrt,,[temp_status=false])
AC_LANG_POP([C])

if test "$temp_status" = false; then
    if test "$MPC" = yes; then
        AC_MSG_ERROR([library mpc not found. Using --with-mpc, specify its location, or "no" to disable it.])
    else
        MPC=no
    fi
else
    MPC=yes
fi

fi

CPPFLAGS="$temp_CPPFLAGS"
LDFLAGS="$temp_LDFLAGS"
LIBS="$temp_LIBS"

if test "$MPC" != no; then
    AC_DEFINE([USE_MPC],1,[use MPC library])
fi
AC_SUBST(MPC_CFLAGS)
AC_SUBST(MPC_LDFLAGS)
AC_SUBST(MPC_LIBS)
AM_CONDITIONAL([WITH_MPC_IS_YES],[test x"$MPC" != xno])
])
