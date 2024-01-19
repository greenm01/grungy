package ui

render :: proc(items: ..Block) {
	clear()
	for item in items {
		buf := new_buffer(item.rectangle)

		// Add new widgets here
		switch w in item.widget {
		case Paragraph:
			draw_paragraph(w, &buf)
		case Table:
			draw_table(w, &buf)
		}
		
		for point, cell in buf.cell_map {
			if pt_in(point, buf.rectangle) {
				set_cell(
					point.x,
					point.y,
					cell._rune,
					fg = (cell.style.fg+1)|int(cell.style.modifier),
					bg = cell.style.bg+1,
				)
			}
		}
	}
	present()
}
