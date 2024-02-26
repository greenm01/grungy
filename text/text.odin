package text

import "core:fmt"
import "core:strings"
import "core:unicode/utf8"

import "../style"

Text :: struct {
   lines:     [dynamic]^Line,
   style:     ^Style,
   alignment: Alignment,
}

// creates raw text with no style, aligned left
raw_text :: proc(str: string) -> (text: ^Text) {
   lines := make([dynamic]^Line)
   runes := utf8.string_to_runes(str)
   line  := make([dynamic]rune)

   for r, i in runes {
      append(&line, runes[i])
      // creates new lines on newline
      if r == '\n' {
         pop(&line)
         append(&lines, raw_line(utf8.runes_to_string(line[:])))
         clear(&line)
      }     
   }

   append(&lines, raw_line(utf8.runes_to_string(line[:])))

   text = new(Text)
   text.lines = lines
   text.style = style.new_style()
   text.alignment = Alignment.Left
   return   
}

text_height :: proc(txt: ^Text) -> int {
   return len(txt.lines)   
}

debug_print_text :: proc(text: ^Text) {
   for line in text.lines {
      for span in line.spans {
         fmt.print(span.content)
      }
      fmt.println()
   }
}
