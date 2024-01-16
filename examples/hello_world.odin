package hello_world

import "core:fmt"

import "../ui"
import "../widgets"

main :: proc() {
	if err := ui.init(); err != 0 {
		fmt.printf("failed to initialize termui: %v", err)
	}
	defer ui.close()

	p := widgets.new_paragraph()
	p.text = "Hello World!"
	ui.set_rect(&p.block, 0, 0, 25, 5)

	//ui.render(p)
	/*
	for e in ui.poll_events() {
		if e.type == ui.KeyboardEvent {
			break
		}
	}
	*/
}
