.if !defined(_RF_USE_MK_)
_RF_USE_MK_ = 1

# files can be in a subdir, e.g. `files/installme', hence :T
__fileinstall: .USE
	$(INSTALL_FILE) \
	-o $(FILESOWN.$(.ALLSRC:T):U$(FILESOWN)) \
	-g $(FILESGRP.$(.ALLSRC:T):U$(FILESGRP)) \
	-m $(FILESMODE.$(.ALLSRC:T):U$(FILESMODE)) \
	$(.ALLSRC) $(.TARGET)

__proginstall: .USE
	$(INSTALL_FILE) \
	-o $(BINOWN.$(.ALLSRC):U$(BINOWN)) \
	-g $(BINGRP.$(.ALLSRC):U$(BINGRP)) \
	-m $(BINMODE.$(.ALLSRC):U$(BINMODE)) \
	$(.ALLSRC) $(.TARGET)

.endif # _RF_USE_MK_
