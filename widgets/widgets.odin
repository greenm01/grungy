package widgets

import "../ui"

Paragraph :: struct {
	using block: ui.Block,
	text:        string,
	text_style:  Style,
	wrap_text:   bool,
}

new_paragraph :: proc() -> ui.Block {
	b := new_block()
	b.derived = ui.Paragraph {
		block      = b,
		text_style = theme.paragraph.text,
		wrap_text  = true,
	}
	return b
}

draw_paragraph :: proc(p: ui.Paragraph, buf: ^ui.Buffer) {
	draw(p.block, buf)

	cells := parse_styles(p.text, p.text_style)
	if p.wrap_text {
		cells = wrap_cells(cells, uint(dx(p.inner)))
	}

	rows := split_cells(cells, '\n')

	for row, y in rows {
		if y + p.inner.min.y >= p.inner.max.y {
			break
		}
		rows[y] = trim_cells(row, dx(p.inner))
		for cx, _ in build_cell_with_xarray(row) {
			x, cell := cx.x, cx.cell
			set_cell(buf, cell, pt_add(pt(x, y), p.inner.min))
		}
	}
}
