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

exec $make -m . -f Install.mk "$@" install
