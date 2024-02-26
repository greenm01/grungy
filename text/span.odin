package text

import "core:unicode/utf8"

import "../style"
import wc "../deps/karvi/wcwidth"

Span :: struct {
   content: []rune,
   style:   ^Style,
}

raw_span :: proc(str: string) -> (span: ^Span) {
   span = new(Span)
   span.content = utf8.string_to_runes(str)
   span.style = style.new_style()
   return
}

span_width :: proc(s: ^Span) -> int {
   return len(s.content)   
}

span_to_graphemes :: proc(span: ^Span) -> []Grapheme {
   graphemes := make([dynamic]Grapheme)
   for rune in span.content {
      width := wc.rune_width(rune)
      append(&graphemes, Grapheme{rune, span.style, width})
   }
   return graphemes[:]
}
