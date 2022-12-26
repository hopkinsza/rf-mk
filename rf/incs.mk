.if !defined(_RF_INIT_MK_)
.  include <rf/init.mk>
.endif

INCSOWN ?= ${BINOWN}
INCSGRP ?= ${BINGRP}
INCSMODE ?= ${NONBINMODE}

INCSDIR ?= ${LOCALBASE}/include

INCSBUILD ?= no

#
# Hook into targets from <rf/init/targ.mk>.
#

all: incsall
incsall: .PHONY

# Must specify 'includes' target to install include files.
#install: includes
includes: .PHONY

#
# Build.
#

.for f in ${INCS}

incsall: $f
b := ${INCSBUILD.$f:U${INCSBUILD}}

.  if $b == yes
CLEANFILES := ${CLEANFILES} $f
.  else
     # Don't allow it to be built without being added to CLEANFILES
.    if target($f)
.      error not configured to build file "$f", but there is a rule for it
.    endif
.  endif

.endfor

#
# Installation.
#

.for f in ${INCS}

_DIR := ${DESTDIR}${INCSDIR.$f:U${INCSDIR}}
_NAME := ${INCSNAME.$f:U${INCSNAME:U${f:T}}}
_PATH := ${_DIR}/${_NAME}

includes: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: $f
	@${ENSURE_DIR}
	@${RFPRINT.tg.install}
	${INSTALL_FILE} \
		-o ${INCSOWN.${.ALLSRC}:U${INCSOWN}} \
		-g ${INCSGRP.${.ALLSRC}:U${INCSGRP}} \
		-m ${INCSMODE.${.ALLSRC}:U${INCSMODE}} \
		${.ALLSRC} ${.TARGET}

.endfor
