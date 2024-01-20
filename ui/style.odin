package ui

ALIGN_LEFT   :: 0
ALIGN_CENTER :: 1
ALIGN_RIGHT  :: 2

// Style represents the style of one terminal cell
Style :: struct {
	fg:       Color,
	bg:       Color,
	modifier: Modifier,
}

// StyleClear represents a default Style, with no colors or modifiers
STYLE_CLEAR :: Style{DEFAULT, DEFAULT, MOD_CLEAR}

// NewStyle returns a new style
new_style :: proc(fg: Color, bg := DEFAULT, modifier := MOD_CLEAR) -> Style {
	return Style{fg, bg, modifier}
}
