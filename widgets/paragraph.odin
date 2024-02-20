package widgets

Paragraph :: struct {
    using block: ^Block,
    style:       Style,
    wrap:        Wrap,
    text:        Text,
    scroll:      [2]int,
    alignment:   Alignment,
}

new_paragraph :: proc(text: Text) -> (block: ^Block) {
    block = new(Block)
    block.widget = Paragraph{
        block = block,
        alignment = Alignment.Left,
        text = text,
    }
    return    
}

Wrap :: struct {
    trim: bool,
}

Horizontal :: distinct int
Vertical :: distinct int

render_paragraph :: proc(p: ^Paragraph, buf: ^Buffer) {
        
}
