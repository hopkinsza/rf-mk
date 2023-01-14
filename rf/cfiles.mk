.if !defined(_RF_INIT_MK_)
.  include <rf/init.mk>
.endif

CFILESOWN ?= ${BINOWN}
CFILESGRP ?= ${BINGRP}
CFILESMODE ?= ${EDITMODE}

.if defined(CFILESDIR)
.  error CFILESDIR is defined, but doesn't do anything; see CFILESSUBDIR
.endif
CFILESSUBDIR ?=

CFILESBUILD ?= no

RFCFILES.exampleinstall ?= yes

#
# Hook into targets from <rf/init/targ.mk>.
#

all: configall
configall: .PHONY

install: configexampleinstall
configexampleinstall: .PHONY

configinstall: .PHONY

#
# Build.
#

.for f in ${CFILES}

configall: $f
b := ${CFILESBUILD.$f:U${CFILESBUILD}}

.  if $b == yes
CLEANFILES := ${CLEANFILES} $f
.  else
     # Don't allow it to be built without being added to CLEANFILES
.    if target($f)
.      error not configured to build config "$f", but there is a rule for it
.    endif
.  endif

.endfor

#
# Install.
#

.for f in ${CFILES}

#
# configexampleinstall
#

.  if ${RFCFILES.exampleinstall} == yes

.    if !empty(CFILESSUBDIR)
_DIR := ${DESTDIR}${EXAMPLESDIR}/${CFILESSUBDIR}
.    else
_DIR := ${DESTDIR}${EXAMPLESDIR}
.    endif
_NAME := ${CFILESNAME.$f:U${CFILESNAME:U${f:T}}}
_PATH := ${_DIR}/${_NAME}

configexampleinstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: $f
	@${ENSURE_DIR}
	@${RFPRINT.tg.install}
	${INSTALL_FILE} \
		-o ${CFILESOWN.${.ALLSRC}:U${CFILESOWN}} \
		-g ${CFILESGRP.${.ALLSRC}:U${CFILESGRP}} \
		-m ${CFILESMODE.${.ALLSRC}:U${CFILESMODE}} \
		${.ALLSRC} ${.TARGET}

.  endif

#
# configinstall
#

.    if !empty(CFILESSUBDIR)
_DIR := ${DESTDIR}${ETCDIR}/${CFILESSUBDIR}
.    else
_DIR := ${DESTDIR}${ETCDIR}
.    endif
_NAME := ${CFILESNAME.$f:U${CFILESNAME:U${f:T}}}
_PATH := ${_DIR}/${_NAME}

configinstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: $f
	@${ENSURE_DIR}
	@${RFPRINT.tg.install}
	${INSTALL_FILE} \
		-o ${CFILESOWN.${.ALLSRC}:U${CFILESOWN}} \
		-g ${CFILESGRP.${.ALLSRC}:U${CFILESGRP}} \
		-m ${CFILESMODE.${.ALLSRC}:U${CFILESMODE}} \
		${.ALLSRC} ${.TARGET}

.endfor
