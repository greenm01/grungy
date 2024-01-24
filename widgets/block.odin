package widgets

import "../ui"

/* ##############################################################
 * To add a new widget, remember to do two things:
 *     1) Add the widget struct to the Widgets union.
 *     2) Add the widget's type to the render procedure
 * ############################################################## */

// Available widgets. 
Widgets :: union {
	^Paragraph,
	^Table,
	^List,
	^Tree,
}

// Block is the base struct inherited by all widgets.
// Block manages size, position, border, and title.
Block :: struct {
	border:                                                   bool,
	border_style:                                             ui.Style,
	border_left, border_right, border_top, border_bottom:     bool,
	padding_left, padding_right, padding_top, padding_bottom: int,
	using rectangle:                                          ui.Rectangle,
	inner:                                                    ui.Rectangle,
	title:                                                    string,
	title_style:                                              ui.Style,
	drawable:                                                 bool,
	widget:                                                   Widgets,
}

new_block :: proc() -> ^Block {
	b := new(Block)
	b.border = true
	b.border_style = ui.theme.block.border
	b.border_left = true
	b.border_right = true
	b.border_top = true
	b.border_bottom = true
	b.title_style = ui.theme.block.title
	return b
}

del_block :: proc(b: ^Block) {
	free(&b.widget)
	free(b)
}

draw_border_block :: proc(b: ^Block, buf: ^ui.Buffer) {
	vertical_cell := ui.Cell{ui.VERTICAL_LINE, b.border_style}
	horizontal_cell := ui.Cell{ui.HORIZONTAL_LINE, b.border_style}

	// draw lines
	if b.border_top {
		ui.buffer_fill(
			buf, horizontal_cell,
			ui.rect(b.min.x, b.min.y, b.max.x, b.min.y + 1)
		)
	}
	if b.border_bottom {
		ui.buffer_fill(
			buf,
			horizontal_cell,
			ui.rect(b.min.x, b.max.y - 1, b.max.x, b.max.y)
		)
	}
	if b.border_left {
		ui.buffer_fill(
			buf,
			vertical_cell,
			ui.rect(b.min.x, b.min.y, b.min.x + 1, b.max.y)
		)
	}
	if b.border_right {
		ui.buffer_fill(
			buf,
			vertical_cell, 
			ui.rect(b.max.x - 1, b.min.y, b.max.x, b.max.y)
		)
	}

	// draw corners
	if b.border_top && b.border_left {
		ui.buffer_set_cell(
			buf,
			ui.Cell{ui.TOP_LEFT, b.border_style}, 
			b.min
		)
	}
	if b.border_top && b.border_right {
		ui.buffer_set_cell(
			buf,
			ui.Cell{ui.TOP_RIGHT, b.border_style},
			ui.pt(b.max.x - 1, b.min.y)
		)
	}
	if b.border_bottom && b.border_left {
		ui.buffer_set_cell(
			buf,
			ui.Cell{ui.BOTTOM_LEFT, b.border_style},
			ui.pt(b.min.x, b.max.y - 1)
		)
	}
	if b.border_bottom && b.border_right {
		ui.buffer_set_cell(
			buf,
			ui.Cell{ui.BOTTOM_RIGHT, b.border_style},
			ui.pt_sub(b.max, ui.pt(1, 1))
		)
	}
}

draw_block :: proc(b: ^Block, buf: ^ui.Buffer) {
	if b.border do draw_border_block(b, buf)
	ui.buffer_set_string(
		buf,
		b.title,
		b.title_style,
		ui.Point{b.min.x + 2, b.min.y}
	)
}

set_rect :: proc(b: ^Block, x1, y1, x2, y2: int) {
	b.rectangle = ui.rect(x1, y1, x2, y2)
	b.inner = ui.rect(
		b.min.x + 1 + b.padding_left,
		b.min.y + 1 + b.padding_top,
		b.max.x - 1 - b.padding_right,
		b.max.y - 1 - b.padding_bottom,
	)
}

		
