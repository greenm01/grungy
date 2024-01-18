package hello_world

import "core:fmt"

import "../ui"

main :: proc() {
	if err := ui.init(); err != 0 {
		fmt.printf("failed to initialize termui: %v", err)
	}
	defer ui.close()

	text := "Hello world!\nPress a key to quit..."
	p := ui.new_paragraph(text)
	ui.set_rect(p, 0, 0, 25, 5)
	
	ui.render(p^)
	
	for {
		event := ui.poll_event()
		if event.type == ui.Event_Type.Keyboard_Event do break
	}
	
}
