#############################################################################
##
#W Makefile.am                                              Laurent Bartholdi
##
#Y Copyright (C) 2014-2017, Laurent Bartholdi
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

Changelog:
	gitlog-to-changelog > $@

doc: doc/float.xml gap/*.gd
	@GAPROOT@/bin/gap.sh -A makedoc.g

checkblocks:
	grep '<#GAPDoc' PackageInfo.g lib/*d | awk -F'"' '{print $$2}' | sort > @@-blocks
	grep '<#Include' doc/float.xml | awk -F'"' '{print $$2}' | sort > @@-in
	comm -3 @@-blocks @@-in
	@rm @@-blocks @@-in

all: all-recursive
	mkdir -p bin/@GAPARCH@
	cp src/.libs/float.so bin/@GAPARCH@/

#E Makefile.am . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
