package text

import "core:unicode/utf8"

import "../style"
import wc "../deps/karvi/wcwidth"

Span :: struct {
   content: string,
   style:   ^Style,
}

raw_span :: proc(str: string) -> (span: ^Span) {
   span = new(Span)
   span.content = str
   span.style = style.new_style()
   return
}

span_width :: proc(s: ^Span) -> int {
   return wc.string_width(s.content)   
}

span_to_graphemes :: proc(span: ^Span) -> []Grapheme {
   runes := utf8.string_to_runes(span.content)
   graphemes := make([dynamic]Grapheme)
   for r in runes {
      if r != '\n' {
         width := wc.rune_width(r)
         append(&graphemes, Grapheme{r, span.style, width})
      }
   }
   return graphemes[:]
}
