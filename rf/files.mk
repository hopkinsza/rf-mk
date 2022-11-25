.if !defined(_RF_INIT_MK_)
.  include <rf/init.mk>
.endif

FILESOWN ?= ${BINOWN}
FILESGRP ?= ${BINGRP}
FILESMODE ?= ${NONBINMODE}

FILESDIR ?= ${BINDIR}

FILESBUILD ?= no

#
# Hook into targets from <rf/init/targ.mk>.
#

all: filesall
filesall: .PHONY

install: filesinstall
filesinstall: .PHONY

#
# Build.
#

.for f in ${FILES}

filesall: $f
b := ${FILESBUILD.$f:U${FILESBUILD}}

.  if $b != no
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

.for f in ${FILES}

_DIR := ${DESTDIR}${FILESDIR.$f:U${FILESDIR}}
_NAME := ${FILESNAME.$f:U${FILESNAME:U${f:T}}}
_PATH := ${_DIR}/${_NAME}

filesinstall: ${_PATH}
.PRECIOUS: ${_PATH}

# Files can be in a subdir.
# You can use a slash in a variable name like FILESOWN.files/file=root.
${_PATH}: $f
	${INSTALL_FILE} \
		-o ${FILESOWN.${.ALLSRC}:U${FILESOWN}} \
		-g ${FILESGRP.${.ALLSRC}:U${FILESGRP}} \
		-m ${FILESMODE.${.ALLSRC}:U${FILESMODE}} \
		${.ALLSRC} ${.TARGET}

.endfor
