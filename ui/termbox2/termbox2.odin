package termbox2

import "core:c"

foreign import termbox2 "libtermbox2.a"

Event :: struct {
    type: c.uint8_t, /* one of TB_EVENT_* constants */
    mod: c.uint8_t,  /* bitwise TB_MOD_* constants */
    key: c.uint16_t, /* one of TB_KEY_* constants */
    ch: c.uint32_t,  /* a Unicode code point */
    w: c.int32_t,    /* resize width */
    h: c.int32_t,    /* resize height */
    x: c.int32_t,    /* mouse x */
    y: c.int32_t,    /* mouse y */
}

/* Colors (numeric) and attributes (bitwise) (cell.fg, cell.bg) */
DEFAULT :: 0x0000
BLACK :: 0x0001
RED :: 0x0002
GREEN :: 0x0003
YELLOW :: 0x0004
BLUE :: 0x0005
MAGENTA :: 0x0006
CYAN :: 0x0007
WHITE :: 0x0008

/* Input modes (bitwise) (set_input_mode) */
INPUT_CURRENT :: 0
INPUT_ESC :: 1
INPUT_ALT :: 2
INPUT_MOUSE :: 4

/* Output modes (set_output_mode) */
OUTPUT_CURRENT :: 0
OUTPUT_NORMAL :: 1
OUTPUT_256 :: 2
OUTPUT_216 :: 3
OUTPUT_TRUECOLOR :: 5

@(link_prefix="tb_")
foreign termbox2 {
 init :: proc() -> c.int ---
 shutdown :: proc() -> c.int ---
 width :: proc() -> c.int ---
 height :: proc() -> c.int ---
 clear :: proc() -> c.int ---
 present :: proc() -> c.int ---
 set_cursor :: proc(cx, xy: c.int) -> c.int ---
 hide_cursor :: proc() -> c.int ---
 set_cell :: proc(x, y: c.int, ch: c.uint32_t, fg, bg: c.uint64_t) -> c.int ---
 peek_event :: proc(event: ^Event, timeout_ms: c.int) -> c.int ---
 poll_event :: proc(event: ^Event) -> c.int ---
 print :: proc(x, y: c.int, fg, bg: c.uint64_t, #c_vararg str: ..any) -> c.int ---
 printf :: proc(x, y: c.int, fg, bg: c.uint64_t, #c_vararg fmt: ..any) -> c.int ---
 set_input_mode :: proc(mode: c.int) -> c.int ---
 set_output_mode :: proc(mode: c.int) -> c.int ---
}
