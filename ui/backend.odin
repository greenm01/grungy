package ui

import "core:fmt"
import "core:os"
import "core:c"

import tb "../termbox2"

init :: proc() -> int {

	ret := tb.init()

	if ret != 0 {
		fmt.printf("Termbox2 failed to initialize with code %d", ret)
		close()
		os.exit(1)
	}

	tb.set_input_mode(tb.INPUT_ESC)
	tb.set_output_mode(tb.OUTPUT_256)
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

tb_set_cell :: proc(x, y: int, ch: rune, fg, bg: Color) -> int {
	return int(tb.set_cell(i32(x), i32(y), u32(ch), u16(fg), u16(bg)))
}
