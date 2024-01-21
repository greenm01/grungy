package termbox2

import "core:c"

foreign import termbox2 "libtermbox2.a"

Input_Mode :: c.int
Output_Mode :: c.int
Event_Type :: c.uint8_t
Modifier :: c.uint8_t
Key :: c.uint16_t
Attribute :: c.uint64_t

/* Event types (tb_event.type) */
EVENT_KEY: Event_Type : 1
EVENT_RESIZE: Event_Type : 2
EVENT_MOUSE: Event_Type : 3

/* ASCII key constants (tb_event.key) */
KEY_CTRL_TI: Key : 0x00
KEY_CTRL_2: Key : 0x00 /* clash with 'CTRL_TILDE'     */
KEY_CTRL_SPACE: Key : 0x00
KEY_CTRL_A: Key : 0x01
KEY_CTRL_B: Key : 0x02
KEY_CTRL_C: Key : 0x03
KEY_CTRL_D: Key : 0x04
KEY_CTRL_E: Key : 0x05
KEY_CTRL_F: Key : 0x06
KEY_CTRL_G: Key : 0x07
KEY_BACKSPACE: Key : 0x08
KEY_CTRL_H: Key : 0x08 /* clash with 'CTRL_BACKSPACE' */
KEY_TAB: Key : 0x09
KEY_CTRL_I: Key : 0x09 /* clash with 'TAB'            */
KEY_CTRL_J: Key : 0x0a
KEY_CTRL_K: Key : 0x0b
KEY_CTRL_L: Key : 0x0c
KEY_ENTER: Key : 0x0d
KEY_CTRL_M: Key : 0x0d /* clash with 'ENTER'          */
KEY_CTRL_N: Key : 0x0e
KEY_CTRL_O: Key : 0x0f
KEY_CTRL_P: Key : 0x10
KEY_CTRL_Q: Key : 0x11
KEY_CTRL_R: Key : 0x12
KEY_CTRL_S: Key : 0x13
KEY_CTRL_T: Key : 0x14
KEY_CTRL_U: Key : 0x15
KEY_CTRL_V: Key : 0x16
KEY_CTRL_W: Key : 0x17
KEY_CTRL_X: Key : 0x18
KEY_CTRL_Y: Key : 0x19
KEY_CTRL_Z: Key : 0x1a
KEY_ESC: Key : 0x1b
KEY_CTRL_LSQ_BRACKET: Key : 0x1b /* clash with 'ESC'            */
KEY_CTRL_3: Key : 0x1b /* clash with 'ESC'            */
KEY_CTRL_4: Key : 0x1c
KEY_CTRL_BACKSLASH: Key : 0x1c /* clash with 'CTRL_4'         */
KEY_CTRL_5: Key : 0x1d
KEY_CTRL_RSQ_BRACKET: Key : 0x1d /* clash with 'CTRL_5'         */
KEY_CTRL_6: Key : 0x1e
KEY_CTRL_7: Key : 0x1f
KEY_CTRL_SLASH: Key : 0x1f /* clash with 'CTRL_7'         */
KEY_CTRL_UNDERSCORE: Key : 0x1f /* clash with 'CTRL_7'         */
KEY_SPACE: Key : 0x20
KEY_BACKSPACE2: Key : 0x7f
KEY_CTRL_8: Key : 0x7f /* clash with 'BACKSPACE2'     */

/* Terminal-dependent key constants (tb_event.key) and terminfo capabilities */
/* BEGIN codegen h */
/* Produced by ./codegen.sh on Thu, 13 Jul 2023 05:46:13 +0000 */
KEY_F1: Key : (0xffff - 0)
KEY_F2: Key : (0xffff - 1)
KEY_F3: Key : (0xffff - 2)
KEY_F4: Key : (0xffff - 3)
KEY_F5: Key : (0xffff - 4)
KEY_F6: Key : (0xffff - 5)
KEY_F7: Key : (0xffff - 6)
KEY_F8: Key : (0xffff - 7)
KEY_F9: Key : (0xffff - 8)
KEY_F10: Key : (0xffff - 9)
KEY_F11: Key : (0xffff - 10)
KEY_F12: Key : (0xffff - 11)
KEY_INSERT: Key : (0xffff - 12)
KEY_DELETE: Key : (0xffff - 13)
KEY_HOME: Key : (0xffff - 14)
KEY_END: Key : (0xffff - 15)
KEY_PGUP: Key : (0xffff - 16)
KEY_PGDN: Key : (0xffff - 17)
KEY_ARROW_UP: Key : (0xffff - 18)
KEY_ARROW_DOWN: Key : (0xffff - 19)
KEY_ARROW_LEFT: Key : (0xffff - 20)
KEY_ARROW_RIGHT: Key : (0xffff - 21)
KEY_BACK_TAB: Key : (0xffff - 22)

/* Mouse buttons */
MOUSE_LEFT: Key : (0xffff - 23)
MOUSE_RIGHT: Key : (0xffff - 24)
MOUSE_MIDDLE: Key : (0xffff - 25)
MOUSE_RELEASE: Key : (0xffff - 26)
MOUSE_WHEEL_UP: Key : (0xffff - 27)
MOUSE_WHEEL_DOWN: Key : (0xffff - 28)

/* Colors (numeric) and attributes (bitwise) (tb_cell.fg, tb_cell.bg) */
DEFAULT: Attribute : 0x0000
BLACK: Attribute : 0x0001
RED: Attribute : 0x0002
GREEN: Attribute : 0x0003
YELLOW: Attribute : 0x0004
BLUE: Attribute : 0x0005
MAGENTA: Attribute : 0x0006
CYAN: Attribute : 0x0007
WHITE: Attribute : 0x0008
DARK_GRAY: Attribute : 0x0009
LIGHT_RED: Attribute : 0x0010
LIGHT_GREEN: Attribute : 0x0011
LIGHT_BLUE: Attribute : 0x0012
LIGHT_MAGENTA: Attribute : 0x0013
LIGHT_CYAN: Attribute : 0x0014
LIGHT_GRAY: Attribute : 0x0015

MOD_CLEAR: Attribute : 0x0000
BOLD: Attribute : 0x0100
UNDERLINE: Attribute : 0x0200
REVERSE: Attribute : 0x0400
ITALIC: Attribute : 0x0800
BLINK: Attribute : 0x1000
HI_BLACK: Attribute : 0x2000
BRIGHT: Attribute : 0x4000
DIM: Attribute : 0x8000

/* Key modifiers (bitwise) (tb_event.mod) */
MOD_ALT: Modifier : 1
MOD_CTRL: Modifier : 2
MOD_SHIFT: Modifier : 4
MOD_MOTION: Modifier : 8

/* Input modes (bitwise) (tb_set_input_mode) */
INPUT_CURRENT: Input_Mode : 0
INPUT_ESC: Input_Mode : 1
INPUT_ALT: Input_Mode : 2
INPUT_MOUSE: Input_Mode : 4

/* Output modes (tb_set_output_mode) */
OUTPUT_CURRENT: Output_Mode : 0
OUTPUT_NORMAL: Output_Mode : 1
OUTPUT_256: Output_Mode : 2
OUTPUT_216: Output_Mode : 3
OUTPUT_GRAYSCALE: Output_Mode : 4
OUTPUT_TRUECOLOR: Output_Mode : 5

/* Common function return values unless otherwise noted.
 *
 * Library behavior is undefined after receiving TB_ERR_MEM. Callers may
 * attempt reinitializing by freeing memory, invoking tb_shutdown, then
 * tb_init.
 */
OK                   :: 0
ERR                  :: -1
ERR_NEED_MORE        :: -2
ERR_INIT_ALREADY     :: -3
ERR_INIT_OPEN        :: -4
ERR_MEM              :: -5
ERR_NO_EVENT         :: -6
ERR_NO_TERM          :: -7
ERR_NOT_INIT         :: -8
ERR_OUT_OF_BOUNDS    :: -9
ERR_READ             :: -10
ERR_RESIZE_IOCTL     :: -11
ERR_RESIZE_PIPE      :: -12
ERR_RESIZE_SIGACTION :: -13
ERR_POLL             :: -14
ERR_TCGETATTR        :: -15
ERR_TCSETATTR        :: -16
ERR_UNSUPPORTED_TERM :: -17
ERR_RESIZE_WRITE     :: -18
ERR_RESIZE_POLL      :: -19
ERR_RESIZE_READ      :: -20
ERR_RESIZE_SSCANF    :: -21
ERR_CAP_COLLISION    :: -22

Event :: struct {
	type: Event_Type, /* one of EVENT_* constants */
	mod:  Modifier,   /* bitwise MOD_* constants */
	key:  Key,        /* one of KEY_* constants */
	ch:   c.uint32_t, /* a Unicode code point */
	w:    c.int32_t,  /* resize width */
	h:    c.int32_t,  /* resize height */
	x:    c.int32_t,  /* mouse x */
	y:    c.int32_t,  /* mouse y */
}

@(link_prefix = "tb_")
foreign termbox2 {
	init :: proc() -> c.int ---
	shutdown :: proc() -> c.int ---
	width :: proc() -> c.int ---
	height :: proc() -> c.int ---
	clear :: proc() -> c.int ---
	present :: proc() -> c.int ---
	set_cursor :: proc(cx, xy: c.int) -> c.int ---
	hide_cursor :: proc() -> c.int ---
	set_cell :: proc(x, y: c.int, ch: c.uint32_t, fg, bg: c.uint16_t) -> c.int ---
	peek_event :: proc(event: ^Event, timeout_ms: c.int) -> c.int ---
	poll_event :: proc(event: ^Event) -> c.int ---
	print :: proc(x, y: c.int, fg, bg: c.uint16_t, #c_vararg str: ..any) -> c.int ---
	printf :: proc(x, y: c.int, fg, bg: c.uint16_t, #c_vararg fmt: ..any) -> c.int ---
	set_input_mode :: proc(mode: c.int) -> c.int ---
	set_output_mode :: proc(mode: c.int) -> c.int ---
}
