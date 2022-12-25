.if !defined(_RF_PROG_MK_)
.  include <rf/init.mk>
.endif

#
# PROG -> PROGS conversion if necessary.
#

.if defined(PROG) && defined(PROGS)
.  error "cannot have both PROG and PROGS defined"
.endif

.if defined(PROG)
PROGS = ${PROG}
.endif

#
# Flags and options.
#
# TODO: CXX support
# TODO: incs

# for historical reasons
CFLAGS += ${COPTS}

#
# Add rules to build each program.
#

all: progall
progall: .PHONY

.for p in ${PROGS}
CLEANFILES := ${CLEANFILES} $p

SRCS.$p ?= ${SRCS:U$p.c}
PROGNAME.$p ?= ${PROGNAME:U$p}

# Loop through SRCS to figure out the object files.
# s -> src
# o -> object (.o suffix)
_OBJS.$p =
.  for s in ${SRCS.$p}
.    if ${s:M*.h}
.      error "no headers allowed in SRCS"
.    endif

# A prog depends on the source file indirectly through the `.o';
# do a sanity check that the source exists or has a target to make it.
.    if !exists($s) && !target($s)
.      error source file does not exist and has no target to make it: $s
.    endif

o := ${s:R:S/$/.o/}
CLEANFILES := ${CLEANFILES} $o
_OBJS.$p := ${_OBJS.$p} $o

# XXX: RFCONF.h.autodep support
.    if "${RFCONF.h.autodep}" == yes
$o: ${RFCONF.h.file}
.    endif

.  endfor

# Figure out if we should link with CXX, based on source suffixes.
_CXX = 0
.  if ${MKCXX:Uyes} == yes
.    for x in ${CXX_SUFFIXES}
.      if !empty(SRCS.$p:M*$x)
_CXX = 1
.        break
.      endif
.    endfor
.  endif

# Final linking.
# LDSTATIC can be overridden per-program.
# LDFLAGS and LDADD can be appended to per-program.
$p: ${_OBJS.$p}
	@${RFPRINT.tg.link}
.if ${_CXX} == 0
	${CC} \
		${LDSTATIC.$p:U${LDSTATIC}} \
		${LDFLAGS} \
		${LDFLAGS.$p} \
		-o ${.TARGET} ${.ALLSRC} \
		${LDADD} \
		${LDADD.$p}
.else
	${CXX} \
		${LDSTATIC.$p:U${LDSTATIC}} \
		${LDFLAGS} \
		${LDFLAGS.$p} \
		-o ${.TARGET} ${.ALLSRC} \
		${LDADD} \
		${LDADD.$p}
.endif

progall: $p

.endfor

#
# Installation.
#

install: proginstall
proginstall: .PHONY

.for f in ${PROGS}

_DIR :=  ${DESTDIR}${BINDIR.$f:U${BINDIR}}
# PROGNAME.prog > PROGNAME > default
_NAME := ${PROGNAME.$f:U${PROGNAME:U${f}}}
_PATH := ${_DIR}/${_NAME}

proginstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: $f
	@${ENSURE_DIR}
	@${RFPRINT.tg.install}
	${INSTALL_FILE} \
		-o ${BINOWN.${.ALLSRC}:U${BINOWN}} \
		-g ${BINGRP.${.ALLSRC}:U${BINGRP}} \
		-m ${BINMODE.${.ALLSRC}:U${BINMODE}} \
		${.ALLSRC} ${.TARGET}

.endfor
