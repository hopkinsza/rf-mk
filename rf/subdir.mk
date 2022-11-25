#
# A version of <bsd.subdir.mk> derived from netbsd.
#
# Allows .WAIT to be specified in $SUBDIRS for a simple dependency system that
# works with parallel builds.
#
# Does not currently look for ${dir}.${MACHINE}.
#

.if !defined(_RF_INIT_MK_)
.  include <rf/init.mk>
.endif

#
# Generate appropriate targets for descending into subdirs.
#
# For every target, generate a variable SUBDIR.targ.
# It contains a list of targets of the form dir,target (or special case .WAIT).
# Each of these will run MAKEDIRTARGET appropriately.
#

.for t in ${.TARGETS}

.  for d in ${SUBDIR}
.    if $d == ".WAIT"
SUBDIR.$t += .WAIT
.    else
# create a target specifically for this dir,target combination,
# and add it to the list
$d,$t: .PHONY .MAKE
	@${MAKEDIRTARGET} ${.TARGET:C/,[^,]*$//} ${.TARGET:C/.*,//}
SUBDIR.$t += $d,$t
.    endif
.  endfor

# notably skip the creation of intermediate `subdir-${targ}' target
$t: .PHONY ${SUBDIR.$t}

.endfor
