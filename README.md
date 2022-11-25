rf-mk
=====

A set of include files for (Net)BSD `make`
or the portable, cross-platform version of it called `bmake`.
There may be an effort in the future to make the files portable to OpenBSD `make` too.

why?
----

BSD-style make include files have been building BSD(s) for decades.
They are easy to write and generally do exactly what you want by default.
There are multiple divergent implementations out there with varying scope,
complexity, and portability goals.

I thought I could make one that's simple, clean, and featureful
to build my projects with minimal configuration code.

`rf-mk` has built-in `PREFIX` support
and is opinionated about what directories your program should use.

usage
-----

```c
// FILE: main.c

#include <stdio.h>

int
main()
{
	printf("hi\n");
}
```

```make
# FILE: Makefile

PROG = main

.include <rf/prog.mk>
```

installation
------------

You can use them as-is with `make`'s `-m` option
or the environment variable `MAKESYSPATH`.

Alternatively, install them to `/usr/share/mk` by running `./install.sh` as root.

The man page `./rf-mk.7` has in-depth documentation.
You can view it with `man ./rf-mk.7`.
