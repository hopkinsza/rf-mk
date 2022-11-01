#
# Set default values for *OWN, *GRP, *MODE, and *DIR.
# Define useful functions for use in shell.
#

.if !defined(_RF_OWN_MK_)
_RF_OWN_MK_ = 1

#
# Directories.
#

PREFIX ?= /usr/local

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

.if !empty(RF.cconf)
# XXX: maybe a better way to do this with a .for loop.
# Need to keep this sync'd with the variables above for now.
# Also, you need to remove the file (or make clean) to get new values.
$(RF.cconf):
	@echo 'create $(.TARGET)'
	@exec >$(.TARGET); \
		echo '#ifndef _RF_CONF_H_'; \
		echo '#define _RF_CONF_H_'; \
		echo ''; \
		echo '#define BINDIR	"$(BINDIR)"'; \
		echo '#define ETCDIR	"$(ETCDIR)"'; \
		echo '#define INCDIR	"$(INCDIR)"'; \
		echo '#define LIBDIR	"$(LIBDIR)"'; \
		echo '#define SHAREDIR	"$(SHAREDIR) "'; \
		echo '#define VARDIR	"$(VARDIR)"'; \
		echo '#define DOCDIR	"$(DOCDIR)"'; \
		echo '#define MANDIR	"$(MANDIR)"'; \
		echo '#define RUNDIR	"$(RUNDIR)"'; \
		echo ''; \
		echo '#endif // _RF_CONF_H_'; \

CLEANFILES := $(CLEANFILES) $(RF.cconf)

realall: $(RF.cconf)
.ORDER: $(RF.cconf) realall
.endif

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
.if "$(MKUPDATE)" == no
INSTALL_FILE ?=		$(INSTALL) -c
.else
INSTALL_FILE ?=		$(INSTALL) -c -p
.endif
INSTALL_LINK ?=		$(INSTALL) -l h
INSTALL_SYMLINK ?=	$(INSTALL) -l s

.endif # _RF_OWN_MK_
