package ui

/* ######################################################
 * To add a new widget, remember to do two things:
 *     1) Add the widget struct to the Widgets union.
 *     2) Add the widget's type to the render procedure
 * ###################################################### */

import wc "wcwidth"

// Available widgets. 
Widgets :: union {
	^Paragraph,
	^Table,
	^List,
}

/* ##########################
 * #### PARAGRAPH WIDGET ####
 * ########################## */

Paragraph :: struct {
	using block: ^Block,
	text:        string,
	text_style:  Style,
	wrap_text:   bool,
}

new_paragraph :: proc() -> (paragraph: ^Paragraph) {
	b := new_block()
	paragraph = new(Paragraph)
	paragraph.block = b
	paragraph.text_style = theme.paragraph.text
	paragraph.wrap_text = true
	b.widget = paragraph
	return
}

draw_paragraph :: proc(p: ^Paragraph, buf: ^Buffer) {
	draw_block(p.block, buf)
	cells := parse_styles(p.text, p.text_style)
	if p.wrap_text {
		cells = wrap_cells(cells, rect_dx(p.inner))
	}
	
	rows := split_cells(cells, '\n')
	for row, y in rows {
		if y + p.inner.min.y >= p.inner.max.y do break
		r := trim_cells(row[:], rect_dx(p.inner))
		for cx in build_cell_with_xarray(r) {
			x, cell := cx.x, cx.cell
			buffer_set_cell(buf, cell, pt_add(pt(x, y), p.inner.min))
		} 
	} 
}


/* ######################
 * #### TABLE WIDGET ####
 * ###################### */


/*Table is like:
┌ Awesome Table ───────────────────────────────────────────────┐
│  Col0          | Col1 | Col2 | Col3  | Col4  | Col5  | Col6  |
│──────────────────────────────────────────────────────────────│
│  Some Item #1  | AAA  | 123  | CCCCC | EEEEE | GGGGG | IIIII |
│──────────────────────────────────────────────────────────────│
│  Some Item #2  | BBB  | 456  | DDDDD | FFFFF | HHHHH | JJJJJ |
└──────────────────────────────────────────────────────────────┘
*/

Table :: struct {
	using block:    ^Block,
	rows:           [][]string,
	column_widths:  []int,
	text_style:     Style,
	row_separator:  bool,
	text_alignment: int,
	row_styles:     map[int]Style,
	fill_row:       bool,

	// ColumnResizer is called on each Draw. Can be used for custom column sizing.
	column_resizer: proc() -> bool, 
}

new_table :: proc() -> (table: ^Table) {
	b := new_block()
	table = new(Table)
	table.block = b
	table.text_style = theme.table.text
	table.row_separator = true
	table.row_styles = make(map[int]Style)
	table.column_resizer = proc() -> bool {return false}  
	b.widget = table
	return 
}

draw_table :: proc(t: ^Table, buf: ^Buffer) {
	draw_block(t.block, buf)

	t.column_resizer()

	column_widths := t.column_widths
	if len(column_widths) == 0 {
		column_count := len(t.rows[0])
		column_width := rect_dx(t.inner) / column_count
		column_widths = make([]int, column_count)
		for i := 0; i < column_count; i += 1 {
			column_widths[i] = column_width
		}
	}

	y_coordinate := t.inner.min.y

	// draw rows
	for i := 0; i < len(t.rows) && y_coordinate < t.inner.max.y; i += 1 {
		row := t.rows[i]
		col_x_coordinate := t.inner.min.x

		row_style := t.text_style
		// get the row style if one exists
		if style, ok := t.row_styles[i]; ok {
			row_style = style
		}

		if t.fill_row {
			blank_cell := new_cell(' ', row_style)
			buffer_fill(buf, blank_cell, rect(t.inner.min.x, y_coordinate, t.inner.max.x, y_coordinate+1))
		}

		// draw row cells
		for j := 0; j < len(row); j += 1 {
			col := parse_styles(row[j], row_style)
			// draw row cell
			if len(col) > column_widths[j] || t.text_alignment == ALIGN_LEFT {
				for cx in build_cell_with_xarray(col) {
					k, cell := cx.x, cx.cell
					if k == column_widths[j] || col_x_coordinate+k == t.inner.max.x {
						cell._rune = ELLIPSES
						buffer_set_cell(buf, cell, pt(col_x_coordinate+k-1, y_coordinate))
						break
					} else {
						buffer_set_cell(buf, cell, pt(col_x_coordinate+k, y_coordinate))
					}
				}
			} else if t.text_alignment == ALIGN_CENTER {
				x_coordinate_offset := (column_widths[j] - len(col)) / 2
				string_x_coordinate := x_coordinate_offset + col_x_coordinate
				for cx in build_cell_with_xarray(col) {
					k, cell := cx.x, cx.cell
					buffer_set_cell(buf, cell, pt(string_x_coordinate+k, y_coordinate))
				}
			} else if t.text_alignment == ALIGN_RIGHT {
				string_x_coordinate := min_int(col_x_coordinate+column_widths[j], t.inner.max.x) - len(col)
				for cx in build_cell_with_xarray(col) {
					k, cell := cx.x, cx.cell
					buffer_set_cell(buf, cell, pt(string_x_coordinate+k, y_coordinate))
				}
			}
			col_x_coordinate += column_widths[j] + 1
		}

		// draw vertical separators
		separator_style := t.block.border_style

		separator_x_coordinate := t.inner.min.x
		vertical_cell := new_cell(VERTICAL_LINE, separator_style)
		for width, i in column_widths {
			if t.fill_row && i < len(column_widths)-1 {
				vertical_cell.style.bg = row_style.bg
			} else {
				vertical_cell.style.bg = t.block.border_style.bg
			}

			separator_x_coordinate += width
			buffer_set_cell(buf,vertical_cell, pt(separator_x_coordinate, y_coordinate))
			separator_x_coordinate += 1
		}

		y_coordinate += 1

		// draw horizontal separator
		horizontal_cell := new_cell(HORIZONTAL_LINE, separator_style)
		if t.row_separator && y_coordinate < t.inner.max.y && i != len(t.rows)-1 {
			buffer_fill(buf, horizontal_cell, rect(t.inner.min.x, y_coordinate, t.inner.max.x, y_coordinate+1))
			y_coordinate += 1
		}
	}
}

/* #####################
 * #### LIST WIDGET ####
 * ##################### */

List :: struct {
	using block:        ^Block,
	rows:               []string,
	wrap_text:          bool,
	text_style:         Style,
	selected_row:       int,
	top_row:            int,
	selected_row_style: Style,
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

draw_list :: proc(l: ^List, buf: ^Buffer) {
	draw_block(l, buf)

	point := l.inner.min

	// adjusts view into widget
	if l.selected_row >= rect_dy(l.inner)+l.top_row {
		l.top_row = l.selected_row - rect_dy(l.inner) + 1
	} else if l.selected_row < l.top_row {
		l.top_row = l.selected_row
	}

	// draw rows
	for row := l.top_row; row < len(l.rows) && point.y < l.inner.max.y; row += 1 {
		cells := parse_styles(l.rows[row], l.text_style)
		if l.wrap_text {
			cells = wrap_cells(cells, rect_dx(l.inner))
		}
		for j := 0; j < len(cells) && point.y < l.inner.max.y; j += 1 {
			style := cells[j].style
			if row == l.selected_row {
				style = l.selected_row_style
			}
			if cells[j]._rune == '\n' {
				point = pt(l.inner.min.x, point.y+1)
			} else {
				if point.x+1 == l.inner.max.x+1 && len(cells) > rect_dx(l.inner) {
					buffer_set_cell(
						buf,
						new_cell(ELLIPSES, style),
						pt_add(point, pt(-1, 0))
					)
					break
				} else {
					buffer_set_cell(
						buf,
						new_cell(cells[j]._rune, style),
						point
					)
					point = pt_add(point, pt(wc.rune_width(cells[j]._rune), 0))
				}
			}
		}
		point = pt(l.inner.min.x, point.y+1)
	}

	// draw UP_ARROW if needed
	if l.top_row > 0 {
		buffer_set_cell(
			buf,
			new_cell(UP_ARROW, new_style(WHITE)),
			pt(l.inner.max.x-1, l.inner.min.y),
		)
	}

	// draw DOWN_ARROW if needed
	if len(l.rows) > int(l.top_row)+rect_dy(l.inner) {
		buffer_set_cell(
			buf,
			new_cell(DOWN_ARROW, new_style(WHITE)),
			pt(l.inner.max.x-1, l.inner.max.y-1),
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
		list_scroll_amount(l, -rect_dy(l.inner))
	}
}

list_scroll_page_down :: proc(l: ^List) {
	list_scroll_amount(l, rect_dy(l.inner))
}

list_scroll_half_page_up :: proc(l: ^List) {
	list_scroll_amount(l, -int(floor_f64(f64(rect_dy(l.inner)) / 2)))
}

list_scroll_half_page_down :: proc(l: ^List) {
	list_scroll_amount(l, int(floor_f64(f64(rect_dy(l.inner)) / 2)))
}

list_scroll_top :: proc(l: ^List) {
	l.selected_row = 0
}

list_scroll_bottom :: proc(l: ^List) {
	l.selected_row = len(l.rows) - 1
}
