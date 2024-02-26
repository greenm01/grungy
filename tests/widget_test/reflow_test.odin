package widget_test

import "core:testing"
import "core:fmt"

import txt "../../text"
import wgt "../../widgets"

expect  :: testing.expect
log     :: testing.log
errorf  :: testing.errorf

@(test)
test_word_wrap :: proc(t: ^testing.T) {


   
}

main :: proc() {

   width := 20 
   text := "abcdefg\nhijklmno\npabcdefg\nhijklmn\nopabcdefghijk\nlmnopabcd\n\n\nefghijklmno"
   test := txt.raw_text(text)
   para := wgt.new_paragraph(test)
   fmt.println("lines =", wgt.line_count(&para.widget.(wgt.Paragraph), width))
   fmt.println()

   width = 20
   text = "abcdefghijklmnopabcdefghijklmnopabcdefghijklmnopabcdefghijklmno" 
   test = txt.raw_text(text)
   para = wgt.new_paragraph(test)
   fmt.println("lines =", wgt.line_count(&para.widget.(wgt.Paragraph), width))
   fmt.println()
   
   width = 50      
   text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
   test = txt.raw_text(text)
   para = wgt.new_paragraph(test)
   fmt.println("lines =", wgt.line_count(&para.widget.(wgt.Paragraph), width))
   fmt.println()
   
   width = 4      
   text = "foo bar was   here"
   test = txt.raw_text(text)
   para = wgt.new_paragraph(test)
   fmt.println("lines =", wgt.line_count(&para.widget.(wgt.Paragraph), width))
   fmt.println()

   width = 20
   text =
      "abcd efghij klmnopabcd efgh ijklmnopabcdefg hijkl mnopab c d e f g h i j k l m n o"
   text_multi_space :=
      "abcd efghij    klmnopabcd efgh     ijklmnopabcdefg hijkl mnopab c d e f g h i j k l m n o"

   test = txt.raw_text(text)
   para = wgt.new_paragraph(test)
   fmt.println("lines =", wgt.line_count(&para.widget.(wgt.Paragraph), width))
   test = txt.raw_text(text_multi_space)
   para = wgt.new_paragraph(test)
   fmt.println("lines =", wgt.line_count(&para.widget.(wgt.Paragraph), width))
   fmt.println()
}
