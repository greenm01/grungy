package hello_world

import "core:fmt"

import "../ui"

main :: proc() {
	if err := ui.init(); err != 0 {
		fmt.printf("failed to initialize termui: %v", err)
	}
	defer ui.close()

	text := "Hello world!"
	p := ui.new_paragraph(text)
	ui.set_rect(p, 0, 0, 25, 5)

	ui.render(p)
	/*
	for e in ui.poll_events() {
		if e.type == ui.KeyboardEvent {
			break
		}
	}
	*/
}
