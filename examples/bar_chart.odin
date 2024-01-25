package bar_chart

import "core:fmt"
import "core:os"

import "../ui"
import wg "../widgets"

main :: proc() {
	if err := ui.init(); err != ui.OK {
		fmt.printf("failed to initialize termui: %v\n", err)
		ui.close(); os.exit(1)
	}
	defer ui.close()

	bc := wg.new_bar_chart()
	bc.data = []f64{3, 2, 5, 3, 9, 3}
	bc.labels = []string{"S0", "S1", "S2", "S3", "S4", "S5"}
	bc.title = "Bar Chart"
	wg.set_rect(bc, 5, 5, 100, 25)
	bc.bar_width = 5
	bc.bar_colors = []ui.Color{ui.RED, ui.GREEN}
	bc.label_styles = []ui.Style{ui.new_style(ui.BLUE)}
	bc.num_styles = []ui.Style{ui.new_style(ui.YELLOW)}

	ui.clear()
	wg.render(bc)
	ui.present()

	loop: for {
		event := ui.poll_event()
		switch event.id {
		case "q", "<C-c>", "<Escape>":
			break loop
		}
	}
}
