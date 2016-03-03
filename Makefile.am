#############################################################################
##
#W Makefile.am                                              Laurent Bartholdi
##
#Y Copyright (C) 2014-2016, Laurent Bartholdi
##
#############################################################################

ACLOCAL_AMFLAGS = -I m4

AUTOMAKE_OPTIONS = \
	foreign \
	std-options

#AM_DISTCHECK_CONFIGURE_FLAGS =

SUBDIRS = src

EXTRA_DIST =

VERSION:=$(shell grep '^Version :=' PackageInfo.g | cut -f2 -d'"')

LOCALBIN=bin/@GAPARCH@

EXTERN=$(CURDIR)/bin/@GAPARCH@/extern

MPFRLIB=extern/mpfr-3.1.2
MPFILIB=extern/mpfi-1.5.1
MPCLIB=extern/mpc-1.0.1
CXSCLIB=extern/cxsc-2-5-3
FPLLLLIB=extern/libfplll-4.0.1
WGET=@WGET@

$(MPFRLIB).tar.bz2:
	@echo "I can't find $@, so I'm going to download it"
	mkdir -p extern
	(cd extern; $(WGET) http://www.mpfr.org/mpfr-3.1.2/mpfr-3.1.2.tar.bz2)

$(MPFILIB).tar.bz2:
	@echo "I can't find $@, so I'm going to download it"
	mkdir -p extern
	(cd extern; $(WGET) @WGET_NOCERTIFICATE@ https://gforge.inria.fr/frs/download.php/30129/mpfi-1.5.1.tar.bz2)

$(MPCLIB).tar.gz:
	@echo "I can't find $@, so I'm going to download it"
	mkdir -p extern
	(cd extern; $(WGET) http://www.multiprecision.org/mpc/download/mpc-1.0.1.tar.gz)

$(CXSCLIB).tar.gz:
	@echo "I can't find $@, so I'm going to download it"
	mkdir -p extern
	(cd extern; $(WGET) http://www2.math.uni-wuppertal.de/~xsc/xsc/cxsc/cxsc-2-5-3.tar.gz)

$(FPLLLLIB).tar.gz:
	@echo "I can't find $@, so I'm going to download it"
	mkdir -p extern
	(cd extern; $(WGET) http://xpujol.net/fplll/libfplll-4.0.1.tar.gz)

mpfr: $(MPFRLIB).tar.bz2
	mkdir -p $(EXTERN)/include $(EXTERN)/lib
	if ! test -r $(EXTERN)/include/mpfr.h; then \
	    rm -rf $(MPFRLIB) && \
	    tar -x -f $(MPFRLIB).tar.bz2 -j -C extern && \
	    cd $(MPFRLIB) && \
	    ./configure $(WITH_GMP) --prefix=$(EXTERN) && \
	    $(MAKE) install; \
	fi

mpfi: $(MPFILIB).tar.bz2 
	mkdir -p $(EXTERN)/include $(EXTERN)/lib
	if ! test -r $(EXTERN)/include/mpfi.h; then \
	    rm -rf $(MPFILIB) && \
	    tar -x -f $(MPFILIB).tar.bz2 -j -C extern && \
	    cd $(MPFILIB) && \
	    ./configure $(WITH_GMP) --prefix=$(EXTERN) && \
	    $(MAKE) install; \
	fi

mpc: $(MPCLIB).tar.gz
	mkdir -p $(EXTERN)/include $(EXTERN)/lib
	if ! test -r $(EXTERN)/include/mpc.h; then \
	    rm -rf $(MPCLIB) && \
	    tar -x -f $(MPCLIB).tar.gz -z -C extern && \
	    cd $(MPCLIB) && \
	    ./configure $(WITH_GMP) --prefix=$(EXTERN) && \
	    $(MAKE) install; \
	fi

cxsc: $(CXSCLIB).tar.gz
	mkdir -p $(EXTERN)
	rm -f $(EXTERN)/cxsc
	ln -s . $(EXTERN)/cxsc
	if ! test -r $(EXTERN)/include/real.hpp; then \
	    rm -rf $(CXSCLIB) && \
	    tar -x -f $(CXSCLIB).tar.gz -z -C extern && \
	    cd $(CXSCLIB) && \
	    (echo "yes"; for i in 1 2 3 4 5 6 7 8 9 10; do echo ""; done) | \
		HOME=$(EXTERN) ./install_cxsc; \
	fi

fplll: $(FPLLLLIB).tar.gz
	mkdir -p $(EXTERN)/include $(EXTERN)/lib
	if ! test -r $(EXTERN)/include/fplll.h; then \
	    rm -rf $(FPLLLLIB) && \
	    tar -x -f $(FPLLLLIB).tar.gz -z -C extern && \
	    cd $(FPLLLLIB) && \
	    ./configure CPPFLAGS="-I$(GMP_ROOT)/include $(CPPFLAGS)" LDFLAGS="-L$(GMP_ROOT)/lib $(LDFLAGS)" $(WITH_GMP) --prefix=$(EXTERN) && \
	    $(MAKE) install; \
	fi

Changelog:
	gitlog-to-changelog > $@

doc: doc/float.xml gap/*.gd
	@GAPROOT@/bin/gap.sh -A makedoc.g

checkblocks:
	grep '<#GAPDoc' PackageInfo.g lib/*d | awk -F'"' '{print $$2}' | sort > @@-blocks
	grep '<#Include' doc/float.xml | awk -F'"' '{print $$2}' | sort > @@-in
	comm -3 @@-blocks @@-in
	@rm @@-blocks @@-in

all: @MAKE_LIBTARGETS@ all-recursive
	mkdir -p bin/@GAPARCH@
	cp src/.libs/float.so bin/@GAPARCH@/

#E Makefile.am . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
