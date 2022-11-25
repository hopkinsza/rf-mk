.include <rf/init.mk>

CFILESOWN ?= ${BINOWN}
CFILESGRP ?= ${BINGRP}
CFILESMODE ?= ${EDITMODE}

CFILESBUILD ?= no

RFCFILES.exampleinstall ?= yes

RFCFILES.examplesdir ?= ${EXAMPLESDIR}
RFCFILES.etcdir ?= ${ETCDIR}

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

.for f in ${CFILESS}

b := ${CFILESBUILD.$f:U${CFILESBUILD}}

.  if $b != no
configall: $f
CLEANFILES := ${CLEANFILES} $f
.  endif

.endfor

#
# Install.
#

.for f in ${CFILES}

#
# configexampleinstall
#

.  if ${RFCFILES.exampleinstall} != no

_DIR := ${RFCFILES.examplesdir}
_NAME := ${CFILESNAME.$f:U${CFILESNAME:U${f:T}}}
_PATH := ${DESTDIR}${_DIR}/${_NAME}

configexampleinstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: $f
	${INSTALL_FILE} \
		-o ${CFILESOWN.${.ALLSRC}:U${CFILESOWN}} \
		-g ${CFILESGRP.${.ALLSRC}:U${CFILESGRP}} \
		-m ${CFILESMODE.${.ALLSRC}:U${CFILESMODE}} \
		${.ALLSRC} ${.TARGET}

.  endif

#
# configinstall
#

_DIR := ${RFCFILES.etcdir}
_NAME := ${CFILESNAME.$f:U${CFILESNAME:U${f:T}}}
_PATH := ${DESTDIR}${_DIR}/${_NAME}

configinstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: $f
	${INSTALL_FILE} \
		-o ${CFILESOWN.${.ALLSRC}:U${CFILESOWN}} \
		-g ${CFILESGRP.${.ALLSRC}:U${CFILESGRP}} \
		-m ${CFILESMODE.${.ALLSRC}:U${CFILESMODE}} \
		${.ALLSRC} ${.TARGET}

.endfor
