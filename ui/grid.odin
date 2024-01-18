package ui

Grid_Item_Type :: distinct uint

COL: Grid_Item_Type : 0
ROW: Grid_Item_Type : 1

Grid :: struct {
	using block: ^Block,
	items:       []^Grid_Item,
}

// GridItem represents either a Row or Column in a grid.
// Holds sizing information and either an []GridItems or a widget.
Grid_Item :: struct {
	type:         Grid_Item_Type,
	x_ratio:      f64,
	y_ratio:      f64,
	width_ratio:  f64,
	height_ratio: f64,
	entry:        []Block, // Entry.type == GridBufferer if IsLeaf else []GridItem
	is_leaf:      bool,
	ratio:        f64,
}

new_grid :: proc() -> Grid {
	b := new_block()
	g := Grid {
		block = b,
	}
	g.border = false
	return g
}
/*
// NewCol takes a height percentage and either a widget or a Row or Column
new_col :: proc(ratio: f64, i: ..Block) -> Grid_Item {
	ok := i[0].drawable
	entry := i[0]
	if !ok do entry = i
	
	return Grid_Item {
		type = COL,
		entry = entry,
		is_leaf = ok,
		ratio = ratio,
	}
}

// NewRow takes a width percentage and either a widget or a Row or Column
new_row :: proc(ratio: f64, i: ..Block) -> Grid_Item {
	ok := i[0].drawable
	entry := i[0]
	if !ok {
		entry = i
	}
	return Grid_Item {
		type = ROW,
		entry = entry,
		is_leaf = ok,
		ratio = ratio,
	}
}

// Set is used to add Columns and Rows to the grid.
// It recursively searches the GridItems, adding leaves to the grid and calculating the dimensions of the leaves.
grid_set :: proc(g: ^Grid, entries: ..Block) {
	entry := Grid_Item{row, entries, false, 1.0}
	grid_set_helper(g, entry, 1.0, 1.0)
}

grid_set_helper :: proc(g: ^Grid, item: Grid_Item, parent_width_ratio, parent_height_ratio: f64) {
	height_ratio: f64
	width_ratio: f64
	switch item.type {
	case col:
		height_ratio = 1.0
		width_ratio = item.ratio
	case row:
		height_ratio = item.ratio
		width_ratio = 1.0
	}
	item.width_ratio = parent_width_ratio * width_ratio
	item.height_ratio = parent_height_ratio * height_ratio

	if item.is_leaf {
		append(&g.items, &item)
	} else {
		x_ratio := 0.0
		y_ratio := 0.0
		cols := false
		rows := false

		children := interface_slice(item.Entry)

		for _, i in children {
			if children[i] == nil {
				continue
			}
			//child, _ := children[i].(GridItem)
			child := children[i]
			child.x_ratio = item.x_ratio + (item.width_ratio * x_ratio)
			child.y_ratio = item.y_ratio + (item.height_ratio * y_ratio)

			switch child.type {
			case col:
				cols = true
				x_ratio += child.ratio
				if rows {
					item.height_ratio /= 2
				}
			case row:
				rows = true
				y_ratio += child.ratio
				if cols {
					item.width_ratio /= 2
				}
			}

			set_helper(g, child, item.width_ratio, item.height_ratio)
		}
	}
}

draw_grid :: proc(g: ^Grid, buf: ^Buffer) {
	width := f64(g.dx()) + 1
	height := f64(g.dy()) + 1

	for item, _ in g.items {
		entry, _ := item.Entry.(Drawable)

		x := int(width * item.x_ratio) + g.min.x
		y := int(height * item.y_ratio) + g.min.y
		w := int(width * item.width_ratio)
		h := int(height * item.height_ratio)

		if x+w > g.dx() do w -= 1
		if y+h > g.dy() do h -= 1
		
		set_rect(entry, x, y, x+w, y+h)

		lock(entry)
		draw(entry, buf)
		unlock(entry)
	}
}
*/
