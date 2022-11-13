.if !defined(_RF_CLEAN_MK_)

clean:
	rm -f $(CLEANFILES)

cleandir:
	rm -f $(CLEANDIRFILES)

.endif # _RF_CLEAN_MK_
