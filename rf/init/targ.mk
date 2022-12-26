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

.for t in ${TARGETS}
$t: .PHONY
.endfor

cleandir: clean

# if no targets given on command line, default to all
.MAIN: all

.endif # _RF_TARG_MK_
