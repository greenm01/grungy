package buffer

import "../deps/karvi"

Color :: karvi.Color

Cell :: struct {
	symbol:   rune
	fg:       Color,
	bg,       Color,
	modifier: Modifier,
	skip:     bool,
}
