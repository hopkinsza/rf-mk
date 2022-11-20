.include <rf/init.mk>

FILESOWN ?= $(BINOWN)
FILESGRP ?= $(BINGRP)
FILESMODE ?= $(NONBINMODE)

FILESDIR ?= $(BINDIR)

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

.for f in $(FILES)

b := $(FILESBUILD.$f:U$(FILESBUILD))

.  if $b != no
filesall: $f
CLEANFILES := $(CLEANFILES) $f
.  endif

.endfor

#
# Installation.
#

.for f in $(FILES)

_DIR := $(FILESDIR.$f:U$(FILESDIR))
_NAME := $(FILESNAME.$f:U$(FILESNAME:U$(f:T)))
_PATH := $(DESTDIR)$(_DIR)/$(_NAME)

filesinstall: $(_PATH)
.PRECIOUS: $(_PATH)

# Files can be in a subdir.
# You can use a slash in a variable name like FILESOWN.files/file=root.
$(_PATH): $f
	$(INSTALL_FILE) \
		-o $(FILESOWN.$(.ALLSRC):U$(FILESOWN)) \
		-g $(FILESGRP.$(.ALLSRC):U$(FILESGRP)) \
		-m $(FILESMODE.$(.ALLSRC):U$(FILESMODE)) \
		$(.ALLSRC) $(.TARGET)

.endfor
