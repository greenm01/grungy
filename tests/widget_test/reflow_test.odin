package widget_test

import "core:testing"
import "core:fmt"
import "core:unicode/utf8"

import txt "../../text"
import wgt "../../widgets"

expect  :: testing.expect
log     :: testing.log
errorf  :: testing.errorf

Composer :: enum {
   Word_Wrapper,
   Line_Truncator,
}

Composer_Options :: struct {
   composer: Composer,
   trim:     bool,
}

run_composer :: proc(
   copt:  Composer_Options,
   str:   string,
   width: int
) -> ([]string, []int, []txt.Alignment){

   text := txt.raw_text(str)
   
   num_lines := len(text.lines)
   lines := make([][dynamic]txt.Grapheme, num_lines)
   defer delete(lines)
   alignments := make([]txt.Alignment, num_lines)
   defer delete(alignments)

   for line, i in text.lines {
      alignments[i] = line.alignment
      for span in line.spans {
          append(&lines[i], ..txt.span_to_graphemes(span)[:])
      }
   }

   line_composer := wgt.new_word_wrapper(lines, alignments, width, copt.trim)
   defer wgt.del_word_wrapper(line_composer)

   count: int
   for wgt.wrap_next_line(line_composer) != nil do count += 1

   txt_lines  := make([]string, count)
   txt_aligns := make([]txt.Alignment, count) 
   widths     := make([]int, count) 
   for line, i in line_composer.wrapped_lines {
      runes := make([]rune, len(line))
      for r, x in line do runes[x] = r.symbol
      txt_lines[i] = utf8.runes_to_string(runes)
      //txt_aligns[i] = line_composer.alignments[i]
      widths[i] = len(line)
   }

   return txt_lines, widths, txt_aligns
   
}

@(test)
test_word_wrap :: proc(t: ^testing.T) {
   
}

main :: proc() {

   using Composer
   
   width := 20 
   trim := true
   text := "abcdefg\nhijklmno\npabcdefg\nhijklmn\nopabcdefghijk\nlmnopabcd\n\n\nefghijklmno"
   ops := Composer_Options{Word_Wrapper, trim}
   results, _, _ := run_composer(ops, text, width)
   for s in results do fmt.println(s)
   fmt.println()

   width = 20
   text = "abcdefghijklmnopabcdefghijklmnopabcdefghijklmnopabcdefghijklmno" 
   results, _, _ = run_composer(ops, text, width)
   for s in results do fmt.println(s)
   fmt.println()
   
   width = 50      
   text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
   results, _, _ = run_composer(ops, text, width)
   for s in results do fmt.println(s)
   fmt.println()
   
   width = 4      
   text = "foo bar was   here"
   results, _, _ = run_composer(ops, text, width)
   for s in results do fmt.println(s)
   fmt.println()

   width = 20
   text =
      "abcd efghij klmnopabcd efgh ijklmnopabcdefg hijkl mnopab c d e f g h i j k l m n o"
   results, _, _ = run_composer(ops, text, width)
   for s in results do fmt.println(s)
   fmt.println()
   text=
      "abcd efghij    klmnopabcd efgh     ijklmnopabcdefg hijkl mnopab c d e f g h i j k l m n o"
   results, _, _ = run_composer(ops, text, width)
   for s in results do fmt.println(s)
   fmt.println()
   
}
