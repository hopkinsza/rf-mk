#
# Generate configs, typically to be used before `all' target.
#

.if !defined(_RF_CONF_MK_)
_RF_CONF_MK_ = 1

RFCONF.autodep ?= no

.if !empty(RFCONF.h)

#
# Build variable RFCONF.h.cmd, which contains shell commands to create the file.
#

RFCONF.h.cmd = echo '\#ifndef _RF_CONF_H_'; \
	echo '\#define _RF_CONF_H_'; \
	echo '';

.for i in $(PREFIXDIRS)
RFCONF.h.cmd += echo '\#define $i "$($i)"';
.endfor

RFCONF.h.cmd += echo ''; \
	echo '\#endif // _RF_CONF_H_';

#
# now commands for generating the config
#

$(RFCONF.h):
	@$(RFPRINT) 'create $(.TARGET)'
	@exec >$(.TARGET); $(RFCONF.h.cmd)

CLEANFILES := $(CLEANFILES) $(RFCONF.h)

#
# Optionally have all .o files depend on this config,
# if you don't want to specify manually.
#

.if $(RFCONF.h.autodep:U$(RFCONF.autodep)) == yes
.  for o in $(SRCS:.c=.o)
$o: $(RFCONF.h)
.  endfor
.endif

.endif

.endif # _RF_CONF_MK_
