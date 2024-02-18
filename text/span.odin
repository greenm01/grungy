package text

import wc "../deps/karvi/wcwidth"

Span :: struct {
   content: string,
   style:   Style,
}

span_width :: proc(s: Span) -> int {
   return wc.string_width(s.content)   
}
