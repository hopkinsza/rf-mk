#
# conf.mk is included first because prog.mk needs to know whether to add
# RFCONF.h.autodep support.
#
# prog.mk is then included before everything else because it sets a default
# value for the MAN variable.
#

.include <rf/conf.mk>
.include <rf/src/prog.mk>
.include <rf/all.mk>
