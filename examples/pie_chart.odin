package pie_chart

import "core:fmt"
import "core:os"
import "core:math"
import "core:math/rand"
import "core:time"
import "core:thread"

import "../ui"
import wg "../widgets"

run := true

main :: proc() {
	if err := ui.init(); err != ui.OK {
		fmt.printf("failed to initialize termui: %v", err)
		ui.close(); os.exit(1)
	}
	defer ui.close()


	random_data_and_offset :: proc() -> (data: []f64, offset: f64) {
		rnd := new(rand.Rand)
		defer free(rnd)
		rand.init_as_system(rnd)
		
		no_slices := 2 + rand.int_max(4)
		data = make([]f64, no_slices)
		for _, i in data {
			data[i] = rand.float64(rnd)
		}
		offset = 2.0 * math.PI * rand.float64(rnd)
		return
	}

	pc := wg.new_pie_chart()
	defer wg.del_pie_chart(pc)

	pc.title = "Pie Chart"
	wg.set_rect(pc, 5, 5, 70, 36)
	pc.data = []f64{.25, .25, .25, .25}
	pc.angle_offset = -.5 * math.PI
	pc.label_formatter = proc(i: int, v: f64) -> string {
		return fmt.tprintf("%.02f", v)
	}

	pause :: proc(pc: ^wg.Pie_Chart) {
		run = !run
		if run {
			pc.title = "Pie Chart"
		} else {
			pc.title = "Pie Chart (Stopped)"
		}
		ui.clear()
		wg.render(pc)
		ui.present()
	}

	ui.clear()
	wg.render(pc)
	ui.present()

	start := time.now()
	ticker := false

	// Let's use a thread so termbox2's event
	// polling won't block the clock
	event := new(ui.Event)
	event_thread :: ui.poll_kb_event_thread
	worker := thread.create_and_start_with_data(event, event_thread)
	defer clean_thread(event, worker)

	using ui.Event_Type
	loop: for {
		// Give the CPU a rest
		time.sleep(time.Duration(100))
		d := time.duration_seconds(time.diff(start, time.now()))
		if d >= 1 {
			start = time.now()
			ticker = true
		}
		if thread.is_done(worker) {
			if event.type == .Keyboard_Event {
				switch event.id {
				case "q", "<C-c>", "<Escape>":
					break loop
				case "s":
					pause(pc)
				case "t":
					ticker = true
					if !run do pause(pc)
				}
			}
			clean_thread(event, worker)
			event = new(ui.Event)
			worker = thread.create_and_start_with_data(event, event_thread)
		}

		if ticker {
			ticker = false
			if run {
				pc.data, pc.angle_offset = random_data_and_offset()
				ui.clear()
				wg.render(pc)
				ui.present()
			}
		}
	}
}

clean_thread :: proc(event: ^ui.Event, worker: ^thread.Thread) {
	free(event)
	thread.destroy(worker)
}
