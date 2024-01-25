package widgets

import "../ui"
import wc "../deps/wcwidth"

List :: struct {
	using block:        ^Block,
	rows:               []string,
	wrap_text:          bool,
	text_style:         ui.Style,
	selected_row:       int,
	top_row:            int,
	selected_row_style: ui.Style,
}

new_list :: proc() -> (list: ^List) {
	b := new_block()
	list = new(List)
	list.block = b
	list.text_style = theme.list.text
	list.selected_row_style = theme.list.text
	b.widget = list
	return
}

del_list :: proc(l: ^List) {
	del_block(l)	
}

draw_list :: proc(l: ^List, buf: ^ui.Buffer) {
	draw_block(l, buf)

	point := l.inner.min

	// adjusts view into widget
	if l.selected_row >= ui.rect_dy(l.inner)+l.top_row {
		l.top_row = l.selected_row - ui.rect_dy(l.inner) + 1
	} else if l.selected_row < l.top_row {
		l.top_row = l.selected_row
	}

	// draw rows
	for row := l.top_row; row < len(l.rows) && point.y < l.inner.max.y; row += 1 {
		cells := ui.parse_styles(l.rows[row], l.text_style)
		if l.wrap_text {
			cells = ui.wrap_cells(cells, ui.rect_dx(l.inner))
		}
		for j := 0; j < len(cells) && point.y < l.inner.max.y; j += 1 {
			style := cells[j].style
			if row == l.selected_row {
				style = l.selected_row_style
			}
			if cells[j]._rune == '\n' {
				point = ui.pt(l.inner.min.x, point.y+1)
			} else {
				if point.x+1 == l.inner.max.x+1 && len(cells) > ui.rect_dx(l.inner) {
					ui.buffer_set_cell(
						buf,
						ui.new_cell(ui.ELLIPSES, style),
						ui.pt_add(point, ui.pt(-1, 0))
					)
					break
				} else {
					ui.buffer_set_cell(
						buf,
						ui.new_cell(cells[j]._rune, style),
						point
					)
					point = ui.pt_add(point, ui.pt(wc.rune_width(cells[j]._rune), 0))
				}
			}
		}
		point = ui.pt(l.inner.min.x, point.y+1)
	}

	// draw UP_ARROW if needed
	if l.top_row > 0 {
		ui.buffer_set_cell(
			buf,
			ui.new_cell(ui.UP_ARROW, ui.new_style(ui.WHITE)),
			ui.pt(l.inner.max.x-1, l.inner.min.y),
		)
	}

	// draw DOWN_ARROW if needed
	if len(l.rows) > int(l.top_row)+ui.rect_dy(l.inner) {
		ui.buffer_set_cell(
			buf,
			ui.new_cell(ui.DOWN_ARROW, ui.new_style(ui.WHITE)),
			ui.pt(l.inner.max.x-1, l.inner.max.y-1),
		)
	}
}

// ScrollAmount scrolls by amount given. If amount is < 0, then scroll up.
// There is no need to set self.top_row, as this will be set automatically when drawn,
// since if the selected item is off screen then the top_row variable will change accordingly.
list_scroll_amount :: proc(l: ^List, amount: int) {
	if len(l.rows)-int(l.selected_row) <= amount {
		l.selected_row = len(l.rows) - 1
	} else if int(l.selected_row)+amount < 0 {
		l.selected_row = 0
	} else {
		l.selected_row += amount
	}
}

list_scroll_up :: proc(l: ^List) {
	list_scroll_amount(l, -1)
}

list_scroll_down :: proc(l: ^List) {
	list_scroll_amount(l, 1)
}

list_scroll_page_up :: proc(l: ^List) {
	// If an item is selected below top row, then go to the top row.
	if l.selected_row > l.top_row {
		l.selected_row = l.top_row
	} else {
		list_scroll_amount(l, -ui.rect_dy(l.inner))
	}
}

list_scroll_page_down :: proc(l: ^List) {
	list_scroll_amount(l, ui.rect_dy(l.inner))
}

list_scroll_half_page_up :: proc(l: ^List) {
	list_scroll_amount(l, -int(ui.floor_f64(f64(ui.rect_dy(l.inner)) / 2)))
}

list_scroll_half_page_down :: proc(l: ^List) {
	list_scroll_amount(l, int(ui.floor_f64(f64(ui.rect_dy(l.inner)) / 2)))
}

list_scroll_top :: proc(l: ^List) {
	l.selected_row = 0
}

list_scroll_bottom :: proc(l: ^List) {
	l.selected_row = len(l.rows) - 1
}
