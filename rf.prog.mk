.include <rf.init.mk>

#
# PROG -> PROGS conversion if necessary.
#

.if defined(PROG) && defined(PROGS)
.  error "cannot have both PROG and PROGS defined"
.endif

.if defined(PROG)
PROGS = $(PROG)
# these are the variables for which VAR.prog does not default to VAR.
.  if defined(PROGNAME)
PROGNAME.$(PROG) = $(PROGNAME)
.  endif
.  if defined(SRCS)
SRCS.$(PROG) = $(SRCS)
.  endif
.endif

#
# Flags and options.
#
# TODO: CXX support
# TODO: incs

# # MK* option
# .if $(MKDEBUG:Uno) != "no"
# CFLAGS += -g
# .endif

# for historical reasons
CFLAGS += $(COPTS)

#
# Add rules to build each program.
#

.for p in $(PROGS)
CLEANFILES := $(CLEANFILES) $p

SRCS.$p ?= $p.c
PROGNAME.$p ?= $p

BINDIR.$p ?= $(BINDIR)

# Loop through SRCS to build objects.
# s -> src
# o -> object (.o suffix)
_OBJS.$p =
.  for s in $(SRCS.$p)
.    if $(s:M*.h)
.      error "no headers allowed in SRCS"
.    endif
o := $(s:R:S/$/.o/)
CLEANFILES := $(CLEANFILES) $o
_OBJS.$p := $(_OBJS.$p) $o
.  endfor

# Final linking.
# PROGNAME, LDSTATIC, LDFLAGS, and LDADD can be overidden per-program.
$p: $(_OBJS.$p)
	$(CC) $(LDSTATIC.$p:U$(LDSTATIC)) \
		$(LDFLAGS.$p:U$(LDFLAGS)) \
		-o $(.TARGET) $(.ALLSRC) \
		$(LDADD.$p:U$(LDADD))

realall: $p

.endfor

#
# Installation.
#

realinstall: proginstall
proginstall: .PHONY

.for f in $(PROGS)

_DIR :=  $(BINDIR.$f:U$(BINDIR))
_NAME := $(PROGNAME.$f:U$(PROGNAME:U$(f)))
_PATH := $(DESTDIR)$(_DIR)/$(_NAME)

proginstall: $(_PATH)
.PRECIOUS: $(_PATH)

$(_PATH): $f __proginstall

.endfor

.include <rf.clean.mk>
