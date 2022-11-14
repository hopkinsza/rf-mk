.include <rf.init.mk>

CONFIGOWN ?= $(BINOWN)
CONFIGGRP ?= $(BINGRP)
CONFIGMODE ?= $(EDITMODE)

CONFIGBUILD ?= no

RFCONFIG.exampleinstall ?= yes

RFCONFIG.examplesdir ?= $(EXAMPLESDIR)
RFCONFIG.etcdir ?= $(ETCDIR)

#
# Hook into targets from <rf.targ.mk>.
#

all: configall
configall: .PHONY

install: configexampleinstall
configexampleinstall: .PHONY

configinstall: .PHONY

#
# Build.
#

.for f in $(CONFIGS)

b := $(CONFIGBUILD.$f:U$(CONFIGBUILD))

.  if $b != no
configall: $f
CLEANFILES := $(CLEANFILES) $f
.  endif

.endfor

#
# Install.
#

.for f in $(CONFIGS)

#
# configexampleinstall
#

.  if $(RFCONFIG.exampleinstall) != no

_DIR := $(RFCONFIG.examplesdir)
_NAME := $(CONFIGNAME.$f:U$(CONFIGNAME:U$(f:T)))
_PATH := $(DESTDIR)$(_DIR)/$(_NAME)

configexampleinstall: $(_PATH)
.PRECIOUS: $(_PATH)

$(_PATH): $f
	$(INSTALL_FILE) \
		-o $(CONFIGOWN.$(.ALLSRC):U$(CONFIGOWN)) \
		-g $(CONFIGGRP.$(.ALLSRC):U$(CONFIGGRP)) \
		-m $(CONFIGMODE.$(.ALLSRC):U$(CONFIGMODE)) \
		$(.ALLSRC) $(.TARGET)

.  endif

#
# configinstall
#

_DIR := $(RFCONFIG.etcdir)
_NAME := $(CONFIGNAME.$f:U$(CONFIGNAME:U$(f:T)))
_PATH := $(DESTDIR)$(_DIR)/$(_NAME)

configinstall: $(_PATH)
.PRECIOUS: $(_PATH)

$(_PATH): $f
	$(INSTALL_FILE) \
		-o $(CONFIGOWN.$(.ALLSRC):U$(CONFIGOWN)) \
		-g $(CONFIGGRP.$(.ALLSRC):U$(CONFIGGRP)) \
		-m $(CONFIGMODE.$(.ALLSRC):U$(CONFIGMODE)) \
		$(.ALLSRC) $(.TARGET)

.endfor
