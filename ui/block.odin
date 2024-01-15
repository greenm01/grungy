// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

// Block is the base struct inherited by most widgets.
// Block manages size, position, border, and title.
// It implements all 3 of the methods needed for the `Drawable` interface.
// Custom widgets will override the Draw method.
Block :: struct {
	border:                                                   bool,
	border_style:                                             Style,
	border_left, border_right, border_top, border_bottom:     bool,
	padding_left, padding_right, padding_top, padding_bottom: int,
	using rectangle:                                          Rectangle,
	inner:                                                    Rectangle,
	title:                                                    string,
	title_style:                                              Style,
	derived:                                                  any,
	drawable:                                                 bool,
}

new_block :: proc() -> Block {
	return(
		Block {
			border = true,
			border_style = theme.block.border,
			border_left = true,
			border_right = true,
			border_top = true,
			border_bottom = true,
			title_style = theme.block.title,
		} 
	)
}

draw_border :: proc(b: Block, buf: ^Buffer) {
	vertical_cell := Cell{VERTICAL_LINE, b.border_style}
	horizontal_cell := Cell{HORIZONTAL_LINE, b.border_style}

	// draw lines
	if b.border_top {
		fill(buf, horizontal_cell, rect(b.min.x, b.min.y, b.max.x, b.min.y + 1))
	}
	if b.border_bottom {
		fill(buf, horizontal_cell, rect(b.min.x, b.max.y - 1, b.max.x, b.max.y))
	}
	if b.border_left {
		fill(buf, vertical_cell, rect(b.min.x, b.min.y, b.min.x + 1, b.max.y))
	}
	if b.border_right {
		fill(buf, vertical_cell, rect(b.max.x - 1, b.min.y, b.max.x, b.max.y))
	}

	// draw corners
	if b.border_top && b.border_left {
		set_cell(buf, Cell{TOP_LEFT, b.border_style}, b.min)
	}
	if b.border_top && b.border_right {
		set_cell(buf, Cell{TOP_RIGHT, b.border_style}, pt(b.max.x - 1, b.min.y))
	}
	if b.border_bottom && b.border_left {
		set_cell(buf, Cell{BOTTOM_LEFT, b.border_style}, pt(b.min.x, b.max.y - 1))
	}
	if b.border_bottom && b.border_right {
		set_cell(buf, Cell{BOTTOM_RIGHT, b.border_style}, pt_sub(b.max, pt(1, 1)))
	}
}

// Draw implements the Drawable interface.
draw_block :: proc(b: Block, buf: ^Buffer) {
	if b.border do draw_border(b, buf)
	set_string(buf, b.title, b.title_style, Point{b.min.x + 2, b.min.y})
}

// SetRect implements the Drawable interface.
set_rect :: proc(b: ^Block, x1, y1, x2, y2: int) {
	b.rectangle = rect(x1, y1, x2, y2)
	b.inner = rect(
		b.min.x + 1 + b.padding_left,
		b.min.y + 1 + b.padding_top,
		b.max.x - 1 - b.padding_right,
		b.max.y - 1 - b.padding_bottom,
	)
}

// GetRect implements the Drawable interface.
get_rect :: proc(b: Block) -> Rectangle {
	return b.rectangle
}
				
