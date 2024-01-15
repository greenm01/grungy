// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

draw :: proc {
	draw_block,
	draw_paragraph,
}

render :: proc(items: ..$T) {
	for item in items {
		buf := new_buffer(get_rect(item.block))
		draw(item, buf)
		/*		
		for cell, point in buf.cell_map {
			if point.in(buf.rectangle) {
				tb.set_cell(
					point.x, point.y,
					cell.rune,
					tb.Attribute(cell.Style.Fg+1)|tb.Attribute(cell.Style.Modifier), tb.Attribute(cell.Style.Bg+1),
				)
			}
		}*/
	}
	//tb.flush()
}
