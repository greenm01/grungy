package ui

import "core:fmt"
import "core:os"
import "core:c"

import tb "../termbox2"

Color    :: tb.Attribute
Modifier :: tb.Attribute

// Normal mode colors
DEFAULT       :: tb.DEFAULT
BLACK         :: tb.BLACK
RED           :: tb.RED
GREEN         :: tb.GREEN
YELLOW        :: tb.YELLOW
BLUE          :: tb.BLUE
MAGENTA       :: tb.MAGENTA
CYAN          :: tb.CYAN
WHITE         :: tb.WHITE
DARK_GRAY     :: tb.DARK_GRAY
LIGHT_RED     :: tb.LIGHT_RED
LIGHT_GREEN   :: tb.LIGHT_GREEN
LIGHT_BLUE    :: tb.LIGHT_BLUE
LIGHT_MAGENTA :: tb.LIGHT_MAGENTA
LIGHT_CYAN    :: tb.LIGHT_CYAN
LIGHT_GRAY    :: tb.LIGHT_GRAY  

// Modifiers
MOD_CLEAR :: tb.MOD_CLEAR 
BOLD      :: tb.BOLD
UNDERLINE :: tb.UNDERLINE
REVERSE   :: tb.REVERSE
ITALIC    :: tb.ITALIC
BLINK     :: tb.BLINK
HI_BLACK  :: tb.HI_BLACK
BRIGHT    :: tb.BRIGHT
DIM       :: tb.DIM

init :: proc() -> int {

	ret := tb.init()

	if ret != 0 {
		fmt.printf("Termbox2 failed to initialize with code %d", ret)
		close()
		os.exit(1)
	}

	tb.set_input_mode(tb.INPUT_ESC)
	tb.set_output_mode(tb.OUTPUT_NORMAL)
	return int(ret)
}

close :: proc() {
	tb.shutdown()
}

terminal_dimensions :: proc() -> (width: int, height: int) {
	tb.present()
	return int(tb.width()), int(tb.height())
}

clear :: proc() {
	tb.clear()
}

present :: proc() {
	tb.present()
}

set_cell :: proc(x, y: int, ch: rune, fg, bg: Color) -> int {
	return int(tb.set_cell(i32(x), i32(y), u32(ch), u16(fg), u16(bg)))
}
