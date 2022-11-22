#!/bin/sh

# sanity checks
if [ "`id -u`" != 0 ]; then
	echo 'must run as root' >&2
	exit 1
fi
if [ ! -e ./install.sh ]; then
	echo 'please run as ./install.sh' >&2
	exit 1
fi

usage() {
	cat <<-EOF >&2
	usage: ./install.sh [-f]
	    -f: force installation over existing
	EOF
	exit 64
}

#
# Options
#

force=no

while getopts 'f' f; do
	case $f in
	f)
		force=yes
		;;
	*)
		usage
		;;
	esac
done

umask 022

if [ -d /usr/share/mk/rf ]; then
	if [ "$force" = yes ]; then
		rm -rf /usr/share/mk/rf
	else
		echo 'directory /usr/share/mk/rf already exists,' \
			'use -f to install over it' >&2
		exit 1
	fi
fi

#
# Create /usr/share/mk if necessary
#

if [ ! -d /usr/share/mk ]; then
	install -d -m 755 /usr/share/mk
fi

#
# Install
#

cp -R rf /usr/share/mk/rf
