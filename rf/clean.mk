#
# This file is self-contained and doesn't actually need <rf/init.mk>.
#

.if !defined(_RF_CLEAN_MK_)
_RF_CLEAN_MK_ = 1

clean:
	rm -f ${CLEANFILES}

cleandir:
	rm -f ${CLEANDIRFILES}

.endif # _RF_CLEAN_MK_
