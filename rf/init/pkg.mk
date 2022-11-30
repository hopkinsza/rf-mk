#
# Set up PREFIXVARS.
#

.if !defined(_RF_PREFIX_MK_)
_RF_PREFIX_MK_ = 1

PREFIXVARS = PREFIX PKG

PREFIX ?= /usr/local

PKG ?= ${PROG:U${LIB}}
.if empty(PKG)
.  error PKG is not defined
.endif

#
# The three base directories to install to.
# LOCALBASE: static data/files
# ETCBASE: configuration files
# VARBASE: dynamic (variable) data/files
#

PREFIXVARS += LOCALBASE \
	ETCBASE \
	VARBASE

LOCALBASE ?=	${PREFIX}
ETCBASE ?=	${PREFIX}/etc
VARBASE ?=	${PREFIX}/var

#
# LOCALBASE traditional directories.
#

PREFIXVARS += BINDIR \
	INCDIR \
	LIBDIR \
	MANDIR

BINDIR ?=	${LOCALBASE}/bin
INCDIR ?=	${LOCALBASE}/include
LIBDIR ?=	${LOCALBASE}/lib
MANDIR ?=	${LOCALBASE}/share/man

#
# LOCALBASE additional directories.
#
# DOCDIR: misc documentation
# EXAMPLESDIR: usage examples
# LIBDATADIR: ?
# SHAREDIR: generic static data
# TODO: libdata vs share?
#

PREFIXVARS += DOCDIR \
	EXAMPLESDIR \
	LIBDATADIR \
	SHAREDIR

DOCDIR ?=	${LOCALBASE}/share/doc/${PKG}
EXAMPLESDIR ?=	${LOCALBASE}/share/examples/${PKG}
LIBDATADIR ?=	${LOCALBASE}/libdata/${PKG}
SHAREDIR ?=	${LOCALBASE}/share/${PKG}

#
# ETCBASE - one configuration file directory.
# Set it to ${ETCBASE}/${PKG} if there are many config files.
#

PREFIXVARS += ETCDIR

ETCDIR ?=	${ETCBASE}

#
# VARBASE - for variable runtime data.
#

PREFIXVARS += CACHEDIR \
	DBDIR \
	SPOOLDIR

CACHEDIR ?=	${VARBASE}/cache/${PKG}
DBDIR ?=	${VARBASE}/db/${PKG}
SPOOLDIR ?=	${VARBASE}/spool/${PKG}

.endif # _RF_PREFIX_MK_
