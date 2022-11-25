#
# Include rf/init.mk and every rf/* file that would not cause conflicts.
#

.if !defined(_RF_ALL_MK_)
_RF_ALL_MK_ = 1

.include <rf/init.mk>

.include <rf/cfiles.mk>
.include <rf/clean.mk>
.include <rf/conf.mk>
.include <rf/files.mk>
.include <rf/man.mk>
.include <rf/subdir.mk>

.endif # _RF_ALL_MK_
