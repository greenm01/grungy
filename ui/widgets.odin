// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

/* List of vailable widgets. Add new ones to the union */
Widgets :: union {
	Paragraph,
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
		cells = wrap_cells(cells, dx(p.inner))
	}
	
	rows := split_cells(cells, '\n')
	for row, y in rows {
		if y + p.inner.min.y >= p.inner.max.y {
			break
		}
		r := trim_cells(row[:], dx(p.inner))
		for cx in build_cell_with_xarray(r) {
			x, cell := cx.x, cx.cell
			set_cell(buf, cell, pt_add(pt(x, y), p.inner.min))
		} 
	} 
}
