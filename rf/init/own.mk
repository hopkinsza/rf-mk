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

# used to make sure a directory we're installing to exists
ENSURE_DIR ?=		[ ! -d "${.TARGET:H}/" ] && ${INSTALL_DIR} "${.TARGET:H}/"

.endif # _RF_OWN_MK_
