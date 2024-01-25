package widgets

import "../ui"
import wc "../deps/wcwidth"

Paragraph :: struct {
	using block: ^Block,
	text:        string,
	text_style:  ui.Style,
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

draw_paragraph :: proc(p: ^Paragraph, buf: ^ui.Buffer) {
	draw_block(p, buf)
	cells := ui.parse_styles(p.text, p.text_style)
	if p.wrap_text {
		cells = ui.wrap_cells(cells, ui.rect_dx(p.inner))
	}
	
	rows := ui.split_cells(cells, '\n')
	for row, y in rows {
		if y + p.inner.min.y >= p.inner.max.y do break
		r := ui.trim_cells(row[:], ui.rect_dx(p.inner))
		for cx in ui.build_cell_with_xarray(r) {
			x, cell := cx.x, cx.cell
			ui.buffer_set_cell(buf, cell, ui.pt_add(ui.pt(x, y), p.inner.min))
		} 
	} 
}
