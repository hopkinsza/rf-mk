#!/bin/sh

if [ ! -e ./install.sh ]; then
	echo 'please run as ./install.sh' >&2
	exit 1
fi

if command -v bmake >/dev/null 2>&1; then
	make=bmake
else
	make=make
fi

rm -rf /usr/share/mk/rf
exec $make -m /usr/share/mk -m . -f Install.mk "$@" install
