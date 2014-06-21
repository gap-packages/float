#############################################################################
##
#W Makefile.am                                              Laurent Bartholdi
##
#Y Copyright (C) 2014, Laurent Bartholdi
##
#############################################################################

ACLOCAL_AMFLAGS = -I m4

AUTOMAKE_OPTIONS = \
	foreign \
	dist-xz \
	dist-bzip2 \
	std-options

#AM_DISTCHECK_CONFIGURE_FLAGS =

SUBDIRS = src doc

EXTRA_DIST =

export TAR_OPTIONS = --owner=0 --group=0 --numeric-owner

VERSION:=$(shell grep '^Version :=' PackageInfo.g | cut -f2 -d'"')

LOCALBIN=bin/@GAPARCH@

Changelog:
	gitlog-to-changelog > $@

tarball: Changelog doc
	mkdir float-$(VERSION)
	COPYFILE_DISABLE=true tar -c -f - --exclude Makefile --exclude float-$(VERSION) --exclude 'float-*xz*' --exclude '*~' --exclude '.[a-z]*' --exclude 'config.log' --exclude 'Makefile' --exclude autom4te.cache --exclude autom4te.cache --exclude bin --exclude 'stamp-*' --exclude extern . | (cd float-$(VERSION); tar xf -)
	COPYFILE_DISABLE=true tar -c -z -f float-$(VERSION).tar.gz float-$(VERSION)
	rm -rf float-$(VERSION)
	gpg --default-key 184873BE --armor --detach-sign --yes float-$(VERSION).tar.gz
	scp float-$(VERSION).tar.gz* rlaurent.uni-math.gwdg.de:public_html/archive/

doc: doc/chap0.html

doc/chap0.html: doc/float.xml doc/floatbib.xml lib/float.gd
	echo 'LoadPackage("float"); DOC@FLOAT();' | @GAP_EXEC@ -r -q -T -l ";$(PWDUU)"

checkblocks:
	grep '<#GAPDoc' PackageInfo.g lib/*d | awk -F'"' '{print $$2}' | sort > @@-blocks
	grep '<#Include' doc/float.xml | awk -F'"' '{print $$2}' | sort > @@-in
	comm -3 @@-blocks @@-in
	@rm @@-blocks @@-in

wwwdir: doc
	git tag -f $(VERSION)
	git push origin :refs/tags/$(VERSION)
	git push --tags
	cp PackageInfo.g doc/
	cp README doc/README.float
	(cd doc; git add *.html manual.pdf manual.css PackageInfo.g README.float; git commit -m 'New html files'; git push github master:gh-pages --force)
	rm doc/PackageInfo.g doc/README.float

all: all-recursive
	mkdir -p bin/@GAPARCH@
	cp src/.libs/float.so bin/@GAPARCH@/

#E Makefile.am . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
