// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

import "core:fmt"
import "core:math"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

import wc "wcwidth"
import "wordwrap"

// TrimString trims a string to a max length and adds '…' to the end if it was trimmed.
trim_string :: proc(s: string, w: int) -> string {
	if w <= 0 do return ""
	if wc.string_width(s) > w {
		return wc.truncate(s, w, utf8.runes_to_string([]rune{ELLIPSES}))
	}
	return s
}

select_color :: proc(colors: []Color, index: int) -> Color {
	return colors[index % len(colors)]
}

select_style :: proc(styles: []Style, index: int) -> Style {
	return styles[index % len(styles)]
}

// Math ------------------------------------------------------------------------

sum_int_slice :: proc(slice: []int) -> int {
	sum: int
	for val in slice {
		sum += val
	}
	return sum
}

sum_f64_slice :: proc(data: []f64) -> f64 {
	sum: f64
	for v in data {
		sum += v
	}
	return sum
}

get_max_int_from_slice :: proc(slice: []int) -> int {
	if len(slice) == 0 {
		fmt.println("cannot get max value from empty slice")
		os.exit(1)
	}
	max: int
	for val in slice {
		if val > max {
			max = val
		}
	}
	return max
}

get_max_f64_from_slice :: proc(slice: []f64) -> f64 {
	if len(slice) == 0 {
		fmt.println("cannot get max value from empty slice")
		os.exit(1)
	}
	max: f64
	for val in slice {
		if val > max {
			max = val
		}
	}
	return max
}

get_max_f64_from_2dslice :: proc(slices: [][]f64) -> f64 {
	if len(slices) == 0 {
		fmt.println("cannot get max value from empty slice")
		os.exit(1)
	}
	max: f64
	for slice in slices {
		for val in slice {
			if val > max {
				max = val
			}
		}
	}
	return max
}

round_f64 :: proc(x: f64) -> f64 {
	return math.floor_f64(x + 0.5)
}

floor_f64 :: proc(x: f64) -> f64 {
	return math.floor_f64(x)
}

abs_int :: proc(x: int) -> int {
	if x >= 0 do return x
	return -x
}

min_f64 :: proc(x, y: f64) -> f64 {
	if x < y do return x
	return y
}

max_f64 :: proc(x, y: f64) -> f64 {
	if x > y do return x
	return y
}

max_int :: proc(x, y: int) -> int {
	if x > y do return x
	return y
}

min_int :: proc(x, y: int) -> int {
	if x < y do return x
	return y
}

// []Cell ----------------------------------------------------------------------

// WrapCells takes []Cell and inserts Cells containing '\n' wherever a linebreak should go.
wrap_cells :: proc(cells: []Cell, width: uint) -> []Cell {
	str := cells_to_string(cells)
	wrapped := wordwrap.wrap_string(str, width)
	wrapped_cells := make([]Cell, len(wrapped))
	i: int
	for _rune in wrapped {
		if _rune == '\n' {
			wrapped_cells[i] = Cell{_rune, STYLE_CLEAR}
		} else {
			wrapped_cells[i] = Cell{_rune, cells[i].style}
		}
		i += 1
	}
	return wrapped_cells
}

runes_to_styled_cells :: proc(runes: []rune, style: Style) -> []Cell {
	cells := make([]Cell, len(runes))
	for r, i in runes {
		cells[i] = Cell{r, style}
	}
	return cells
}

cells_to_string :: proc(cells: []Cell) -> string {
	runes := make([]rune, len(cells))
	defer delete(runes)
	for cell, i in cells {
		runes[i] = cell._rune
	}
	return utf8.runes_to_string(runes)
}

trim_cells :: proc(cells: []Cell, w: int) -> []Cell {
	s := cells_to_string(cells)
	s = trim_string(s, w)
	runes := utf8.string_to_runes(s)
	new_cells := make([]Cell, len(runes))
	defer delete(new_cells)
	for r, i in runes {
		new_cells[i] = Cell{r, cells[i].style}
	}
	return new_cells[:]
}

split_cells :: proc(cells: []Cell, r: rune) -> [][]Cell {
	left: [dynamic]Cell
	defer delete(left)
	temp: [dynamic]Cell
	defer delete(temp)
	for cell in cells {
		if cell._rune == r {
			append(&left, ..temp[:])
			clear_dynamic_array(&temp)
		} else {
			append(&temp, cell)
		}
	}

	split_cells := [][]Cell{left[:], temp[:]}

	return split_cells
}

Cell_With_X :: struct {
	x:    int,
	cell: Cell,
}

build_cell_with_xarray :: proc(cells: []Cell) -> []Cell_With_X {
	cell_with_xarray := make([]Cell_With_X, len(cells))
	index: int
	for cell, i in cells {
		cell_with_xarray[i] = Cell_With_X{index, cell}
		index += wc.rune_width(cell._rune)
	}
	return cell_with_xarray
}
