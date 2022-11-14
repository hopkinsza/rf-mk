#
# Set default values for *OWN, *GRP, *MODE, and *DIR.
# Define useful functions for use in shell.
#

.if !defined(_RF_OWN_MK_)
_RF_OWN_MK_ = 1

#
# Global flags.
#

RF.update ?= no

#
# Configuration variables to be passed to the build.
#

PREFIX ?= /usr/local
PREFIXDIRS = BINDIR \
	ETCDIR \
	INCDIR \
	LIBDIR \
	SHAREDIR \
	VARDIR \
	DOCDIR \
	MANDIR \
	RUNDIR

# BIN, INC, LIB, and MAN are traditional.
BINDIR ?=	$(PREFIX)/bin
ETCDIR ?=	$(PREFIX)/etc
INCDIR ?=	$(PREFIX)/include
LIBDIR ?=	$(PREFIX)/lib
SHAREDIR ?=	$(PREFIX)/share
VARDIR ?=	$(PREFIX)/var

DOCDIR ?=	$(SHAREDIR)/doc
MANDIR ?=	$(SHAREDIR)/man
RUNDIR ?=	$(VARDIR)/run

#
# Default permissions.
#

BINOWN ?= root
BINGRP ?= wheel
BINMODE ?= 555
NONBINMODE ?= 444
CONFMODE ?= 644

DIRMODE ?= 755

#
# Derived from netbsd MAKEDIRTARGET as defined in <bsd.own.mk>.
#
# usage: $(MAKEDIRTARGET) [dir [target]]
# cd to target, printing a nice output, and run make.
# No arguments are required.
# dir defaults to `.'.
# target defaults to nothing, which would cause the default target to be used.
MAKEDIRTARGET = \
	@_mkdirtarg() { \
		dir="$${1:-.}"; shift; \
		targ="$$1"; shift; \
		case "$$dir" in \
		/*) \
			rel="$$dir"; \
			abs="$$dir"; \
			;; \
		.) \
			rel="$(_THISDIR_)"; \
			abs="$(.CURDIR)"; \
			;; \
		*) \
			rel="$(_THISDIR_)$$dir"; \
			abs="$(.CURDIR)/$$dir"; \
			;; \
		esac; \
		echo "===> $${rel} [$$targ]$${1:+ (with $$@)}"; \
		cd "$$abs" \
		&& $(MAKE) _THISDIR_="$$rel" "$$@" $$targ; \
	}; \
	_mkdirtarg

#
# INSTALL helpers.
#

INSTALL_DIR ?=		$(INSTALL) -m $(DIRMODE) -d
.if $(RF.update) == no
INSTALL_FILE ?=		$(INSTALL) -c
.else
INSTALL_FILE ?=		$(INSTALL) -c -p
.endif
INSTALL_LINK ?=		$(INSTALL) -l h
INSTALL_SYMLINK ?=	$(INSTALL) -l s

.endif # _RF_OWN_MK_
