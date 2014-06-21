# check for mpfr library
# sets MPFR_CFLAGS, MPFR_LDFLAGS, MPFR_MAKELIB and MPFR_LIBS,
# and MPFR_WITH, MPFR_DEPEND,
# and MPFR=yes/no/extern

AC_DEFUN([AC_CHECK_MPFR],[
temp_LIBS="$LIBS"
temp_CPPFLAGS="$CPPFLAGS"
temp_LDFLAGS="$LDFLAGS"
MPFR=unknown
MPFR_WITH=""
MPFR_DEPEND=""

AC_ARG_WITH(mpfr,
 [  --with-mpfr=<location>
    Location at which the MPFR library was installed.
    If the argument is omitted, the library is assumed to be reachable
    under the standard search path (/usr, /usr/local,...).  Otherwise
    you must give the <path> to the directory which contains the
    library. The special value "extern" asks Float
    to compile a version of mpfr in the subdirectory extern/.],
 [if test "$withval" = extern; then
    MPFR=extern
  elif test "$withval" = no; then
    MPFR=no
  elif test "$withval" = yes; then
    MPFR=yes
  else
    MPFR_WITH="$MPFR_WITH --with-mpfr=$withval"
    MPFR=yes
    MPFR_CFLAGS="-I$withval/include"; MPFR_LDFLAGS="-L$withval/lib"
  fi]
)

AC_ARG_WITH(mpfr-include,
 [  --with-mpfr-include=<location>
    Location at which the mpfr include files were installed.],
 [MPFR=yes
  MPFR_WITH="$MPFR_WITH --with-mpfr-include=$withval"
  MPFR_CFLAGS="-I$withval"]
)

AC_ARG_WITH(mpfr-lib,
 [  --with-mpfr-lib=<location>
    Location at which the mpfr library files were installed.
 ],
 [MPFR=yes
  MPFR_WITH="$MPFR_WITH --with-mpfr-lib=$withval"
  MPFR_LDFLAGS="-L$withval"]
)

if test "$MPFR" != no; then

MPFR_LIBS="-lmpfr"

if test "$MPFR" != extern; then

AC_LANG_PUSH([C])
temp_status=true
CPPFLAGS="$CPPFLAGS $MPFR_CFLAGS"
AC_CHECK_HEADER(mpfr.h,,[temp_status=false])
LDFLAGS="$LDFLAGS $MPFR_LDFLAGS"
AC_CHECK_LIB(mpfr,mpfr_sqrt,,[temp_status=false])
AC_LANG_POP([C])

if test "$temp_status" = false; then
    if test "$MPFR" = yes; then
        AC_MSG_ERROR([library mpfr not found. Using --with-mpfr, specify its location, "extern" to compile it locally, or "no" to disable it.])
    else
        MPFR=extern
    fi
else
    MPFR=yes
fi

fi

if test "$MPFR" = extern; then

MPFR_MAKELIB=`printf 'mpfr: $(MPFRLIB).tar.bz2  \\
	mkdir -p $(EXTERN)/include $(EXTERN)/lib  \\
	if ! test -r $(EXTERN)/include/mpfr.h; then \\
	    rm -rf $(MPFRLIB) && \\
	    tar -x -f $(MPFRLIB).tar.bz2 -j -C extern && \\
	    cd $(MPFRLIB) && \\
	    ./configure %s --prefix=$(EXTERN) && \\
	    $(MAKE) install; \\
	fi\n' "$GMP_WITH"`

MAKE_LIBTARGETS="$MAKE_LIBTARGETS mpfr"
MPFR_CFLAGS='-I$(EXTERN)/include'
MPFR_LDFLAGS='-L$(EXTERN)/lib'

MPFR_WITH='--with-mpfr=$(EXTERN)'
MPFR_DEPEND='mpfr'

fi

fi

CPPFLAGS="$temp_CPPFLAGS"
LDFLAGS="$temp_LDFLAGS"
LIBS="$temp_LIBS"

if test "$MPFR" != no; then
    AC_DEFINE([USE_MPFR],1,[use MPFR library])
fi
AC_SUBST(MPFR_CFLAGS)
AC_SUBST(MPFR_LDFLAGS)
AC_SUBST(MPFR_LIBS)
AC_SUBST(MPFR_MAKELIB)
AC_SUBST(MAKE_LIBTARGETS)
AM_CONDITIONAL([WITH_MPFR_IS_YES],[test x"$MPFR" != xno])
])
