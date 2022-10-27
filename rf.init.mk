#
# Include mk.conf and ../Makefile.inc.
# Include other initialization files.
#

.if !defined(_RF_INIT_MK_)
_RF_INIT_MK = 1

.-include "$(.CURDIR)/../Makefile.inc"

MAKECONF ?= /etc/rf-mk.conf
.-include "$(MAKECONF)"

.include <rf.targ.mk>
.include <rf.own.mk>
.include <rf.use.mk>
.include <rf.sys.mk>

.endif # _RF_INIT_MK_
