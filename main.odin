package grungy

import "core:fmt"

import "backend"
import "buffer"
import "text"
import "layout"
import "style"
import "widgets"

main :: proc() {
   rect := layout.Rect{1, 2, 3, 4}
   ofst := layout.Offset{5, 6}
   r2 := layout.offset(rect, ofst)
   fmt.println(rect, r2)

   using style.Color
   fmt.println(int(Color_Red), int(Color_Black))
}
