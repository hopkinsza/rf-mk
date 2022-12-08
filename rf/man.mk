.if !defined(_RF_INIT_MK_)
.  include <rf/init.mk>
.endif

MANOWN ?= ${BINOWN}
MANGRP ?= ${BINGRP}
MANMODE ?= ${NONBINMODE}

MANSUBDIR ?=

MANBUILD ?= no

#
# Targets.
#

all: manall
manall: .PHONY

install: maninstall
maninstall: .PHONY

#
# Build.
#

.for f in ${MAN}

manall: $f
b := ${MANBUILD.$f:U${MANBUILD}}

.  if $b == yes
CLEANFILES := ${CLEANFILES} $f
.  else
     # Don't allow it to be built without being added to CLEANFILES
.    if target($f)
.      error not configured to build man page "$f", but there is a rule for it
.    endif
.  endif

.endfor

#
# Installation.
#

.for f in ${MAN}

# verify that it looks like a man page
.  if "${f:C/^.+\.[0-9]$//}" != ""
.    error invalid man page: $f
.  endif

_MAN := ${f:R}
_SECT := ${f:E}

.  if !empty(MANSUBDIR)
_DIR := ${DESTDIR}${MANDIR}/${MANSUBDIR}/man${_SECT}
.  else
_DIR := ${DESTDIR}${MANDIR}/man${_SECT}
.  endif

_NAME := ${MANNAME.$f:U${MANNAME:U${f:T}}}

_PATH := ${_DIR}/${_NAME}

maninstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: $f
	${ENSURE_DIR}
	${INSTALL_FILE} \
		-o ${MANOWN.${.ALLSRC}:U${MANOWN}} \
		-g ${MANGRP.${.ALLSRC}:U${MANGRP}} \
		-m ${MANMODE.${.ALLSRC}:U${MANMODE}} \
		${.ALLSRC} ${.TARGET}

.endfor
