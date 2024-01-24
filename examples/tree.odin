package tree

import "core:fmt"
import "core:os"

import "../ui"
import wg "../widgets"

//func (nv Node_Value) String() string {
//	return string(nv)
//}

main :: proc() {
	if err := ui.init(); err != ui.OK {
		fmt.printf("failed to initialize termui: %v", err)
		ui.close(); os.exit(1)
	}
	defer ui.close()

	nodes := []wg.Tree_Node{
		{
			value = "Key 1",
			nodes = []wg.Tree_Node{
				{
					value = "Key 1.1",
					nodes = []wg.Tree_Node{
						{
							value = "Key 1.1.1",
						},
						{
							value = "Key 1.1.2",
						},
					},
				},
				{
					value = "Key 1.2",
				},
			},
		},
		{
			value = "Key 2",
			nodes = []wg.Tree_Node{
				{
					value = "Key 2.1",
				},
				{
					value = "Key 2.2",
				},
				{
					value = "Key 2.3",
				},
			},
		},
		{
			value = "Key 3",
		},
	}

	tree := wg.new_tree()
	defer wg.del_tree(tree)

	tree.text_style = ui.new_style(ui.YELLOW)
	tree.wrap_text = false
	wg.set_nodes(tree, nodes)

	x, y := ui.terminal_dimensions()

	wg.set_rect(tree, 0, 0, x, y)
	ui.clear()
	wg.render(tree)
	ui.present()

	previous_key := ""
	loop: for {
		e := ui.poll_event()
		switch e.id {
		case "q", "<C-c>", "<Escape>":
			break loop
		case "j", "<Down>":
			wg.scroll_down(tree)
		case "k", "<Up>":
			wg.scroll_up(tree)
		case "<C-d>":
			wg.scroll_half_page_down(tree)
		case "<C-u>":
			wg.scroll_half_page_up(tree)
		case "<C-f>":
			wg.scroll_page_down(tree)
		case "<C-b>":
			wg.scroll_page_up(tree)
		case "g":
			if previous_key == "g" {
				wg.scroll_top(tree)
			}
		case "<Home>":
			wg.scroll_top(tree)
		case "<Enter>":
			wg.toggle_expand(tree)
		case "G", "<End>":
			wg.scroll_bottom(tree)
		case "E":
			wg.expand_all(tree)
		case "C":
			wg.collapse_all(tree)
		case "<Resize>":
			x, y := ui.terminal_dimensions()
			wg.set_rect(tree, 0, 0, x, y)
		}

		if previous_key == "g" {
			previous_key = ""
		} else {
			previous_key = e.id
		}

		ui.clear()
		wg.render(tree)
		ui.present()
	} 
}
