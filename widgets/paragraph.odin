package widgets

import "core:fmt" // TODO: remove

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
line_count :: proc(p: ^Paragraph, width: int) -> (count: int) {
    if width < 1 do return 0

    if p.wrap {
        num_lines := len(p.text.lines)
        lines := make([][dynamic]Grapheme, num_lines)
        defer delete(lines)
        alignments := make([]Alignment, num_lines)
        defer delete(alignments)
        
        for line, i in p.text.lines {
            alignments[i] = line.alignment
            for span in line.spans {
                append(&lines[i], ..text.span_to_graphemes(span)[:])
            }
        }

        line_composer := new_word_wrapper(lines, alignments, width, p.trim)
        defer del_word_wrapper(line_composer)

        for !wrap_next_line(line_composer) do count += 1

        for line in line_composer.wrapped_lines {
            for g in line.line {
                fmt.print(g.symbol)
            }
            fmt.println()            
        }

        return
    } 
    count = text.text_height(p.text)
    return 
}

render_paragraph :: proc(p: ^Paragraph, buf: ^Buffer) {
        
}
