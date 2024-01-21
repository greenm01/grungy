package ui

import "core:unicode/utf8"

import wc "../deps/wcwidth"

// Cell represents a viewable terminal cell
Cell :: struct {
	_rune: rune,
	style: Style,
}

CELL_CLEAR :: Cell{' ', STYLE_CLEAR}

// NewCell takes 1 to 2 arguments
// 1st argument = rune
// 2nd argument = optional style
new_cell :: proc(r: rune, style := STYLE_CLEAR) -> Cell {
	return Cell{r, style}
}

// Buffer represents a section of a terminal and is a renderable rectangle of cells.
Buffer :: struct {
	rectangle: Rectangle,
	cell_map:  map[Point]Cell,
}

del_buffer :: proc(b: ^Buffer) {
	delete(b.cell_map)
	free(b)
}

new_buffer :: proc(r: Rectangle) -> ^Buffer {
	buf := new(Buffer)
	buf.rectangle = r
	buf.cell_map = make(map[Point]Cell)
	buffer_fill(buf, CELL_CLEAR, r) // clears out area
	return buf
}

buffer_get_cell :: proc(b: ^Buffer, p: Point) -> Cell {
	return b.cell_map[p]
}

buffer_set_cell :: proc(b: ^Buffer, c: Cell, p: Point) {
	b.cell_map[p] = c
}

buffer_fill :: proc(b: ^Buffer, c: Cell, rect: Rectangle) {
	for x := rect.min.x; x < rect.max.x; x += 1 {
		for y := rect.min.y; y < rect.max.y; y += 1 {
			buffer_set_cell(b, c, Point{x, y})
		}
	}
}

buffer_set_string :: proc(b: ^Buffer, s: string, style: Style, p: Point) {
	runes := utf8.string_to_runes(s)
	x: int
	for r in runes {
		buffer_set_cell(b, Cell{r, style}, Point{p.x + x, p.y})
		x += wc.rune_width(r)
	}
}
