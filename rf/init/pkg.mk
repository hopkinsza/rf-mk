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

# Almost everything lives under /usr, so just set PREFIX=/usr.
.if ${PREFIX} == /
PREFIX = /usr
EXECBASE ?=
.endif

# As for /usr, it is actually usable as a full PREFIX,
# just lacking ETCBASE and VARBASE.
.if ${PREFIX} == /usr
ETCBASE ?= /etc
VARBASE ?= /var
.endif

#
# The four base directories to install to.
# EXECBASE: binaries and libraries
# FILEBASE: static data/files
# ETCBASE: configuration files
# VARBASE: dynamic (variable) data/files
#

PREFIXVARS += EXECBASE \
	FILEBASE \
	ETCBASE \
	VARBASE

EXECBASE ?=	${PREFIX}
FILEBASE ?=	${PREFIX}
ETCBASE ?=	${PREFIX}/etc
VARBASE ?=	${PREFIX}/var

#
# EXECBASE.
#

PREFIXVARS += BINDIR \
	SBINDIR \
	LIBDIR \
	LIBEXECDIR \
	LIBDATADIR

BINDIR ?=	${EXECBASE}/bin
SBINDIR ?=	${EXECBASE}/sbin
LIBDIR ?=	${EXECBASE}/lib
LIBEXECDIR ?=	${EXECBASE}/libexec/${PKGDIRNAME}
LIBDATADIR ?=	${EXECBASE}/libdata/${PKGDIRNAME}

#
# FILEBASE.
# INCDIR and MANDIR are traditional.
#
# DOCDIR: misc documentation
# EXAMPLESDIR: usage examples
# SHAREDIR: generic static data
#

PREFIXVARS += DOCDIR \
	EXAMPLESDIR \
	INCDIR \
	MANDIR \
	SHAREDIR

DOCDIR ?=	${FILEBASE}/share/doc/${PKGDIRNAME}
EXAMPLESDIR ?=	${FILEBASE}/share/examples/${PKGDIRNAME}
INCDIR ?=	${FILEBASE}/include
MANDIR ?=	${FILEBASE}/share/man
SHAREDIR ?=	${FILEBASE}/share/${PKGDIRNAME}

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
