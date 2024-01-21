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
// Extended
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

// Return error codes
OK                   :: tb.OK  
ERR                  :: tb.ERR
ERR_NEED_MORE        :: tb.ERR_NEED_MORE
ERR_INIT_ALREADY     :: tb.ERR_INIT_ALREADY
ERR_INIT_OPEN        :: tb.ERR_INIT_OPEN
ERR_MEM              :: tb.ERR_MEM
ERR_NO_EVENT         :: tb.ERR_NO_EVENT
ERR_NO_TERM          :: tb.ERR_NO_TERM
ERR_NOT_INIT         :: tb.ERR_NOT_INIT
ERR_OUT_OF_BOUNDS    :: tb.ERR_OUT_OF_BOUNDS
ERR_READ             :: tb.ERR_READ
ERR_RESIZE_IOCTL     :: tb.ERR_RESIZE_IOCTL
ERR_RESIZE_PIPE      :: tb.ERR_RESIZE_PIPE
ERR_RESIZE_SIGACTION :: tb.ERR_RESIZE_SIGACTION
ERR_POLL             :: tb.ERR_POLL
ERR_TCGETATTR        :: tb.ERR_TCGETATTR
ERR_TCSETATTR        :: tb.ERR_TCSETATTR
ERR_UNSUPPORTED_TERM :: tb.ERR_UNSUPPORTED_TERM
ERR_RESIZE_WRITE     :: tb.ERR_RESIZE_WRITE
ERR_RESIZE_POLL      :: tb.ERR_RESIZE_POLL
ERR_RESIZE_READ      :: tb.ERR_RESIZE_READ
ERR_RESIZE_SSCANF    :: tb.ERR_RESIZE_SSCANF
ERR_CAP_COLLISION    :: tb.ERR_CAP_COLLISION
	
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
