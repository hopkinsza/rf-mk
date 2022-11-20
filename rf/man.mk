.include <rf/init.mk>

MANOWN ?= $(BINOWN)
MANGRP ?= $(BINGRP)
MANMODE ?= $(NONBINMODE)

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

.for f in $(MAN)

b := $(MANBUILD.$f:U$(MANBUILD))

.  if $b != no
manall: $f
CLEANFILES := $(CLEANFILES) $f
.  endif

.endfor

#
# Installation.
#

.for f in $(MAN)

# verify that it looks like a man page
.  if "$(f:C/^.+\.[0-9]$//)" != ""
.    error invalid man page: $f
.  endif

_MAN := $(f:R)
_SECT := $(f:E)

.  if !empty(MANSUBDIR)
_DIR := $(MANDIR)/$(MANSUBDIR)/man$(_SECT)
.  else
_DIR := $(MANDIR)/man$(_SECT)
.  endif

_NAME := $(MANNAME.$f:U$(MANNAME:U$(f:T)))

_PATH := $(DESTDIR)$(_DIR)/$(_NAME)

maninstall: $(_PATH)
.PRECIOUS: $(_PATH)

$(_PATH): $f
	$(INSTALL_FILE) \
		-o $(MANOWN.$(.ALLSRC):U$(MANOWN)) \
		-g $(MANGRP.$(.ALLSRC):U$(MANGRP)) \
		-m $(MANMODE.$(.ALLSRC):U$(MANMODE)) \
		$(.ALLSRC) $(.TARGET)

.endfor
