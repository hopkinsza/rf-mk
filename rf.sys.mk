#
# Implicit rules and variables to configure them.
#

.if !defined(_RF_SYS_MK_)
_RF_SYS_MK_ = 1

#
# MK* options.
#

.if $(MKDEBUG:Uno) != "no"
CFLAGS += -g
.endif

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
.SUFFIXES: .c $(CXX_SUFFIXES) .o .pico .po

.c.o:
	$(CC) -c \
		$(CFLAGS) $(CPPFLAGS) \
		$(CFLAGS.$(.ALLSRC:R)) \
		$(CPPFLAGS.$(.ALLSRC:R)) \
		-o $(.TARGET) $(.ALLSRC)

.c.pico:
	$(CC) -c $(CFLAGS_PIC) \
		$(CFLAGS) $(CPPFLAGS) \
		$(CFLAGS.$(.ALLSRC:R)) \
		$(CPPFLAGS.$(.ALLSRC:R)) \
		-o $(.TARGET) $(.ALLSRC)

.c.po:
	$(CC) -c $(CFLAGS_PROF) \
		$(CFLAGS) $(CPPFLAGS) \
		$(CFLAGS.$(.ALLSRC:R)) \
		$(CPPFLAGS.$(.ALLSRC:R)) \
		-o $(.TARGET) $(.ALLSRC)

.for i in $(CXX_SUFFIXES)
$i.o:
	$(CXX) -c \
		$(CXXFLAGS) $(CPPFLAGS) \
		$(CXXFLAGS.$(.ALLSRC:R)) \
		$(CPPFLAGS.$(.ALLSRC:R)) \
		-o $(.TARGET) $(.ALLSRC)

$i.pico:
	$(CXX) -c $(CFLAGS_PIC) \
		$(CXXFLAGS) $(CPPFLAGS) \
		$(CXXFLAGS.$(.ALLSRC:R)) \
		$(CPPFLAGS.$(.ALLSRC:R)) \
		-o $(.TARGET) $(.ALLSRC)

$i.po:
	$(CXX) -c $(CFLAGS_PROF) \
		$(CXXFLAGS) $(CPPFLAGS) \
		$(CXXFLAGS.$(.ALLSRC:R)) \
		$(CPPFLAGS.$(.ALLSRC:R)) \
		-o $(.TARGET) $(.ALLSRC)
.endfor

.endif # _RF_SYS_MK_
