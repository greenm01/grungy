package ui

render :: proc(blocks: ..^Block) {
	for block in blocks {
		buf := new_buffer(block.rectangle)
		defer del_buffer(buf)

		// Add new widgets here
		switch w in block.widget {
		case ^Paragraph:
			draw_paragraph(w, buf)
		case ^Table:
			draw_table(w, buf)
		case ^List:
			draw_list(w, buf)
		}
				
		for point, cell in buf.cell_map {
			if pt_in(point, buf.rectangle) {
				set_cell(
					point.x,
					point.y,
					cell._rune,
					fg = cell.style.fg|cell.style.modifier,
					bg = cell.style.bg,
				)
			}
		}
	}
}
