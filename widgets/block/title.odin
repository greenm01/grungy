package block

import "../../layout"
import "../../text"

Alignment :: layout.Alignment
Line      :: text.Line

Title :: struct {
   content:   Line,
   alignment: Alignment,
   position:  Position,
}

Position :: enum {
   Top,
   Bottom,
}
