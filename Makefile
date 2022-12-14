#
# This is a wrapper Makefile.
# Its purpose is to first delete the rf-mk installation,
# then invoke bmake with the correct options to install.
#

# try to get non-BSD `make` dialects to fail before doing anything weird
.if !empty(.TARGETS)
.endif

.PHONY: all install

# allow `install` to be run even with `make -n`
.RECURSIVE: install

all:

install:
	rm -rf /usr/share/mk/rf/
	${MAKE} -m ${.CURDIR} -f ${.CURDIR}/RealMakefile install
