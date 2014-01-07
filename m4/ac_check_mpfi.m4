# check for mpfi library
# sets MPFI_CFLAGS, MPFI_LDFLAGS, MPFI_MAKELIB and MPFI_LIBS,
# and MPFI_WITH, MPFI_DEPEND,
# and MPFI=yes/no/extern

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
    library. The special value "extern" asks Float
    to compile a version of mpfi in the subdirectory extern/.],
 [if test "$withval" = extern; then
    MPFI=extern
  elif test "$withval" = no; then
    MPFI=no
  elif test "$withval" = yes; then
    MPFI=yes
  else
    MPFI_WITH="$MPFI_WITH --with-mpfi=$withval"
    MPFI=yes
    MPFI_CFLAGS="-I$withval/include"; MPFI_LDFLAGS="-L$withval/lib"
  fi]
)

AC_ARG_WITH(mpfi-include,
 [  --with-mpfi-include=<location>
    Location at which the mpfi include files were installed.],
 [MPFI=yes
  MPFI_WITH="$MPFI_WITH --with-mpfi-include=$withval"
  MPFI_CFLAGS="-I$withval"]
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
    AC_ERROR([Cannot have MPFI without having MPFR too.])
fi

MPFI_LIBS="-lmpfi"

if test "$MPFI" != extern; then

AC_LANG_PUSH([C])
temp_status=true
CPPFLAGS="$CPPFLAGS $MPFI_CFLAGS $MPFR_CFLAGS"
AC_CHECK_HEADER(mpfi.h,,[temp_status=false],[#include <mpfr.h>])
LDFLAGS="$LDFLAGS $MPFI_LDFLAGS $MPFR_CFLAGS"
AC_CHECK_LIB(mpfi,mpfi_sqrt,,[temp_status=false])
AC_LANG_POP([C])

if test "$temp_status" = false; then
    if test "$MPFI" = yes; then
        AC_MSG_ERROR([library mpfi not found. Using --with-mpfi, specify its location, "extern" to compile it locally, or "no" to disable it.])
    else
        MPFI=extern
    fi
else
    MPFI=yes
fi

fi

if test "$MPFI" = extern; then

MPFI_MAKELIB=`printf 'mpfi: $(MPFILIB).tar.bz2 %s
	mkdir -p $(EXTERN)/include $(EXTERN)/lib
	if ! test -r $(EXTERN)/include/mpfi.h; then \\
	    rm -rf $(MPFILIB) && \\
	    tar -x -f $(MPFILIB).tar.bz2 -j -C extern && \\
	    cd $(MPFILIB) && \\
	    ./configure %s %s --prefix=$(EXTERN) && \\
	    $(MAKE) install; \\
	fi\n' "$MPFR_DEPEND" "$GMP_WITH" "$MPFR_WITH"`

MAKE_LIBTARGETS="$MAKE_LIBTARGETS mpfi"
MPFI_CFLAGS='-I$(EXTERN)/include'
MPFI_LDFLAGS='-L$(EXTERN)/lib'

MPFI_WITH='--with-mpfi=$(EXTERN)'
MPFI_DEPEND='mpfi'

fi

fi

CPPFLAGS="$temp_CPPFLAGS"
LDFLAGS="$temp_LDFLAGS"
LIBS="$temp_LIBS"

if test "$MPFI" != no; then
    AC_DEFINE(USE_MPFI)
fi
AC_SUBST(MPFI_CFLAGS)
AC_SUBST(MPFI_LDFLAGS)
AC_SUBST(MPFI_LIBS)
AC_SUBST(MPFI_MAKELIB)
AC_SUBST(MAKE_LIBTARGETS)
])
