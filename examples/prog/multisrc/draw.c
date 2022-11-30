#include <curses.h>

#include "extern.h"

void
draw()
{
	initscr();
	printw(HELLO ", world!");
	refresh();
	getch();
	endwin();
}
