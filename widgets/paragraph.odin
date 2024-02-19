package widgets

Paragraph :: struct {
    using block: ^Block,
    style:       Style,
    wrap:        Wrap,
    text:        Text,
    scroll:      [2]int,
    alignment:   Alignment,
}

new_paragraph :: proc() -> (block: ^Block) {
    block = new(Block)
    block.widget = Paragraph{
        block = block,
        alignment = Alignment.Left,
    }
    return    
}

Wrap :: struct {
    trim: bool,
}

Horizontal :: distinct int
Vertical :: distinct int
