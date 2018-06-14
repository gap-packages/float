#############################################################################
##
#W src/Makefile.am                                          Laurent Bartholdi
##
#Y Copyright (C) 2014, Laurent Bartholdi
##
#############################################################################

libdir = $(GAPROOT)/pkg/$(PACKAGE)/bin/$(GAPARCH)

lib_LTLIBRARIES = float.la

float_la_SOURCES = floatconfig.h floattypes.h float.c
float_la_CPPFLAGS = $(GAP_CPPFLAGS)
float_la_CFLAGS = $(GAP_CFLAGS)
float_la_LDFLAGS = $(GAP_LDFLAGS) -avoid-version -module
float_la_LIBADD =

if WITH_MPFR_IS_YES
float_la_SOURCES += mpfr.c
float_la_CFLAGS += $(MPFR_CFLAGS)
float_la_LDFLAGS += $(MPFR_LDFLAGS)
float_la_LIBADD += $(MPFR_LIBS)
endif ## WITH_MPFR_IS_YES

if WITH_MPC_IS_YES
float_la_SOURCES +=	mpc.c mp_poly.C
float_la_CFLAGS += $(MPC_CFLAGS)
float_la_LDFLAGS += $(MPC_LDFLAGS)
float_la_LIBADD += $(MPC_LIBS)
endif ## WITH_MPC_IS_YES

if WITH_MPFI_IS_YES
float_la_SOURCES += mpfi.c
float_la_CFLAGS += $(MPFI_CFLAGS)
float_la_LDFLAGS += $(MPFI_LDFLAGS)
float_la_LIBADD += $(MPFI_LIBS)
endif ## WITH_MPFI_IS_YES

if WITH_FPLLL_IS_YES
float_la_SOURCES += fplll.C
float_la_CFLAGS += $(FPLLL_CFLAGS)
float_la_LDFLAGS += $(FPLLL_LDFLAGS)
float_la_LIBADD += $(FPLLL_LIBS)
endif ## WITH_FPLLL_IS_YES

if WITH_CXSC_IS_YES
float_la_SOURCES += cxsc.C cxsc_poly.C
float_la_CPPFLAGS += $(CXSC_CFLAGS)
float_la_LDFLAGS += $(CXSC_LDFLAGS)
float_la_LIBADD += $(CXSC_LIBS)
endif ## WITH_CXSC_IS_YES

#E src/Makefile.am . . . . . . . . . . . . . . . . . . . . . . . . . ends here
