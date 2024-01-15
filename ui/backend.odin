package ui

import "core:fmt"
import "core:os"

import tb "termbox2"

init :: proc() {

	ret := tb.init()

	if ret != 0 {
		fmt.printf("Termbox2 failed to initialize with code %d", ret)
		close()
		os.exit(1)
	}

	tb.set_input_mode(tb.INPUT_ESC)
	tb.set_output_mode(tb.OUTPUT_256)

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
