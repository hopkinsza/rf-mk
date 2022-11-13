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

.include <rf.own.mk>
.include <rf.sys.mk>
.include <rf.conf.mk>

.endif # _RF_INIT_MK_
