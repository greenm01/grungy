package text

import "../style"

Line :: struct {
   spans:     [dynamic]^Span,
   style:     ^Style,
   alignment: Alignment,
}

// creates a new line with default styling, aligned left
raw_line :: proc(str: string) -> (line: ^Line) {
   line = new(Line)
   line.spans = make([dynamic]^Span)
   append(&line.spans, raw_span(str))
   line.style = style.new_style()
   line.alignment = Alignment.Left
   return
}

line_width :: proc(l: Line) -> (width: int) {
   for s in l.spans {
      width += span_width(s)
   }
   return
}
