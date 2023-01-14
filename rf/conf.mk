#
# Generate configs, typically to be used before `all' target.
#

.if !defined(_RF_INIT_MK_)
.  include <rf/init.mk>
.endif

.if !defined(_RF_CONF_MK_)
_RF_CONF_MK_ = 1

# Try to automatically make files depend on the generated configs.
CONF.autodep ?= no

# What variables to pass to the generated configs.
CONF.vars ?= ${PKGVARS} ${PREFIXVARS}

####
#### CONF.h
####

CONF.h ?= no
CONF.h.autodep ?= ${CONF.autodep}
CONF.h.file ?= rfconf.h
CONF.h.vars ?= ${CONF.vars}

.if ${CONF.h} == yes

#
# Build variable CONF.h.cmd, which contains shell commands to create the file.
#

CONF.h.cmd = echo '\#ifndef _RF_CONF_H_'; \
	echo '\#define _RF_CONF_H_'; \
	echo '';

.for i in ${CONF.h.vars}
CONF.h.cmd += echo '\#define $i "${$i}"';
.endfor

CONF.h.cmd += echo ''; \
	echo '\#endif // _RF_CONF_H_';

#
# now commands for generating the config
#

${CONF.h.file}:
	@${RFPRINT.tg.create}
	@exec >${.TARGET}; ${CONF.h.cmd}

CLEANFILES := ${CLEANFILES} ${CONF.h.file}
.endif

####
#### CONF.sub
####

CONF.sub ?= yes
CONF.sub.vars ?= ${CONF.vars}

CONF.sub.var_prefix ?= RF_
CONF.sub.var_suffix ?=

.if ${CONF.sub} == yes

# generate the simple sed command
CONF.sub.sedcmd = sed
.  for i in ${CONF.sub.vars}
CONF.sub.sedcmd += -e 's,${CONF.sub.var_prefix}$i${CONF.sub.var_suffix},${$i},g'
.  endfor

# grab list of *.in files; full paths
i != ls ${.CURDIR}/*.in 2>/dev/null || true
.  if !empty(i:M*.in.in)
.    error a file has double .in suffix
.  endif

# now loop through each output file as $f ('.in' suffix stripped)
.  for f in ${i:T:C/.in$//}

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

$f: $f.in
	@${RFPRINT.tg.create}
	@rm -f ${.TARGET}
	@${CONF.sub.sedcmd} ${.ALLSRC} >${.TARGET}
	@chmod 0444 ${.TARGET}

CLEANFILES := ${CLEANFILES} $f

.  endfor

.endif

.endif # _RF_CONF_MK_
