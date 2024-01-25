// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package widgets

import "core:fmt"

import "../ui"
import wc "../deps/wcwidth"

Bar_Chart :: struct {
	using block:   ^Block,
	bar_colors:    []ui.Color,
	label_styles:  []ui.Style,
	num_styles:    []ui.Style, // only Fg and Modifier are used
	num_formatter: proc(f64) -> string,
	data:          []f64,
	labels:        []string,
	bar_width:     int,
	bar_gap:       int,
	max_val:       f64,
}

del_bar_chart :: proc(bc: ^Bar_Chart) {
	del_block(bc)
}

new_bar_chart :: proc() -> (bc: ^Bar_Chart) {
	block := new_block()
	bc =               new(Bar_Chart)
	bc.block =         block
	bc.bar_colors =    theme.bar_chart.bars
	bc.num_styles =    theme.bar_chart.nums
	bc.label_styles =  theme.bar_chart.labels
	bc.num_formatter = proc(n: f64) -> string { return fmt.tprintf("%.0f", n) }
	bc.bar_gap =       1
	bc.bar_width =     3
	block.widget =     bc
	return
}

draw_bar_chart :: proc(bc: ^Bar_Chart, buf: ^ui.Buffer) {
	draw_block(bc, buf)

	max_val := bc.max_val
	if max_val == 0 {
		max_val = ui.get_max_f64_from_slice(bc.data)
	}

	bar_x_coordinate := bc.inner.min.x

	for data, i in bc.data {
		// draw bar
		height := int((data / max_val) * f64(ui.rect_dy(bc.inner)-1))
		for x := bar_x_coordinate; x < ui.min_int(bar_x_coordinate+bc.bar_width, bc.inner.max.x); x += 1 {
			for y := bc.inner.max.y - 2; y > (bc.inner.max.y-2)-height; y -= 1 {
				c := ui.new_cell(' ', ui.new_style(ui.DEFAULT, ui.select_color(bc.bar_colors, i)))
				ui.buffer_set_cell(buf, c, ui.pt(x, y))
			}
		}

		// draw label
		if i < len(bc.labels) {
			label_x_coordinate := bar_x_coordinate +
				int((f64(bc.bar_width) / 2)) -
				int((f64(wc.string_width(bc.labels[i])) / 2))
			ui.buffer_set_string(
				buf,
				bc.labels[i],
				ui.select_style(bc.label_styles, i),
				ui.pt(label_x_coordinate, bc.inner.max.y-1),
			)
		}

		// draw number
		number_x_coordinate := bar_x_coordinate + int((f64(bc.bar_width) / 2))
		if number_x_coordinate <= bc.inner.max.x {
			ui.buffer_set_string(
				buf,
				bc.num_formatter(data),
				ui.new_style(
					ui.select_style(bc.num_styles, i+1).fg,
					ui.select_color(bc.bar_colors, i),
					ui.select_style(bc.num_styles, i+1).modifier,
				),
				ui.pt(number_x_coordinate, bc.inner.max.y-2),
			)
		}

		bar_x_coordinate += (bc.bar_width + bc.bar_gap)
	}
}
