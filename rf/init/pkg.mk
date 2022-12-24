#
# Set up PKGVARS and PREFIXVARS.
#

.if !defined(_RF_PKG_MK_)
_RF_PKG_MK_ = 1

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
# Handle PREFIX=/ and PREFIX=/usr.
#

# PREFIX=/ is actually faked.
# Almost everything lives under /usr, so just set PREFIX=/usr.
# But install programs to /bin and libraries to /lib.
.if ${PREFIX} == /
PREFIX = /usr
BINDIR ?= /bin
LIBDIR ?= /lib
.endif

# As for /usr, it is actually usable as a full PREFIX,
# just lacking ETCBASE and VARBASE.
.if ${PREFIX} == /usr
ETCBASE ?= /etc
VARBASE ?= /var
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
# LIBDATADIR: architecture-specific static data
# SHAREDIR: generic static data
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

.endif # _RF_PKG_MK_
