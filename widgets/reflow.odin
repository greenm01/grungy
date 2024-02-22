package widgets

Wrapped_Line :: struct {
   line: [dynamic]Grapheme,
   width: int,
   alignment: Alignment,
}

del_wrapped_line :: proc(wl: ^Wrapped_Line) {
   delete(wl.line)
   free(wl)
}

// A state machine that wraps lines on word boundaries
Word_Wrapper :: struct {
   input_lines:       map[int][]Grapheme,
   aligns:            map[int]Alignment,
   max_width:         int,
   wrapped_lines:     map[int][dynamic]Grapheme,
   current_align:     Alignment,
   current_line:      [dynamic]Grapheme,
   trim:              bool,
}

new_word_wrapper :: proc(lines: map[int][]Grapheme, aligns: map[int]Alignment,
   max_width: int, trim: bool) -> (wr: ^Word_Wrapper) {
   wr = new(Word_Wrapper)
   wr.input_lines = lines
   wr.aligns = aligns
   wr.max_width = max_width
   wr.current_align = Alignment.Left
   wr.trim = trim
   return
}

del_word_wrapper :: proc(wr: ^Word_Wrapper) {
   delete(wr.wrapped_lines)
   delete(wr.current_line)
   free(wr)
}

word_wrap_next_line :: proc(wr: ^Word_Wrapper) -> (wl: ^Wrapped_Line) {
   return
}

