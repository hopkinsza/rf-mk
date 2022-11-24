.include <rf/init.mk>

#
# Flags and options.
#
# TODO: LIBISPRIVATE
# TODO: maybe CXX support

LIBOWN ?=	${BINOWN}
LIBGRP ?=	${BINGRP}
LIBMODE ?=	${BINMODE}

# LIBDIR is already defined by own.mk.

CFLAGS += ${COPTS}

# types of library
RFLIB.static ?=	yes
RFLIB.prof ?=	yes
RFLIB.pic ?=	yes
RFLIB.shared ?=	yes

# where to install
RFLIB.staticdir ?=	${LIBDIR}
RFLIB.profdir ?=	${LIBDIR}
RFLIB.picdir ?=		${LIBDIR}
RFLIB.shareddir ?=	${LIBDIR}

#
# Shared library version.
# SHLIB_{MAJOR,MINOR,TEENY} can be defined in the makefile,
# or in file `shlib_version'.
#

.if !defined(SHLIB_MAJOR) && exists(${.CURDIR}/shlib_version)
SHLIB_MAJOR != . ${.CURDIR}/shlib_version; echo $$major
SHLIB_MINOR != . ${.CURDIR}/shlib_version; echo $$minor
SHLIB_TEENY != . ${.CURDIR}/shlib_version; echo $$teeny
.endif

# default
SHLIB_MAJOR ?= x

.if !empty(SHLIB_MAJOR)
SHLIB_FULLVERSION = ${SHLIB_MAJOR}
.  if !empty(SHLIB_MINOR)
SHLIB_FULLVERSION := ${SHLIB_FULLVERSION}.${SHLIB_MINOR}
.    if !empty(SHLIB_TEENY)
SHLIB_FULLVERSION := ${SHLIB_FULLVERSION}.${SHLIB_TEENY}
.    endif
.  endif
.endif

# version number to be compiled into shared library via -soname
SHLIB_SOVERSION = ${SHLIB_MAJOR}

#
# Add rules to create libraries.
#

all: liball
liball: .PHONY

.if !defined(LIB)
.  error LIB must be defined
.endif

SRCS ?= ${LIB}.c
#PROGNAME ?= ${LIB}

# sanity
.for s in ${SRCS}
.  if !empty(s:M*.h)
.    error no headers allowed in SRCS
.  endif
.  if !exists($s)
.    error source file does not exist: $s
.  endif
.endfor

# always clean all libs, even if not building them with current options
_CLEANLIBS =
_LIBS =

_CLEANLIBS += lib${LIB}.a
.if ${RFLIB.static} == yes
_LIBS += lib${LIB}.a
.endif

_CLEANLIBS += lib${LIB}_p.a
.if ${RFLIB.prof} == yes
_LIBS += lib${LIB}_p.a
.endif

_CLEANLIBS += lib${LIB}_pic.a
.if ${RFLIB.pic} == yes
_LIBS += lib${LIB}_pic.a
.endif

_CLEANLIBS += lib${LIB}.so.${SHLIB_FULLVERSION}
.if ${RFLIB.shared} == yes
_LIBS += lib${LIB}.so.${SHLIB_FULLVERSION}
.endif

_OBJS =		${SRCS:R:C/$/.o/}
_OBJS_PROF =	${SRCS:R:C/$/.po/}
_OBJS_PIC =	${SRCS:R:C/$/.pico/}

CLEANFILES := ${CLEANFILES} ${_CLEANLIBS} ${_OBJS} ${_OBJS_PROF} ${_OBJS_PIC}

# lorder'd object files
.if defined(LORDER)
.  if !defined(TSORT)
.    error TSORT must be defined to use LORDER
.  endif
_LOBJS =	`${LORDER} ${_OBJS} | ${TSORT}`
_LOBJS_PROF =	`${LORDER} ${_OBJS_PROF} | ${TSORT}`
_LOBJS_PIC =	`${LORDER} ${_OBJS_PIC} | ${TSORT}`
.else
_LOBJS		= ${_OBJS}
_LOBJS_PROF	= ${_OBJS_PROF}
_LOBJS_PIC	= ${_OBJS_PIC}
.endif

lib${LIB}.a: ${_OBJS}
	@${RFPRINT} build standard ${LIB} library
	@rm -f ${.TARGET}
	${AR} crD ${.TARGET} ${_LOBJS}
	${RANLIB} ${.TARGET}

lib${LIB}_p.a: ${_OBJS_PROF}
	@${RFPRINT} build profiled ${LIB} library
	@rm -f ${.TARGET}
	${AR} crD ${.TARGET} ${_LOBJS_PROF}
	${RANLIB} ${.TARGET}

lib${LIB}_pic.a: ${_OBJS_PIC}
	@${RFPRINT} build PIC ${LIB} library
	@rm -f ${.TARGET}
	${AR} crD ${.TARGET} ${_LOBJS_PIC}
	${RANLIB} ${.TARGET}

# LDADD?
lib${LIB}.so.${SHLIB_FULLVERSION}: ${_OBJS_PIC}
	@${RFPRINT} build shared ${LIB} library
	@rm -f ${.TARGET}
	${CC} -shared -Wl,-soname,lib${LIB}.so.${SHLIB_SOVERSION} \
		${CFLAGS_PIC} \
		-o ${.TARGET} ${.ALLSRC}

# hook into all
liball: ${_LIBS}

#
# Install.
#

install: libinstall
libinstall: .PHONY

__libinstall: .USE
	${INSTALL_FILE} \
		-o ${LIBOWN} \
		-g ${LIBGRP} \
		-m ${LIBMODE} \
		${.ALLSRC} ${.TARGET}

#
# static
#
.if ${RFLIB.static} != no
_PATH := ${DESTDIR}${RFLIB.staticdir}/lib${LIB}.a

libinstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: __libinstall lib${LIB}.a
.endif

#
# prof
#
.if ${RFLIB.prof} != no
_PATH := ${DESTDIR}${RFLIB.profdir}/lib${LIB}_p.a

libinstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: __libinstall lib${LIB}_p.a
.endif

#
# pic
#
.if ${RFLIB.pic} != no
_PATH := ${DESTDIR}${RFLIB.picdir}/lib${LIB}_pic.a

libinstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: __libinstall lib${LIB}_pic.a
.endif

#
# shared
#
.if ${RFLIB.shared} != no
_PATH := ${DESTDIR}${RFLIB.shareddir}/lib${LIB}.so.${SHLIB_FULLVERSION}

libinstall: ${_PATH}
.PRECIOUS: ${_PATH}

${_PATH}: __libinstall lib${LIB}.so.${SHLIB_FULLVERSION}
.endif
