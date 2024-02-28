package widget_test

import "core:strings"
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

test_string_slice :: proc(t: ^testing.T, input, result: []string) {
   len_expect := len(input)
   len_result := len(result)
   expect(t, len_expect == len_result, fmt.tprintf("expect string slice length %d, got %d", len_expect, len_result))
   for e, i in input {
      expect(t, result[i] == e, fmt.tprintf("expect %s, got %s", e, result[i]))
   }
}

@(test)
line_composer_short_words :: proc(t: ^testing.T) {
    using Composer
   
   width := 4 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   
   text := "foo bar was here"
   results, _, _ := run_composer(ops, text, width)

   words := []string{"foo", "bar", "was", "here"}
   test_string_slice(t, words, results)  
}

@(test)
line_composer_short_lines :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   
   text := "abcdefg\nhijklmno\npabcdefg\nhijklmn\nopabcdefghijk\nlmnopabcd\n\n\nefghijklmno"
   results, _, _ := run_composer(ops, text, width)

   wrapped := strings.split(text, "\n")
   test_string_slice(t, wrapped, results)
}

@(test)
line_composer_long_word :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   
   text := "abcdefghijklmnopabcdefghijklmnopabcdefghijklmnopabcdefghijklmno"
   results, _, _ := run_composer(ops, text, width)

   wrapped := []string {
      text[:width],
      text[width:width*2],
      text[width*2:width*3],
      text[width*3:],
   }
   test_string_slice(t, wrapped, results)
}

@(test)
line_composer_long_sentence :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}

   text :=
      "abcd efghij klmnopabcd efgh ijklmnopabcdefg hijkl mnopab c d e f g h i j k l m n o"
   results, _, _ := run_composer(ops, text, width)

   word_wrapped := []string {
      "abcd efghij",
      "klmnopabcd efgh",
      "ijklmnopabcdefg",
      "hijkl mnopab c d e f",
      "g h i j k l m n o",
   }
   test_string_slice(t, word_wrapped, results)

   text=
      "abcd efghij    klmnopabcd efgh     ijklmnopabcdefg hijkl mnopab c d e f g h i j k l m n o"
   results, _, _ = run_composer(ops, text, width)

   test_string_slice(t, word_wrapped, results)
}

@(test)
line_composer_zero_width :: proc(t: ^testing.T) {
   using Composer
   
   width := 0 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}

   text := "abcd efghij klmnopabcd efgh ijklmnopabcdefg hijkl mnopab "
   results, _, _ := run_composer(ops, text, width)

   expected := []string {}
   test_string_slice(t, expected, results)  
}

@(test)
line_composer_max_line_width_of_1 :: proc(t: ^testing.T) {
   using Composer
   
   width := 1 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}

   text := "abcd efghij klmnopabcd efgh ijklmnopabcdefg hijkl mnopab "
   results, _, _ := run_composer(ops, text, width)

   expected := make([dynamic]string)
   defer delete(expected)

   for t in text {
      if t != ' ' do append(&expected, utf8.runes_to_string([]rune{t}))
   }
   test_string_slice(t, expected[:], results)  
}

@(test)
line_composer_max_line_width_of_1_double_width_characters :: proc(t: ^testing.T) {
   using Composer
   
   width := 1 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   text :=
      "コンピュータ上で文字を扱う場合、典型的には文字\naaa\naによる通信を行う場合にその両端点では、"
   results, _, _ := run_composer(ops, text, width)

   expected := []string{"", "a", "a", "a", "a"}
   test_string_slice(t, expected, results)
}

@(test)
line_composer_word_wrapper_mixed_length :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   text := "abcd efghij klmnopabcdefghijklmnopabcdefghijkl mnopab cdefghi j klmno"
   results, _, _ := run_composer(ops, text, width)

   expected := []string {
      "abcd efghij",
      "klmnopabcdefghijklmn",
      "opabcdefghijkl",
      "mnopab cdefghi j",
      "klmno",      
   }
   test_string_slice(t, expected, results)  
}

@(test)
line_composer_double_width_chars :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   text := "コンピュータ上で文字を扱う場合、典型的には文字による通信を行う場合にその両端点では、"
   results, _, _ := run_composer(ops, text, width)

   expected := []string {
      "コンピュータ上で文字",
      "を扱う場合、典型的に",
      "は文字による通信を行",
      "う場合にその両端点で",
      "は、",
   }
   test_string_slice(t, expected, results)  
}

@(test)
line_composer_leading_whitespace_removal :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   text := "AAAAAAAAAAAAAAAAAAAA    AAA"
   results, _, _ := run_composer(ops, text, width)

   expected := []string {"AAAAAAAAAAAAAAAAAAAA", "AAA"}
   test_string_slice(t, expected, results)  
}

@(test)
line_composer_lots_of_spaces :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   text := "                                                                     "
   results, _, _ := run_composer(ops, text, width)

   expected := []string {""}
   test_string_slice(t, expected, results)  
}

@(test)
line_composer_char_plus_lots_of_spaces :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   text := "a                                                                     "
   results, _, _ := run_composer(ops, text, width)
   // What's happening below is: the first line gets consumed, trailing spaces discarded,
   // after 20 of which a word break occurs (probably shouldn't). The second line break
   // discards all whitespace. The result should probably be []string{"a"} but it doesn't matter
   // that much.
   expected := []string {"a", ""}
   test_string_slice(t, expected, results)  
}

@(test)
line_composer_word_wrapper_double_width_chars_mixed_with_spaces :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}
   text := "コンピュ ータ上で文字を扱う場合、 典型的には文 字による 通信を行 う場合にその両端点では、"
   results, _, _ := run_composer(ops, text, width)

   expected := []string {
      "コンピュ",
      "ータ上で文字を扱う場",
      "合、 典型的には文",
      "字による 通信を行",
      "う場合にその両端点で",
      "は、",
   }
   test_string_slice(t, expected, results)   
}

@(test)
line_composer_word_wrapper_nbsp :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := true
   ops := Composer_Options{Word_Wrapper, trim}

   /// Ensure words separated by nbsp are wrapped as if they were a single one.
   text := "AAAAAAAAAAAAAAA AAAA\xA0AAA"
   results, _, _ := run_composer(ops, text, width)

   expected := []string {"AAAAAAAAAAAAAAA", "AAAAAAA"}
   test_string_slice(t, expected, results)  
   
   // Ensure that if the character was a regular space, it would be wrapped differently.
   text = "AAAAAAAAAAAAAAA AAAA AAA"
   results, _, _ = run_composer(ops, text, width)

   expected = []string {"AAAAAAAAAAAAAAA AAAA", "AAA"}
   test_string_slice(t, expected, results)  
}  

@(test)
line_composer_word_wrapper_preserve_indentation :: proc(t: ^testing.T) {
   using Composer
   
   width := 20 
   trim := false
   ops := Composer_Options{Word_Wrapper, trim}
   text := "AAAAAAAAAAAAAAAAAAAA    AAA"
   results, _, _ := run_composer(ops, text, width)

   expected := []string {"AAAAAAAAAAAAAAAAAAAA", "   AAA"}
   test_string_slice(t, expected, results)  
}

@(test)
line_composer_word_wrapper_preserve_indentation_with_wrap :: proc(t: ^testing.T) {
   using Composer
   
   width := 10 
   trim := false
   ops := Composer_Options{Word_Wrapper, trim}
   text := "AAA AAA AAAAA AA AAAAAA\n B\n  C\n   D"
   results, _, _ := run_composer(ops, text, width)

   expected := []string {"AAA AAA", "AAAAA AA", "AAAAAA", " B", "  C", "   D"}
   test_string_slice(t, expected, results)  
}
