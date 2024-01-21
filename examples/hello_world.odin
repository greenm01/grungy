package hello_world

import "core:fmt"
import "core:os"

import "../ui"
import wg "../widgets"

main :: proc() {

	if err := ui.init(); err != ui.OK {
		fmt.printf("failed to initialize grungy: %v", err)
		ui.close(); os.exit(1)
	}
	defer ui.close()
			
	ui.clear()

	p := wg.new_paragraph()
	p.text = "\nPress a key to quit..."
	p.title = " Hello World! "
	wg.set_rect(p, 0, 0, 25, 5)
	wg.render(p)
	
	ui.present()

	using ui.Event_Type

	for {
		event := ui.poll_event()
		if event.type == Keyboard_Event do break
	}
	
}
