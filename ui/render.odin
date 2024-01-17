// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

import "core:fmt"

draw :: proc {
	draw_block,
	draw_paragraph,
}

render :: proc(items: ..^Block) {
	clear()
	for item in items {
		buf := new_buffer(get_rect(item))
		para := item.widget.(Paragraph)
		draw(para, buf)
		fmt.println("draw")
		for point, cell in buf.cell_map {
			fmt.println(point)
			if pt_in(point, buf.rectangle) {
				fg := (cell.style.fg+1)|int(cell.style.modifier)
				bg := cell.style.bg+1
				fmt.println("foo")  
				tb_set_cell(point.x, point.y, cell._rune, fg, bg)
			}
		}
	}
	present()
}
