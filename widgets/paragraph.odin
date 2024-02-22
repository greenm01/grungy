package widgets

import "../text"

Paragraph :: struct {
    using block: ^Block,
    style:       ^Style,
    // enable line wrapping
    wrap:        bool,
    // trim leading white spaces
    trim:        bool,     
    text:        ^Text,
    scroll:      [2]int,
    alignment:   Alignment,
}

new_paragraph :: proc(text: ^Text, wrap := true, trim := true) -> (block: ^Block) {
    block = new(Block)
    block.widget = Paragraph{
        block = block,
        alignment = Alignment.Left,
        text = text,
        wrap = wrap,
        trim = trim,
    }
    return    
}

Horizontal :: distinct int
Vertical :: distinct int

// Calculates the number of lines needed to render
// Accounts for word wrapping if enabled in paragraph
line_count :: proc(p: ^Paragraph, width: int) -> int {
    if width < 1 do return 0

    if p.wrap {
        lines := make(map[int][]Grapheme)
        aligns := make(map[int]Alignment)
        defer delete(lines)
        defer delete(aligns)
        
        for line, i in p.text.lines {
            aligns[i] = line.alignment
            for span in line.spans {
                lines[i] = text.span_to_graphemes(span)
            }
        }

        line_composer := new_word_wrapper(lines, aligns, width, p.trim)
        defer del_word_wrapper(line_composer)

        count: int
        for word_wrap_next_line(line_composer) != nil {
            count += 1
        }
        return count
    } else {
        return text.text_height(p.text)
    }
}

render_paragraph :: proc(p: ^Paragraph, buf: ^Buffer) {
        
}
