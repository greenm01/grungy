package ui

/* ####################################################
 * To add a new widget do two things:
 *     1) Add the widget struct to the Widgets union.
 *     2) Add the widget's draw procedure to the draw
 *        virtual procedure table.
 * #################################################### */

// Available widgets. 
Widgets :: union {
	Paragraph,
	Table,
}

// Virtual procuedure table for drawing
draw :: proc {
	draw_block,     // don't remove this one
	draw_paragraph,
	draw_table,
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

new_paragraph :: proc(txt: string) -> ^Block {
	b := new_block()
	b.widget = Paragraph {
		block      = b,
		text       = txt,
		text_style = theme.paragraph.text,
		wrap_text  = true,
	}
	b.widget_type = Rectangle
	return b
}

draw_paragraph :: proc(p: Paragraph, buf: ^Buffer) {
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
	text_alignment: Alignment,
	row_styles:     map[int]Style,
	fill_row:       bool,

	// ColumnResizer is called on each Draw. Can be used for custom column sizing.
	column_resizer: proc() -> bool, 
}

new_table :: proc() -> ^Block {
	b := new_block()
	b.widget = Table{
		block =          b,
		text_style =     theme.table.text,
		row_separator =  true,
		row_styles =     make(map[int]Style),
		column_resizer = proc() -> bool {return false}  
	}
	b.widget_type = Table
	return b
}

draw_table :: proc(t: Table, buf: ^Buffer) {
	draw_block(t.block, buf)

	t.column_resizer()

	column_widths := t.column_widths
	if len(column_widths) == 0 {
		column_count := len(t.rows[0])
		column_width := rect_dx(t.inner) / column_count
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

		using Alignment
		
		// draw row cells
		for j := 0; j < len(row); j += 1 {
			col := parse_styles(row[j], row_style)
			// draw row cell
			if len(col) > column_widths[j] || t.text_alignment == Align_Left {
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
			} else if t.text_alignment == Align_Center {
				x_coordinate_offset := (column_widths[j] - len(col)) / 2
				string_x_coordinate := x_coordinate_offset + col_x_coordinate
				for cx in build_cell_with_xarray(col) {
					k, cell := cx.x, cx.cell
					buffer_set_cell(buf, cell, pt(string_x_coordinate+k, y_coordinate))
				}
			} else if t.text_alignment == Align_Right {
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
