.if !defined(_RF_CLEAN_MK_)

realclean:
	rm -f $(CLEANFILES)

realcleandir:
	rm -f $(CLEANDIRFILES)

.endif # _RF_CLEAN_MK_
