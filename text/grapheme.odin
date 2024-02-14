package text

import "../backend"

Style :: backend.Style

Grapheme :: struct {
   symbol: rune,
   style:  Style,
   width:  int,
}
