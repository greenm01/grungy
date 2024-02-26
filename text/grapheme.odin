package text

import wc "../deps/karvi/wcwidth"

Grapheme :: struct {
   symbol: rune,
   style:  ^Style,
   width:  int,
}

new_grapheme :: proc(symbol: rune, style: ^Style) -> Grapheme {
   width := wc.rune_width(symbol) 
   return Grapheme{symbol, style, width}
}
