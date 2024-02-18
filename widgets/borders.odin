package widget

Borders :: distinct u8 

/// Show no border (default)
NONE:   Borders : 0b0000
/// Show the top border
TOP:    Borders : 0b0001
/// Show the right border
RIGHT:  Borders : 0b0010
/// Show the bottom border
BOTTOM: Borders : 0b0100
/// Show the left border
LEFT:   Borders : 0b1000
/// Show all borders
ALL:    Borders : TOP | RIGHT | BOTTOM | LEFT

