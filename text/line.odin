package text

import "../layout"

Alignment :: layout.Alignment

Line :: struct {
   spans: []Span,
   style: Style,
   alignment: Alignment,
}
