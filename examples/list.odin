package list

import "core:fmt"
import "core:os"
import "core:strings"

import "../ui"

main :: proc () {
	if err := ui.init(); err != ui.OK {
		fmt.printf("failed to initialize grungy: %v", err)
		ui.close(); os.exit(1)
	}
	defer ui.close()

	l := ui.new_list()
	defer ui.del_widget(l)

	l.title = "List"
	l.rows = []string{
		"[0] https://github.com/greenm01/grungy",
		"[1] [Hellope world](fg:blue)",
		"[2] [Esterian Conquest](fg:red)",
		"[3] [color](fg:white,bg:green) output",
		"[4] output.odin",
		"[5] random_out.odin",
		"[6] dashboard.odin",
		"[7] foo",
		"[8] bar",
		"[9] baz",
	}
	l.text_style = ui.new_style(ui.YELLOW)
	l.wrap_text = false
	ui.set_rect(l, 0, 0, 25, 8)

	ui.clear()
	ui.render(l)
	ui.present()

	using ui.Event_Type

	previous_key := ""
	loop: for {
		e := ui.poll_event()
		switch e.type {
		case Keyboard_Event:
			switch e.id {
			case "q", "<C-c>", "<Escape>":
				break loop
			case "j", "<Down>":
				ui.list_scroll_down(l)
			case "k", "<Up>":
				ui.list_scroll_up(l)
			case "<C-d>":
				ui.list_scroll_half_page_down(l)
			case "<C-u>":
				ui.list_scroll_half_page_up(l)
			case "<C-f>":
				ui.list_scroll_page_down(l)
			case "<C-b>":
				ui.list_scroll_page_up(l)
			case "g":
				if previous_key == "g" do ui.list_scroll_top(l)
			case "<Home>":
				ui.list_scroll_top(l)
			case "G", "<End>":
				ui.list_scroll_bottom(l)
			}			
		case Mouse_Event:
			break loop
		case Resize_Event:
			break loop
		}
			
		if previous_key == "g" {
			previous_key = ""
		} else {
			previous_key = e.id
		}

		ui.clear()
		ui.render(l)
		ui.present()
	}
}
