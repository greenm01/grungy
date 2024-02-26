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

   para: ^wgt.Block

   width := 20 
   text1 := "abcdefg\nhijklmno\npabcdefg\nhijklmn\nopabcdefghijk\nlmnopabcd\n\n\nefghijklmno"
   test1 := txt.raw_text(text1)

   /*
   para = wgt.new_paragraph(test1)
   fmt.println("Count lines...") 
   fmt.println(wgt.line_count(&para.widget.(wgt.Paragraph), width))
   fmt.println()
   */
   
   /*
   width = 50      
   lorum_ipsum := "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
   test2 := txt.raw_text(lorum_ipsum)
   para = wgt.new_paragraph(test2)
   fmt.print("Lorum Ipsum...")
   fmt.println(wgt.line_count(&para.widget.(wgt.Paragraph), width))
   fmt.println()
   */
   
   width = 4      
   foo_bar := "foo bar was here"
   test3 := txt.raw_text(foo_bar)
   para = wgt.new_paragraph(text = test3, trim = true)
   fmt.println("foo bar go...")
   fmt.println(wgt.line_count(&para.widget.(wgt.Paragraph), width))
   fmt.println()

}
