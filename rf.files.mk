.include <rf.init.mk>

FILESOWN ?= $(BINOWN)
FILESGRP ?= $(BINGRP)
FILESMODE ?= $(NONBINMODE)

FILESDIR ?= $(BINDIR)

#
# Hook into realinstall from <rf.targ.mk>.
#
# TODO: add `realall: files-build' later
# maybe configfiles
# might change back to filesinstall

realinstall: filesinstall
filesinstall: .PHONY

#
# file installations
#

.for f in $(FILES:O:u)

_DIR := $(FILESDIR.$f:U$(FILESDIR))
_NAME := $(FILESNAME.$f:U$(FILESNAME:U$(f:T)))
_PATH := $(DESTDIR)$(_DIR)/$(_NAME)

filesinstall: $(_PATH)
.PRECIOUS: $(_PATH)

$(_PATH): $f __fileinstall

.endfor
