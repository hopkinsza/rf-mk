#
# Include mk.conf and ../Makefile.inc.
# Include other initialization files.
#

.if !defined(_RF_INIT_MK_)
_RF_INIT_MK = 1

.-include "$(.CURDIR)/Makefile.local"
.-include "$(.CURDIR)/../Makefile.inc"

MAKECONF ?= /etc/rf-mk.conf
.-include "$(MAKECONF)"

.include <rfi.sys.mk>
.include <rfi.targ.mk>

.include <rfi.own.mk>

.include <rfi.clean.mk>
.include <rfi.bconf.mk>

.endif # _RF_INIT_MK_
