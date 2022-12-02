#
# Set up PKGVARS and PREFIXVARS.
#

.if !defined(_RF_PREFIX_MK_)
_RF_PREFIX_MK_ = 1

#
# PKGVARS.
#

PKGVARS = PKG VER PKGDIRNAME PKGDISTNAME

# just use a default -- may change in the future;
# for example, ${PROG:U${LIB}}
PKG ?= junkpkg

VER ?= 0

PKGDIRNAME ?= ${PKG}

PKGDISTNAME ?= ${PKG}-${VER}

#
# PREFIXVARS.
#

PREFIXVARS = PREFIX

PREFIX ?= /usr/local

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

DOCDIR ?=	${LOCALBASE}/share/doc/${PKGDIRNAME}
EXAMPLESDIR ?=	${LOCALBASE}/share/examples/${PKGDIRNAME}
LIBDATADIR ?=	${LOCALBASE}/libdata/${PKGDIRNAME}
SHAREDIR ?=	${LOCALBASE}/share/${PKGDIRNAME}

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

CACHEDIR ?=	${VARBASE}/cache/${PKGDIRNAME}
DBDIR ?=	${VARBASE}/db/${PKGDIRNAME}
SPOOLDIR ?=	${VARBASE}/spool/${PKGDIRNAME}

.endif # _RF_PREFIX_MK_
