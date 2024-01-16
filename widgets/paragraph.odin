package widgets

import "../ui"

Paragraph :: struct {
	using block: ui.Block,
	text:        string,
	text_style:  ui.Style,
	wrap_text:   bool,
}

new_paragraph :: proc() -> Paragraph {
	b := ui.new_block()
	p := Paragraph {
		block      = b,
		text_style = ui.theme.paragraph.text,
		wrap_text  = true,
	}
	b.derived = p	
	return p
}

draw_paragraph :: proc(p: ui.Paragraph, buf: ^ui.Buffer) {
	ui.draw(p.block, buf)

	cells := ui.parse_styles(p.text, p.text_style)
	if p.wrap_text {
		cells = ui.wrap_cells(cells, uint(ui.dx(p.inner)))
	}

	rows := ui.split_cells(cells, '\n')

	for row, y in rows {
		if y + p.inner.min.y >= p.inner.max.y {
			break
		}
		rows[y] = ui.trim_cells(row, ui.dx(p.inner))
		for cx, _ in ui.build_cell_with_xarray(row) {
			x, cell := cx.x, cx.cell
			ui.set_cell(buf, cell, ui.pt_add(ui.pt(x, y), p.inner.min))
		}
	}
}
