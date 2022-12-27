rf-mk
=====

`rf-mk` is a build system for software packages,
primarily targeting C.

Technically, it is a set of include files for (Net)BSD `make`
or the portable, cross-platform version of it called `bmake`,
in the spirit of the traditional `4.4BSD` files.
There may be an effort in the future to make the files portable to OpenBSD `make` too.

BSD-style make include files have been building BSD(s) for decades.
They are easy to write and generally do exactly what you want by default.
There are multiple divergent implementations out there with varying scope,
complexity, and portability goals.

I thought I could make one that's simple, clean, and with the features I want
to build my projects with minimal fuss.

Note that all examples use the command `make`;
you may need to substitute this for `bmake` depending on your setup.

Basic Usage
-----

See `examples/prog/simple/`.

It simply has the following `Makefile`:

```make
PROG = main
NOMAN =

.include <rf/prog.mk>
```

You can run `make` and it will create a program `main`.
Even though no list of sources was specified,
it defaulted to `main.c`.
Try `make -n install` to show what commands would be ran if you attempted to install.
To preview prefix support, you can also try `make -n install PREFIX=/opt`.
`make clean` to remove the built files.

Note that you need the line `NOMAN =`,
otherwise `<rf/prog.mk>` would give it a default of `main.1`.
You could also just define `MAN` to be empty, e.g. `MAN =`,
but defining `NOMAN` is traditional.
Harassing you for not having a man page has been a feature since `4.4BSD`!

More Sources
------------

See `examples/prog/multisrc/`.

The variable `SRCS` was used to override the default of `main.c`.

Theory
------

To understand the next sections, it is best to understand some compilation basics.

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

Note that there is a 1:1 correspondence between a `.c` file
and its corresponding `.i`, `.s`, and `.o` files.
In fact, steps 1-3 are typically done in a single step with `cc -c`,
which can take you straight from `.c` to `.o` while doing the other steps
behind the scenes.
(This is also why messing up and putting something that should be `CPPFLAGS`
into `CFLAGS` or similar often still works).

Multiple Programs
-----------------

See `examples/progs/simple/`.

If you want to link up multiple programs,
simply use the variable `PROGS` instead of `PROG`,
and generally use the *per-program* versions of variables.

The point of this is to have multiple closely related programs that share `.o` files.
The linker is called once for each program to link up.

Examples:

```make
#
# This creates two programs: alpha and bravo.
# Their sources default to: alpha.c and bravo.c.
#

PROGS = alpha bravo
NOMAN =

.include <rf/prog.mk>
```

```make
#
# This creates two identical programs made from alpha.c and util.c.
#

PROGS = alpha bravo
SRCS = alpha.c util.c
NOMAN =

.include <rf/prog.mk>
```

Well, that's not very useful...
`SRCS` has overridden the default value for both `alpha` and `bravo`.
What you need is to use the *per-program* variant of `SRCS`:

```make
#
# alpha needs util.c, but bravo does not.
#

PROGS = alpha bravo
SRCS.alpha = alpha.c util.c
NOMAN =

.include <rf/prog.mk>
```

Compilation/Linking Flags
-------------------------

See `examples/prog/curses/`.
To build, you will need development files for a `curses` library implementation,
e.g. package `libncurses-dev` on debian.

The following variables are available for preprocessing/compilation:

- `CPPFLAGS`: flags to the C preprocessor
- `CFLAGS`: flags to the C compiler

They have per-file variants to specify additional options on a per-file basis.
For example, to define the macro DEBUG for only `main.c`: `CPPFLAGS.main = -DDEBUG`.

Linking is always done as its own stage in `rf-mk`.
This way, if you change one file, you need only recompile its `.o`,
then link up the program --
avoiding the need to recompile unchanged files.

The following variables are available for linking:

- `LDFLAGS`: flags to the linker
- `LDADD`: additional linker objects, typically libraries
  - To link with the utility and curses libraries: `LDADD += -lutil -lcurses`

They have per-prog variants to specify additional options on a per-program basis.
If you are just using `PROG`, you never need to use per-prog variants of anything,
just use the generic `LDADD`, etc.

PKG and PREFIX support
----------------------

`rf-mk` is intended for building software packages.
A package has a name `PKG`, which is theoretically globally unique,
and a version number `VER`.

You can install to a specific `PREFIX`, by default `/usr/local`.
There are actually three main directories to install to and/or use,
all of which have their default value set in terms of `PREFIX`:

- `LOCALBASE` for static files
- `ETCBASE` for config files
- `VARBASE` for dynamic (variable) files

There are more specific directories for specific purposes --
see `init/pkg.mk` in the man page for the full list.

The `install` target will install into `PREFIX` automatically.
However, it is extremely useful to pass these variables to the build so
your program can look for files in the right place.
This is what `rf/conf.mk` is for.

All `rf/conf.mk` really does is dump `rf-mk` variables into a file.
Currently, this can only be a `.h` C header file,
but other styles may be supported in the future.

Set `CONF.h = yes` to gain the capability to generate the file `rfconf.h`.
You can then make the appropriate `.o` files depend on `rfconf.h`,
and it will be generated.
Alternatively, set `CONF.autodep = yes` to have every `.o` depend on it automatically.

See `examples/pkg/*`.

Note that `rfconf.h` is just a dump of `rf-mk` variables.
You can get inconsistencies between what the code sees as `PREFIX`
and where you actually installed to if you're not careful:

```
$ make
(-> generates rfconf.h with PREFIX=/usr/local, then compiles C code using it)
$ make PREFIX=/opt install
(-> the program is already compiled, and it is installed to /opt/bin)
```

The solution is to make sure the variables are identical for build and installation.
If you change variables, you must run `make clean`.

Instead of needing to remember your configuration
and specifying it on the command line,
you can put variable assignments in `Makefile.local`,
which is included by `rf/init.mk`.
You must still run `make clean` after any changes though!

Installation
------------

You can use the include files as-is with `make`'s `-m` option
or the environment variable `MAKESYSPATH`.

Alternatively, install them to `/usr/share/mk` by running `./install.sh` as root.
To preview the commands that would be run, use `./install.sh -n`.

The man page `./rf-mk.7` has in-depth documentation.
You can view it with `man ./rf-mk.7`.
