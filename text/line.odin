package text

Line :: struct {
   spans:     []Span,
   style:     Style,
   alignment: Alignment,
}

line_width :: proc(l: Line) -> (width: int) {
   for s in l.spans {
      width += span_width(s)
   }
   return
}
