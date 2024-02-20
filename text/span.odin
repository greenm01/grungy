package text

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
