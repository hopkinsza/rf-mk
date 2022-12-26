# try to get non-NetBSD makes to fail
x = b s d
.if ${x:O} != "b d s"
.  error old version or non-NetBSD make
.endif

FILES != find rf -type f

.for f in ${FILES}
FILESDIR.$f = /usr/share/mk/${f:H}
.endfor

.include <rf/files.mk>
