package widgets

import "../ui"

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
	text_style:     ui.Style,
	row_separator:  bool,
	text_alignment: ui.Alignment,
	row_styles:     map[int]ui.Style,
	fill_row:       bool,

	// ColumnResizer is called on each Draw. Can be used for custom column sizing.
	column_resizer: proc() -> bool, 
}

new_table :: proc() -> (table: ^Table) {
	b := new_block()
	table = new(Table)
	table.block = b
	table.text_style = ui.theme.table.text
	table.row_separator = true
	table.row_styles = make(map[int]ui.Style)
	table.column_resizer = proc() -> bool {return false}  
	b.widget = table
	return 
}

del_table :: proc(t: ^Table) {
	delete(t.row_styles)
	del_block(t)
}

draw_table :: proc(t: ^Table, buf: ^ui.Buffer) {
	draw_block(t.block, buf)

	t.column_resizer()

	column_widths := t.column_widths
	if len(column_widths) == 0 {
		column_count := len(t.rows[0])
		column_width := ui.rect_dx(t.inner) / column_count
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
			blank_cell := ui.new_cell(' ', row_style)
			ui.buffer_fill(
				buf,
				blank_cell,
				ui.rect(t.inner.min.x, y_coordinate, t.inner.max.x, y_coordinate+1)
			)
		}

		using ui.Alignment

		// draw row cells
		for j := 0; j < len(row); j += 1 {
			col := ui.parse_styles(row[j], row_style)
			// draw row cell
			if len(col) > column_widths[j] || t.text_alignment == Align_Left {
				for cx in ui.build_cell_with_xarray(col) {
					k, cell := cx.x, cx.cell
					if k == column_widths[j] || col_x_coordinate+k == t.inner.max.x {
						cell._rune = ui.ELLIPSES
						ui.buffer_set_cell(
							buf,
							cell,
							ui.pt(col_x_coordinate+k-1, y_coordinate)
						)
						break
					} else {
						ui.buffer_set_cell(
							buf,
							cell,
							ui.pt(col_x_coordinate+k, y_coordinate)
						)
					}
				}
			} else if t.text_alignment == Align_Center {
				x_coordinate_offset := (column_widths[j] - len(col)) / 2
				string_x_coordinate := x_coordinate_offset + col_x_coordinate
				for cx in ui.build_cell_with_xarray(col) {
					k, cell := cx.x, cx.cell
					ui.buffer_set_cell(
						buf,
						cell,
						ui.pt(string_x_coordinate+k, y_coordinate)
					)
				}
			} else if t.text_alignment == Align_Right {
				string_x_coordinate :=
					ui.min_int(col_x_coordinate+column_widths[j], t.inner.max.x) - len(col)
				for cx in ui.build_cell_with_xarray(col) {
					k, cell := cx.x, cx.cell
					ui.buffer_set_cell(
						buf,
						cell,
						ui.pt(string_x_coordinate+k, y_coordinate)
					)
				}
			}
			col_x_coordinate += column_widths[j] + 1
		}

		// draw vertical separators
		separator_style := t.block.border_style

		separator_x_coordinate := t.inner.min.x
		vertical_cell := ui.new_cell(ui.VERTICAL_LINE, separator_style)
		for width, i in column_widths {
			if t.fill_row && i < len(column_widths) - 1 {
				vertical_cell.style.bg = row_style.bg
			} else {
				vertical_cell.style.bg = t.block.border_style.bg
			}

			separator_x_coordinate += width
			ui.buffer_set_cell(
				buf,
				vertical_cell,
				ui.pt(separator_x_coordinate, y_coordinate)
			)
			separator_x_coordinate += 1
		}

		y_coordinate += 1

		// draw horizontal separator
		horizontal_cell := ui.new_cell(ui.HORIZONTAL_LINE, separator_style)
		if t.row_separator && y_coordinate < t.inner.max.y && i != len(t.rows) - 1 {
			ui.buffer_fill(
				buf,
				horizontal_cell,
				ui.rect(t.inner.min.x, y_coordinate, t.inner.max.x, y_coordinate + 1)
			)
			y_coordinate += 1
		}
	}
}
