package hello_world

import "core:fmt"
import "core:os"
import "../ui"

main :: proc() {

	if err := ui.init(); err != 0 {
		fmt.printf("failed to initialize grungy: %v", err)
		ui.close(); os.exit(1)
	}
	defer ui.close()
			
	ui.clear()

	p := ui.new_paragraph()
	p.text = "\nPress a key to quit..."
	p.title = " Hello World! "
	
	ui.set_rect(p, 0, 0, 25, 5)
	ui.render(p)
	ui.present()
	
	for {
		event := ui.poll_event()
		if event.type == ui.Event_Type.Keyboard_Event do break
	}
	
}
