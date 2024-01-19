package ui

render :: proc(items: ..Block) {
	clear()
	for item in items {
		widget: Paragraph
		widget = item.widget.? // type inference magic
		buf := new_buffer(item.rectangle)
		draw(widget, &buf)
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
