package grungy

import "core:fmt"

import "backend"
import "buffer"
import "text"
import "layout"

main :: proc() {
   rect := layout.Rect{1, 2, 3, 4}
   ofst := layout.Offset{5, 6}
   r2 := layout.offset(rect, ofst)
   fmt.println(rect, r2)
}
