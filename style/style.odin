package style

// `style` contains the primitives used to control how your user interface will look.

// Text style modifiers
Modifier :: enum {
	None,
	Bold,
	Faint,
	Italic,
	Underline,
	Blink,
	Reverse,
	Crossout,
	Overline,
}

// Style lets you control the main characteristics of the displayed elements.
Style :: struct {
   fg:       Color,
   bg:       Color,
   modifier: Modifier,
}

// Default style has no color or modifier
new_style :: proc(fg := Color.Color_Default, bg := Color.Color_Default,
	mod := Modifier.None) -> (style: ^Style) {
	style = new(Style)
	style.fg = fg
	style.bg = bg
	style.modifier = mod
	return
}

/// Results in a combined style that is equivalent to applying the two individual styles to
/// a style one after the other
patch :: proc(s, other: Style) -> Style {
	fg := s.fg | other.fg
	bg := s.bg | other.bg
	mod := s.modifier | other.modifier
	return Style {fg, bg, mod}
} 
