#
# Include rf/init.mk and every rf/* file that would not cause conflicts.
#

.if !defined(_RF_ALL_MK_)
_RF_ALL_MK = 1

.include <rf/init.mk>

.include <rf/clean.mk>
.include <rf/conf.mk>
.include <rf/config.mk>
.include <rf/files.mk>
.include <rf/man.mk>
.include <rf/subdir.mk>

.endif # _RF_ALL_MK_
