// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

draw :: proc {
	draw_block,
	draw_paragraph,
}

render :: proc(items: ..Block) {
	clear()
	for item in items {
		buf := new_buffer(item.rectangle)
		para := item.widget.(Paragraph)
		draw(para, &buf)
		for point, cell in buf.cell_map {
			if pt_in(point, buf.rectangle) {
				fg := (cell.style.fg+1)|int(cell.style.modifier)
				bg := cell.style.bg+1
				tb_set_cell(point.x, point.y, cell._rune, fg, bg)
			}
		}
	}
	present()
}
