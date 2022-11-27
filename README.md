rf-mk
=====

A set of include files for (Net)BSD `make`
or the portable, cross-platform version of it called `bmake`,
in the spirit of the traditional `4.4BSD` files.
There may be an effort in the future to make the files portable to OpenBSD `make` too.

BSD-style make include files have been building BSD(s) for decades.
They are easy to write and generally do exactly what you want by default.
There are multiple divergent implementations out there with varying scope,
complexity, and portability goals.

I thought I could make one that's simple, clean, and with the features I want
to build my projects with minimal fuss.


Basic Usage
-----

Given the following files in an empty directory...

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
MAN =

.include <rf/prog.mk>
```

You can run `bmake` and it will create a program `main`.
Even though no list of sources was specified,
it defaulted to `main.c`
Try `bmake -n install` to show what commands would be ran if you attempted to install.

Note that you need the line `MAN =`,
otherwise `<rf/prog.mk>` would give it a default of `main.1`.
Harassing you for not having a man page has been a feature since `4.4BSD`!

More Sources
------------

Given...

```c
// FILE: main.c

#include "extern.h"

int
main()
{
	f();
}
```

```c
// FILE: util.c

#include <stdio.h>

#include "extern.h"

void
f()
{
	printf("hello from f()\n");
}
```

```c
// FILE: extern.h

#ifndef _EXTERN_H_

void f();

#endif // _EXTERN_H_
```

```make
PROG = main
SRCS = main.c util.c
MAN =

.include <rf/prog.mk>
```

It works just as well.

- You can change the name to *install* the program as with `PROGNAME`.
- Flags to the linker (technically passed to `${CC}` during linking)
can be specified with `LDFLAGS`.
- Additional loader objects can be specified with `LDADD` --
typically used for libraries.
  - To link with the utility and curses libraries: `LDADD += -lutil -lcurses`

Multiple Programs
-----------------

The traditional `4.4BSD` include files were designed to build one program per
source directory.
Most modern implementations have solved this limitation,
and `rf-mk` is no exception.

Getting to an executable C program from the source `.c` files
is performed in multiple steps:

1. Preprocessing
  - `cpp(1)` or `cc -E`, taking care of `#define` directives and macros
  - `.c` -> `.i`
2. Compilation Proper
  - `cc -S`, turning preprocessed source code into assembly
  - `.i` -> `.s`
3. Assembly
  - `as(1)` or `cc -c`, turning assembly into an object file
  - `.s` -> `.o`
4. Linking
  - `ld(1)` or `cc`, linking object files together into an executable
  - one or multiple `.o` files -> executable

In `rf-mk`,
steps 1-3 are typically performed in a single step with `cc -c`.
This simply uses a `make` suffix rule because
there is a 1:1 correspondence between a `.c` file and its generated `.o` file.
This leaves us with `.o` files that can actually be shared by multiple programs,
you just have to link each one separately.

If you want to link up multiple programs,
use the variable `PROGS` instead of `PROG`,
and generally use the "prog-specific" versions of variables.

Examples:

```make
#
# This creates two programs: alpha and bravo.
# Their sources default to: alpha.c and bravo.c.
#

PROGS = alpha bravo
MAN =

.include <rf/prog.mk>
```

```make
#
# This creates two identical programs made from alpha.c and util.c.
#

PROGS = alpha bravo
SRCS = alpha.c util.c
MAN =

.include <rf/prog.mk>
```

Well, that doesn't seem very useful...
What you need is to use the *per-program* variant of `SRCS`:

```make
#
# alpha needs util.c, but bravo does not.
#

PROGS = alpha bravo
SRCS.alpha = alpha.c util.c
# the following line is not needed since it's still the default
#SRCS.bravo = bravo.c
MAN =

.include <rf/prog.mk>
```

Adding some flags:

```make
PROGS = alpha bravo
SRCS.alpha = alpha.c util.c
MAN =

# both alpha and bravo should link with -lutil
LDADD = -lutil

# only alpha needs -lcurses
LDADD.alpha = -lcurses

.include <rf/prog.mk>
```

Essentially, you have the generic variables like `SRCS` and `LDADD`,
and the specific ones like `SRCS.prog` and `LDADD.prog`.
Sometimes the specific variable will *override* the generic variable, like `SRCS`,
and sometimes it will be used *in addition to* the generic variable, like `LDADD`.
See the man page for the behavior of specific variables.
If neither the specific nor the generic variable is defined,
it will default to something sensible.

Compilation
-----------

- `CFLAGS` for C compilation
- `CPPFLAGS` for C preprocessing

These have per-file variants.

PREFIX support
--------------

`rf-mk` has built-in `PREFIX` support
and is opinionated about what directories your program should use.
See `prefix.mk` in the man page for the full list.

Installation
------------

You can use the include files as-is with `make`'s `-m` option
or the environment variable `MAKESYSPATH`.

Alternatively, install them to `/usr/share/mk` by running `./install.sh` as root.

The man page `./rf-mk.7` has in-depth documentation.
You can view it with `man ./rf-mk.7`.
