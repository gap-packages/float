#############################################################################
##
#W doc/Makefile.am                                          Laurent Bartholdi
##
#Y Copyright (C) 2014, Laurent Bartholdi
##
#############################################################################

docdir = $(GAPROOT)/pkg/$(PACKAGE)/doc

all-local: doc

doc: manual.six

manual.six: float.xml floatbib.xml
	cd $(top_srcdir) && echo 'LoadPackage("float"); DOC@FLOAT();' | $(GAP_EXEC) -A -q -T

distclean-local:
	rm -f chap*.txt chap*.html index.html chooser.html
	rm -f lefttoc.css ragged.css times.css toggless.css nocolorprompt.css
	rm -f rainbow.js toggless.js
	rm -f manual.six manual.css manual.js manual.lab
	rm -f manual.pdf
	rm -f float.tex
	rm -f float.aux float.idx float.bbl float.ind float.out float.toc float.pnr
	rm -f float.log float.blg float.ilg

#E doc/Makefile.am . . . . . . . . . . . . . . . . . . . . . . . . . ends here
