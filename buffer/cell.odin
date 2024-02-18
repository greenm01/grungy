package buffer

Cell :: struct {
	symbol:    rune,
	width:     uint,
	fg:        Color,
	bg:        Color,
	modifier:  Modifier,
	skip:      bool,
}

default_cell :: proc() -> Cell {
	using Color
	return Cell {
		symbol = ' ',
		width = 1,
		fg = Color_Default,
		bg = Color_Default,
		modifier = Modifier.None,
		skip = false,
	}
}

/// Sets the symbol of the cell.
set_symbol :: proc(cell: ^Cell, symbol: rune) {
    cell.symbol = symbol
}

/// Sets the style of the cell.
///
///  `style` accepts any type that is convertible to [`Style`] (e.g. [`Style`], [`Color`], or
/// your own type that implements [`Into<Style>`]).
set_style :: proc(cell: ^Cell, style: Style) {
	cell.fg = style.fg
	cell.bg = style.bg
	cell.modifier = style.modifier
}
