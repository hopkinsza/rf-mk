#
# Ensure existence of default targets.
#

.if !defined(_RF_TARG_MK_)
_RF_TARG_MK_ = 1

# TODO: tags
TARGETS += all \
	clean cleandir \
	includes \
	install

.for t in $(TARGETS)
.  for i in before$t real$t after$t
$i: .PHONY
.  endfor
$t: before$t real$t after$t
.ORDER: before$t real$t after$t
.endfor

#
# Set up the install target to allow beforeinstall and afterinstall hooks.
# Installation is a special case because it modifies outside of the source tree.
#
#install: beforeinstall .WAIT realinstall .WAIT afterinstall

#
# If no targets given on command line, default to all.
#

.MAIN: all

.endif # _RF_TARG_MK_
