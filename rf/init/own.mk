#
# Set default values for *OWN, *GRP, *MODE, and *DIR.
# Define useful functions for use in shell.
#

.if !defined(_RF_OWN_MK_)
_RF_OWN_MK_ = 1

#
# Output.
#

RF.verbose ?= 2

.if ${RF.verbose} == 0
RFPRINT = :
.MAKEFLAGS: -s
.elif ${RF.verbose} == 1
.MAKEFLAGS: -s
.elif ${RF.verbose} == 2
# everything normal
.elif ${RF.verbose} == 3
.MAKEFLAGS: -dl
.elif ${RF.verbose} == 4
.MAKEFLAGS: -dl -dx
.endif

RFPRINT ?= echo '\# '

####
#### PREFIX and related variables.
####

PREFIXVARS = PREFIX PKG

PREFIX ?= /usr/local

PKG ?= ${PROG:U${LIB}}
.if empty(PKG)
.  error PKG is not defined
.endif

#
# The three base directories to install to.
# LOCALBASE: static data/files
# ETCBASE: configuration files
# VARBASE: dynamic (variable) data/files
#

PREFIXVARS += LOCALBASE \
	ETCBASE \
	VARBASE

LOCALBASE ?=	${PREFIX}
ETCBASE ?=	${PREFIX}/etc
VARBASE ?=	${PREFIX}/var

#
# LOCALBASE traditional directories.
#

PREFIXVARS += BINDIR \
	INCDIR \
	LIBDIR \
	MANDIR

BINDIR ?=	${LOCALBASE}/bin
INCDIR ?=	${LOCALBASE}/include
LIBDIR ?=	${LOCALBASE}/lib
MANDIR ?=	${LOCALBASE}/share/man

#
# LOCALBASE additional directories.
#
# DOCDIR: misc documentation
# EXAMPLESDIR: usage examples
# LIBDATADIR: ?
# SHAREDIR: generic static data
# TODO: libdata vs share?
#

PREFIXVARS += DOCDIR \
	EXAMPLESDIR \
	LIBDATADIR \
	SHAREDIR

DOCDIR ?=	${LOCALBASE}/share/doc/${PKG}
EXAMPLESDIR ?=	${LOCALBASE}/share/examples/${PKG}
LIBDATADIR ?=	${LOCALBASE}/libdata/${PKG}
SHAREDIR ?=	${LOCALBASE}/share/${PKG}

#
# ETCBASE - one configuration file directory.
# Set it to ${ETCBASE}/${PKG} if there are many config files.
#

PREFIXVARS += ETCDIR

ETCDIR ?=	${ETCBASE}

#
# VARBASE - for variable runtime data.
#

PREFIXVARS += CACHEDIR \
	DBDIR \
	SPOOLDIR

CACHEDIR ?=	${VARBASE}/cache/${PKG}
DBDIR ?=	${VARBASE}/db/${PKG}
SPOOLDIR ?=	${VARBASE}/spool/${PKG}

#
# Default permissions.
#

BINOWN ?=	root
BINGRP ?=	wheel
BINMODE ?=	555
NONBINMODE ?=	444
EDITMODE ?=	644

DIROWN ?=	${BINOWN}
DIRGRP ?=	${BINGRP}
DIRMODE ?=	755

#
# Derived from netbsd MAKEDIRTARGET as defined in <bsd.own.mk>.
#
# usage: ${MAKEDIRTARGET} [dir [target]]
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
			rel="${_THISDIR_}"; \
			abs="${.CURDIR}"; \
			;; \
		*) \
			if [ -z "${_THISDIR_}" ]; then \
				rel="$$dir"; \
			else \
				rel="${_THISDIR_}/$$dir"; \
			fi; \
			abs="${.CURDIR}/$$dir"; \
			;; \
		esac; \
		echo "===> $${rel} [$$targ]$${1:+ (with $$@)}"; \
		cd "$$abs" \
		&& ${MAKE} _THISDIR_="$$rel" "$$@" $$targ; \
	}; \
	_mkdirtarg

#
# INSTALL helpers.
#

INSTALL ?= install

INSTALL_DIR ?=		${INSTALL} -d -o ${DIROWN} -g ${DIRGRP} -m ${DIRMODE}
INSTALL_FILE ?=		${INSTALL} -c
INSTALL_LINK ?=		${INSTALL} -l h
INSTALL_SYMLINK ?=	${INSTALL} -l s

.endif # _RF_OWN_MK_
