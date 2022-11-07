#
# Ensure existence of default targets.
#

.if !defined(_RF_TARG_MK_)
_RF_TARG_MK_ = 1

# TODO: tags
TARGETS += all \
	clean cleandir \
	install

.for t in $(TARGETS)
$t: .PHONY
.  for i in before$t real$t after$t
$i: .PHONY
.  endfor
$t: before$t real$t after$t
.ORDER: before$t real$t after$t
.endfor

#
# cleandir depends on clean.
#

beforecleandir: clean

#
# If no targets given on command line, default to all.
#

.MAIN: all

.endif # _RF_TARG_MK_
