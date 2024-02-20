package text

import "core:fmt"

import "../style"

Text :: struct {
   lines:     []^Line,
   style:     ^Style,
   alignment: Alignment,
}

// creates raw text with no style, aligned left
raw_text :: proc(str: string) -> (text: ^Text) {
   text = new(Text)
   text.lines = []^Line{raw_line(str)}
   text.alignment = Alignment.Left
   return   
}

debug_print_text :: proc(text: ^Text) {
   for line in text.lines {
      for span in line.spans {
         fmt.print(span.content)
      }
      fmt.println()
   }
}
