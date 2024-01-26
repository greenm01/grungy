package widgets

import "core:math"
import "../ui"

NORTH_ANGLE       :: -.5 * math.PI // the northward angle
RESOLUTION_FACTOR :: .0001         // circle resolution: precision vs. performance
FULL_CIRCLE       :: 2.0 * math.PI // the full circle angle
X_STRETCH         :: 2.0           // horizontal adjustment

// PieChartLabel callback
pie_chart_label :: proc(data_index: int, current_value: f64) -> string

Pie_Chart :: struct {
	using block:     ^Block,
	data:            []f64,            // list of data items
	colors:          []ui.Color,      // colors to by cycled through
	label_formatter: pie_chart_label, // callback function for labels
	angle_offset:    f64,             // which angle to start drawing at? (see NORTH_ANGLE)
}

del_pie_chart :: proc(pc: ^Pie_Chart) {
	del_block(pc)
}

// NewPieChart Creates a new pie chart with reasonable defaults and no labels.
new_pie_chart :: proc() -> ^Pie_Chart {
	block := new_block()
	pc := new(Pie_Chart)
	pc.block        = block
	pc.colors       = theme.pie_chart.slices
	pc.angle_offset = NORTH_ANGLE
	block.widget    = pc
	return pc
}

draw_pie_chart :: proc(pc: ^Pie_Chart, buf: ^ui.Buffer) {
	draw_block(pc, buf)

	center := ui.pt_add(pc.inner.min, ui.pt_div(ui.rect_size(pc.inner), 2))
	radius := ui.min_f64(f64(ui.rect_dx(pc.inner)/2/X_STRETCH), f64(ui.rect_dy(pc.inner)/2))

	// compute slice sizes
	sum := ui.sum_f64_slice(pc.data)
	slice_sizes := make([]f64, len(pc.data))
	for v, i in pc.data {
		slice_sizes[i] = v / sum * FULL_CIRCLE
	}

	border_circle := &Circle{center, radius}
	middle_circle := &Circle{point = center, radius = radius / 2.0}

	// draw sectors
	phi := pc.angle_offset
	for size, i in slice_sizes {
		for j := 0.0; j < size; j += RESOLUTION_FACTOR {
			border_point := circle_at(border_circle, phi + j)
			line := Line{p1 = center, p2 = border_point}
			draw_line(
				line,
				ui.new_cell(ui.SHADED_BLOCKS[1],
				ui.new_style(ui.select_color(pc.colors, i))),
				buf
			)
		}
		phi += size
	}

	// draw labels
	if pc.label_formatter != nil {
		phi = pc.angle_offset
		for size, i in slice_sizes {
			label_point := circle_at(middle_circle, phi + size/2.0)
			if len(pc.data) == 1 {
				label_point = center
			}
			ui.buffer_set_string(
				buf,
				pc.label_formatter(i, pc.data[i]),
				ui.new_style(ui.select_color(pc.colors, i)),
				ui.pt(label_point.x, label_point.y),
			)
			phi += size
		}
	}
}

Circle :: struct {
	using point: ui.Point,
	radius:      f64,
}

// computes the point at a given angle phi
circle_at :: proc(circle: ^Circle, phi: f64) -> ui.Point {
	x := circle.x + int(ui.round_f64(X_STRETCH*circle.radius*math.cos(phi)))
	y := circle.y + int(ui.round_f64(circle.radius*math.sin(phi)))
	return ui.Point{x = x, y = y}
}

// computes the perimeter of a circle
perimeter :: proc(circle: Circle) -> f64 {
	return 2.0 * math.PI * circle.radius
}

// a line between two points
Line :: struct {
	p1, p2: ui.Point,
}

// draws the line
draw_line :: proc(line: Line, cell: ui.Cell, buf: ^ui.Buffer) {
	is_left_of :: proc(p1, p2: ui.Point) -> bool {
		return p1.x <= p2.x
	}
	is_top_of :: proc(p1, p2: ui.Point) -> bool {
		return p1.y <= p2.y
	}
	p1, p2 := line.p1, line.p2
	ui.buffer_set_cell(buf, ui.new_cell('*', cell.style), line.p2)
	width, height := line_size(line)
	if width > height { // paint left to right
		if !is_left_of(p1, p2) {
			p1, p2 = p2, p1
		}
		flip := 1.0
		if !is_top_of(p1, p2) {
			flip = -1.0
		}
		for x := p1.x; x <= p2.x; x += 1 {
			ratio := f64(height) / f64(width)
			factor := f64(x - p1.x)
			y := ratio * factor * flip
			ui.buffer_set_cell(buf, cell, ui.pt(x, int(ui.round_f64(y))+p1.y))
		}
	} else { // paint top to bottom
		if !is_top_of(p1, p2) {
			p1, p2 = p2, p1
		}
		flip := 1.0
		if !is_left_of(p1, p2) {
			flip = -1.0
		}
		for y := p1.y; y <= p2.y; y += 1 {
			ratio := f64(width) / f64(height)
			factor := f64(y - p1.y)
			x := ratio * factor * flip
			ui.buffer_set_cell(buf, cell, ui.pt(int(ui.round_f64(x))+p1.x, y))
		}
	}
}

// width and height of a line
line_size :: proc(line: Line) -> (int, int) {
	return ui.abs_int(line.p2.x - line.p1.x), ui.abs_int(line.p2.y - line.p1.y)
}
