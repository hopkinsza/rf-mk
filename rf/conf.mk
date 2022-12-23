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

.if ${RFCONF.h} == yes

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

####
#### RFCONF.sub
####

RFCONF.sub ?=
RFCONF.sub.vars ?= ${RFCONF.vars}

.if !empty(RFCONF.sub)

# generate the simple sed command
RFCONF.sub.sedcmd = sed
.  for i in ${RFCONF.sub.vars}
RFCONF.sub.sedcmd += -e 's,RF_$i,${$i},g'
.  endfor

.  for f in ${RFCONF.sub}

# Due to the possibility of accidentally cleaning a non-generated file,
# we set the permissions of these generated files to 444.
# If one of the files already exists and does not have permissions of 444,
# give an error and abort.
x != [ -e '$f' ] && echo yes || echo no
.    if "$x" == yes
# check perms... should be 444
y != ls -l '$f' | cut -d' ' -f1
.      if "$y" != "-r--r--r--"
.        error file '$f' already exists and does not seem to be generated, not overwriting
.      endif
.    endif

$f: sub_$f
	@${RFPRINT} 'create ${.TARGET}'
	@rm -f ${.TARGET}
	@${RFCONF.sub.sedcmd} ${.ALLSRC} >${.TARGET}
	@chmod 0444 ${.TARGET}

CLEANFILES := ${CLEANFILES} $f

.  endfor

.endif

.endif # _RF_CONF_MK_
