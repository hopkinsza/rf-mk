#
# Generate configs, typically to be used before `all' target.
#

.if !defined(_RF_INIT_MK_)
.  include <rf/init.mk>
.endif

.if !defined(_RF_CONF_MK_)
_RF_CONF_MK_ = 1

# Try to automatically make files depend on the generated configs.
RFCONF.autodep ?= no

# What variables to pass to the generated configs.
RFCONF.vars ?= ${PKGVARS} ${PREFIXVARS}

####
#### RFCONF.h
####

RFCONF.h ?= no
RFCONF.h.autodep ?= ${RFCONF.autodep}
RFCONF.h.file ?= rfconf.h
RFCONF.h.vars ?= ${RFCONF.vars}

.if "${RFCONF.h}" == yes

#
# Build variable RFCONF.h.cmd, which contains shell commands to create the file.
#

RFCONF.h.cmd = echo '\#ifndef _RF_CONF_H_'; \
	echo '\#define _RF_CONF_H_'; \
	echo '';

.for i in ${RFCONF.h.vars}
RFCONF.h.cmd += echo '\#define $i "${$i}"';
.endfor

RFCONF.h.cmd += echo ''; \
	echo '\#endif // _RF_CONF_H_';

#
# now commands for generating the config
#

${RFCONF.h.file}:
	@${RFPRINT} 'create ${.TARGET}'
	@exec >${.TARGET}; ${RFCONF.h.cmd}

CLEANFILES := ${CLEANFILES} ${RFCONF.h.file}

.endif

.endif # _RF_CONF_MK_
