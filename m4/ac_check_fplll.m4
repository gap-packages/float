# check for fplll library
# sets FPLLL_CFLAGS, FPLLL_LDFLAGS, FPLLL_MAKELIB and FPLLL_LIBS,
# and FPLLL_WITH, FPLLL_DEPEND,
# and FPLLL=yes/no/extern

AC_DEFUN([AC_CHECK_FPLLL],[
temp_LIBS="$LIBS"
temp_CPPFLAGS="$CPPFLAGS"
temp_LDFLAGS="$LDFLAGS"
FPLLL=unknown
FPLLL_WITH=""
FPLLL_DEPEND=""

FPLLL_MAKELIB=`printf 'fplll: $(FPLLLLIB).tar.gz %s \\
	mkdir -p $(EXTERN)/include $(EXTERN)/lib \\
	if ! test -r $(EXTERN)/include/fplll.h; then \\
	    rm -rf $(FPLLLLIB) && \\
	    tar -x -f $(FPLLLLIB).tar.gz -z -C extern && \\
	    cd $(FPLLLLIB) && \\
	    ./configure CPPFLAGS="%s %s $(CPPFLAGS)" LDFLAGS="%s %s $(LDFLAGS)" %s %s --prefix=$(EXTERN) && \\
	    $(MAKE) install; \\
	fi\n' "$MPFR_DEPEND" "$GMP_CFLAGS" "$MPFR_CFLAGS" "$GMP_LDFLAGS" "$MPFR_LDFLAGS" "$GMP_WITH" "$MPFR_WITH"`

AC_ARG_WITH(fplll,
 [  --with-fplll=<location>
    Location at which the FPLLL library was installed.
    If the argument is omitted, the library is assumed to be reachable
    under the standard search path (/usr, /usr/local,...).  Otherwise
    you must give the <path> to the directory which contains the
    library. The special value "extern" asks Float
    to compile a version of fplll in the subdirectory extern/.],
 [if test "$withval" = extern; then
    FPLLL=extern
  elif test "$withval" = no; then
    FPLLL=no
  elif test "$withval" = yes; then
    FPLLL=yes
  else
    FPLLL_WITH="$FPLLL_WITH --with-fplll=$withval"
    FPLLL=yes
    FPLLL_CFLAGS="-I$withval/include"; FPLLL_LDFLAGS="-L$withval/lib"
  fi]
)

AC_ARG_WITH(fplll-include,
 [  --with-fplll-include=<location>
    Location at which the fplll include files were installed.],
 [FPLLL=yes
  FPLLL_WITH="$FPLLL_WITH --with-fplll-include=$withval"
  FPLLL_CFLAGS="-I$withval"]
)

AC_ARG_WITH(fplll-lib,
 [  --with-fplll-lib=<location>
    Location at which the fplll library files were installed.
 ],
 [FPLLL=yes
  FPLLL_WITH="$FPLLL_WITH --with-fplll-lib=$withval"
  FPLLL_LDFLAGS="-L$withval"]
)

if test "$FPLLL" != no; then

if test "$MPFR" = no; then
    AC_ERROR([Cannot have FPLLL without having MPFR too.])
fi

FPLLL_LIBS="-lfplll"

if test "$FPLLL" != extern; then

AC_LANG_PUSH([C++])
CPPFLAGS="$CPPFLAGS $FPLLL_CFLAGS $MPFR_CFLAGS"
AC_CHECK_HEADER(fplll.h,[found_fplll=true],[found_fplll=false],[#include <mpfr.h>])
LDFLAGS="$LDFLAGS $FPLLL_LDFLAGS $MPFR_CFLAGS"
LIBS="$LIBS -lfplll -lgmp"
if test "$found_fplll" = true; then
    AC_MSG_CHECKING([for lllReduction in -fplll (version 4.x)])
    AC_LINK_IFELSE([AC_LANG_PROGRAM([#include <fplll.h>],[ZZ_mat<mpz_t> M(3,3);lllReduction(M, 0.99, 0.51, LM_WRAPPER);])],[AC_MSG_RESULT([yes]);found_fplll=4],[AC_MSG_RESULT([no]);found_fplll=false])
fi
if test "$found_fplll" = false; then
    $as_unset ac_cv_header_fplll_h
    AX_CXX_COMPILE_STDCXX([11],[noext],[mandatory])
    AC_CHECK_HEADER(fplll.h,[found_fplll=true],[found_fplll=false],[#include <mpfr.h>])
    AC_MSG_CHECKING([for lllReduction in -fplll (version 5.x)])
    AC_LINK_IFELSE([AC_LANG_PROGRAM([#include <fplll.h>],[ZZ_mat<mpz_t> M(3,3);lll_reduction(M, 0.99, 0.51, LM_WRAPPER);])],[AC_MSG_RESULT([yes]);found_fplll=5],[AC_MSG_RESULT([no]);found_fplll=false])
fi
AC_LANG_POP([C++])

if test "$found_fplll" = false; then
    if test "$FPLLL" = yes; then
        AC_MSG_ERROR([library fplll not found. Using --with-fplll, specify its location, "extern" to compile it locally, or "no" to disable it.])
    else
        FPLLL=extern
	found_fplll=4
    fi
else
    FPLLL=yes
fi
FPLLL_VERSION="$found_fplll"
AC_DEFINE([FPLLL_VERSION], [], [fplll major version])
fi

if test "$FPLLL" = extern; then

MAKE_LIBTARGETS="$MAKE_LIBTARGETS fplll"
FPLLL_CFLAGS='-I$(EXTERN)/include'
FPLLL_LDFLAGS='-L$(EXTERN)/lib'

FPLLL_WITH='--with-fplll=$(EXTERN)'
FPLLL_DEPEND='fplll'

fi

fi

CPPFLAGS="$temp_CPPFLAGS"
LDFLAGS="$temp_LDFLAGS"
LIBS="$temp_LIBS"

if test "$FPLLL" != no; then
    AC_DEFINE([USE_FPLLL],1,[use FPLLL library])
fi
AC_SUBST(FPLLL_CFLAGS)
AC_SUBST(FPLLL_LDFLAGS)
AC_SUBST(FPLLL_LIBS)
AC_SUBST(FPLLL_MAKELIB)
AC_SUBST(MAKE_LIBTARGETS)
AM_CONDITIONAL([WITH_FPLLL_IS_YES],[test x"$FPLLL" != xno])
])
