#
# Implicit rules and variables to configure them.
#

.if !defined(_RF_SYS_MK_)
_RF_SYS_MK_ = 1

#
# Variables.
#

# if you get a linker error, change to -fPIC
CFLAGS_PIC ?= -fpic
CFLAGS_PROF ?= -pg

#
# Implicit rules.
#

CXX_SUFFIXES ?= .cc .cpp .cxx
.SUFFIXES:
.SUFFIXES: .c ${CXX_SUFFIXES} .o .pico .po

.c.o:
	@${RFPRINT.tg.compile}
	${CC} -c \
		${CFLAGS} ${CPPFLAGS} \
		${CFLAGS.${.IMPSRC:R}} \
		${CPPFLAGS.${.IMPSRC:R}} \
		-o ${.TARGET} ${.IMPSRC}

.c.pico:
	@${RFPRINT.tg.compile}
	${CC} -c ${CFLAGS_PIC} \
		${CFLAGS} ${CPPFLAGS} \
		${CFLAGS.${.IMPSRC:R}} \
		${CPPFLAGS.${.IMPSRC:R}} \
		-o ${.TARGET} ${.IMPSRC}

.c.po:
	@${RFPRINT.tg.compile}
	${CC} -c ${CFLAGS_PROF} \
		${CFLAGS} ${CPPFLAGS} \
		${CFLAGS.${.IMPSRC:R}} \
		${CPPFLAGS.${.IMPSRC:R}} \
		-o ${.TARGET} ${.IMPSRC}

.for i in ${CXX_SUFFIXES}
$i.o:
	@${RFPRINT.tg.compile}
	${CXX} -c \
		${CXXFLAGS} ${CPPFLAGS} \
		${CXXFLAGS.${.IMPSRC:R}} \
		${CPPFLAGS.${.IMPSRC:R}} \
		-o ${.TARGET} ${.IMPSRC}

$i.pico:
	@${RFPRINT.tg.compile}
	${CXX} -c ${CFLAGS_PIC} \
		${CXXFLAGS} ${CPPFLAGS} \
		${CXXFLAGS.${.IMPSRC:R}} \
		${CPPFLAGS.${.IMPSRC:R}} \
		-o ${.TARGET} ${.IMPSRC}

$i.po:
	@${RFPRINT.tg.compile}
	${CXX} -c ${CFLAGS_PROF} \
		${CXXFLAGS} ${CPPFLAGS} \
		${CXXFLAGS.${.IMPSRC:R}} \
		${CPPFLAGS.${.IMPSRC:R}} \
		-o ${.TARGET} ${.IMPSRC}
.endfor

.endif # _RF_SYS_MK_
