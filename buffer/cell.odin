package buffer

import "../backend"

Color :: backend.Color
Modifier :: backend.Modifier

Cell :: struct {
	symbol:   rune,
	fg:       Color,
	bg,       Color,
	modifier: Modifier,
	skip:     bool,
}
