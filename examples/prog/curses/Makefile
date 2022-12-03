PROG = main
SRCS = draw.c main.c
MAN =

# flags to the C compiler for every file
CFLAGS = -pipe
# flags to the C compiler for draw.c only
CFLAGS.draw = -O2

# flags to the C preprocessor for draw.c only
CPPFLAGS.draw = '-DHELLO="helloooo"'

# link with the curses library
LDADD = -lcurses

.include <rf/prog.mk>
