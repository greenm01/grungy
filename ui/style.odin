package ui

// Color is an integer from -1 to 255
// -1 = ColorClear
// 0-255 = Xterm colors
Color :: int

// ColorClear clears the Fg or Bg color of a Style
COLOR_CLEAR: Color : -1

// Basic terminal colors
BLACK: Color : 0
RED: Color : 1
GREEN: Color : 2
YELLOW: Color : 3
BLUE: Color : 4
MAGENTA: Color : 5
CYAN: Color : 6
WHITE: Color : 7

Modifier :: uint

// ModifierClear clears any modifiers
MOD_CLEAR: Modifier : 0
BOLD: Modifier : 1 << 9
UNDERLINE: Modifier : 1 << 10
REVERSE: Modifier : 1 << 11

// Style represents the style of one terminal cell
Style :: struct {
	fg:       Color,
	bg:       Color,
	modifier: Modifier,
}

// StyleClear represents a default Style, with no colors or modifiers
STYLE_CLEAR :: Style{COLOR_CLEAR, COLOR_CLEAR, MOD_CLEAR}

// NewStyle returns a new style
new_style :: proc(fg: Color, bg := COLOR_CLEAR, modifier := MOD_CLEAR) -> Style {
	return Style{fg, bg, modifier}
}
