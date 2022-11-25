#
# Include mk.conf and ../Makefile.inc.
# Include other initialization files.
#

.if !defined(_RF_INIT_MK_)
_RF_INIT_MK_ = 1

.-include "${.CURDIR}/Makefile.local"
.-include "${.CURDIR}/../Makefile.inc"

MAKECONF ?= /etc/rf-mk.conf
.-include "${MAKECONF}"

.include <rf/init/own.mk>
.include <rf/init/prefix.mk>
.include <rf/init/sys.mk>
.include <rf/init/targ.mk>

.endif # _RF_INIT_MK_
