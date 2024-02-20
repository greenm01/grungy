package buffer

import "core:math"
import "core:unicode/utf8"

import wc "../deps/karvi/wcwidth"

import "../style"
import "../layout"
import "../text"

Buffer :: struct {
   area:    Rect,
   content: map[Point]Cell,
}

