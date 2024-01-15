package hello_world

import "core:fmt"

import "../ui"
import "../widgets"

main :: proc() {
	if err := ui.init(); err != nil {
		fmt.printf("failed to initialize termui: %v", err)
	}
	defer ui.close()

	p := widgets.new_paragraph()
	p.text = "Hello World!"
	p.set_rect(0, 0, 25, 5)

	ui.render(p)

	for e in ui.poll_events() {
		if e.type == ui.KeyboardEvent {
			break
		}
	}
}
