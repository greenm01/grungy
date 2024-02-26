package widgets

import "core:fmt" // TODO: remove

import txt "../text"

// Space
SP:   rune: '\x20'
// None breaking space
NBSP: rune: '\xA0'

Wrapped_Line :: struct {
   line: [dynamic]Grapheme,
   width: int,
   alignment: Alignment,
}

del_wrapped_line :: proc(wl: ^Wrapped_Line) {
   free(wl)
}

// A state machine that wraps lines on word boundaries
Word_Wrapper :: struct {
   input_lines:       [][dynamic]Grapheme,
   line_index:        int,
   alignments:        []Alignment,
   wrapped_lines:     [dynamic][dynamic]Grapheme,
   wrap_index:        int,
   current_alignment: Alignment,
   current_line:      [dynamic]Grapheme,
   trim:              bool,
   max_line_width:    int,
}

reset_word_wrapper :: proc(wr: ^Word_Wrapper) {
   wr.line_index = 0
   wr.wrap_index = 0
}

new_word_wrapper :: proc(lines: [][dynamic]Grapheme, alignments: []Alignment,
   max_line_width: int, trim: bool) -> (wr: ^Word_Wrapper) {
   wr = new(Word_Wrapper)
   wr.input_lines = lines
   wr.alignments = alignments
   wr.max_line_width = max_line_width
   wr.current_alignment = Alignment.Left
   wr.trim = trim
   return
}

del_word_wrapper :: proc(wr: ^Word_Wrapper) {
   delete(wr.wrapped_lines)
   free(wr)
}

debug_print_line :: proc(line: [dynamic]Grapheme) {
   for g in line {
      fmt.print(g.symbol)
   }
   fmt.println()
}

wrap_next_line :: proc(wr: ^Word_Wrapper) -> (wl: ^Wrapped_Line) {
   if wr.max_line_width <= 0 do return

   current_line: [dynamic]Grapheme
   line_width: int

   // Try to repeatedly retreive the next line
   for current_line == nil {
      num_lines := len(wr.wrapped_lines)
      // Retreive next preprossed wrapped line    
      if num_lines > 0 && wr.wrap_index <= num_lines - 1 {
         current_line = wr.wrapped_lines[wr.wrap_index]
         line_width = len(current_line)
         break
      }

      // No more whole lines available -> stop repeatedly retrieving next wrapped line
      if wr.line_index > len(wr.input_lines) - 1 do break

      line_symbols := wr.input_lines[wr.line_index]
      alignment := wr.alignments[wr.line_index]
      
      wr.line_index += 1
      wr.current_alignment = alignment

      wrapped_lines := make([dynamic][dynamic]Grapheme)
      current_line = make([dynamic]Grapheme)
      current_line_width: int
      
      unfinished_word := make([dynamic]Grapheme)
      word_width: int
      
      unfinished_whitespaces := make([dynamic]Grapheme)
      whitespace_width: int

      has_seen_non_whitespace: bool
      for g in line_symbols {
         symbol       := g.symbol
         style        := g.style
         symbol_width := g.width
         // Ignore characters wider than the total max width
         if symbol_width > wr.max_line_width do continue

         symbol_whitespace := (symbol == SP && symbol != NBSP)
         line_empty := len(current_line) == 0

         // Append finished word to current line
         if has_seen_non_whitespace && symbol_whitespace ||
            // Append if trimmed (whitespaces removed) word would overflow
            word_width + symbol_width > wr.max_line_width && line_empty && wr.trim ||
            // Append if removed whitespace would overflow -> reset whitespace counting to prevent overflow
            whitespace_width + symbol_width > wr.max_line_width && line_empty && wr.trim ||
            // Append if complete word would overflow
            word_width + whitespace_width + symbol_width > wr.max_line_width && line_empty && !wr.trim ||
            // Append if last word (no spaces after) would overflow
            whitespace_width + word_width >= wr.max_line_width 
         {
            if !line_empty || !wr.trim {
               // Also append whitespaces if not trimming or current line is not empty
               append(&current_line, ..unfinished_whitespaces[:])
               current_line_width += whitespace_width
            }
            // Append trimmed word
            append(&current_line, ..unfinished_word[:])
            current_line_width += word_width

            // Clear buffers
            unfinished_word = make([dynamic]Grapheme)
            unfinished_whitespaces = make([dynamic]Grapheme)
            whitespace_width = 0
            word_width = 0
         }

         // Append the unfinished wrapped line to wrapped lines if it is as wide as max line width
         if current_line_width >= wr.max_line_width ||
             // or if it would be too long with the current partially processed word added
             current_line_width + whitespace_width + word_width >= wr.max_line_width && symbol_width > 0
         {
            remaining_width := wr.max_line_width - current_line_width
            append(&wrapped_lines, current_line)
            current_line = make([dynamic]Grapheme)
            current_line_width = 0

            // Remove all whitespaces till end of just appended wrapped line + next whitespace
            //if remaining_width > 0 do fmt.println("remaining =", remaining_width)
            for i in 0..=remaining_width {
               if len(unfinished_whitespaces) > 1 {
                  //ordered_remove(&unfinished_whitespaces, 0)
                  pop(&unfinished_whitespaces)
               }
            }

            // In case all whitespaces have been exhausted
            // Prevent first whitespace to count towards next word
            if symbol_whitespace && len(unfinished_whitespaces) == 0 do continue
         }

         // Append symbol to unfinished, partially processed word
         if symbol_whitespace {
             whitespace_width += symbol_width;
             append(&unfinished_whitespaces, txt.new_grapheme(symbol, style))
         } else {
             word_width += symbol_width;
             append(&unfinished_word, txt.new_grapheme(symbol, style))
         }

         has_seen_non_whitespace = !symbol_whitespace
      }

      // Append remaining text parts
      if len(unfinished_word) > 0 || len(unfinished_whitespaces) > 0 {
         if len(current_line) == 0 && len(unfinished_word) == 0 {
            append(&wrapped_lines, make([dynamic]Grapheme))
         } else if !wr.trim || len(current_line) > 0 {
            append(&current_line, ..unfinished_whitespaces[:])
         }
         append(&current_line, ..unfinished_word[:])
      }

      if len(current_line) > 0 {
         append(&wrapped_lines, current_line)
      }
      if len(wrapped_lines) == 0 {
         // Append empty line if there was nothing to wrap in the first place
         append(&wrapped_lines, make([dynamic]Grapheme)) 
      }
      append(&wr.wrapped_lines, ..wrapped_lines[:])

   }

   if current_line != nil {
      wr.current_line = current_line
      wr.wrap_index += 1
   
      wl = new(Wrapped_Line)
      wl.line = wr.current_line
      wl.width = line_width
      wl.alignment = wr.current_alignment
   }
   
   return
}

