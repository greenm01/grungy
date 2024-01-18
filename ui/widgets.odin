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
}

// Virtual procuedure table for drawing
draw :: proc {
	draw_block,     // don't remove this one
	draw_paragraph,
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
		if y + p.inner.min.y >= p.inner.max.y {
			break
		}
		r := trim_cells(row[:], rect_dx(p.inner))
		for cx in build_cell_with_xarray(r) {
			x, cell := cx.x, cx.cell
			buffer_set_cell(buf, cell, pt_add(pt(x, y), p.inner.min))
		} 
	} 
}
