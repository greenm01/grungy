package text

import "../layout"

Text :: struct {
   lines:     []Line,
   style:     Style,
   alignment: layout.Alignment,
}
