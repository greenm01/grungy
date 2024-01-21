package table

import "core:os"
import "core:fmt"

import "../ui"
import wg "../widgets"

main :: proc() {

   if err := ui.init(); err != 0 {
      fmt.println("failed to initialize grungy: %v", err)
      os.exit(1)
   }
   defer ui.close()

   ui.clear()
   
   x,y := ui.terminal_dimensions()

   table1 := wg.new_table()
   defer wg.del_widget(table1)
   
   table1.rows = [][]string{
   	[]string{"header1", "header2", "header3"},
   	[]string{"你好吗", "Odin is so cool", "Im working on Grungy"},
   	[]string{"2024", "01", "19"},
   }
   table1.text_style = ui.new_style(ui.WHITE)
   wg.set_rect(table1, 0, 0, 69, 7)
   wg.render(table1)
   
   table2 := wg.new_table()
   defer wg.del_widget(table2)

   table2.rows = [][]string{
   	[]string{"header1", "header2", "header3"},
   	[]string{"Foundations", "Odin is so cool", "Im working on Grungy"},
   	[]string{"2024", "01", "19"},
   }
   table2.text_style = ui.new_style(fg = ui.WHITE)
   table2.text_alignment = ui.Alignment.Align_Center
   table2.row_separator = false
   wg.set_rect(table2, 0, 7, 20, 16)
   wg.render(table2)
   
   table3 := wg.new_table()
   defer wg.del_widget(table3)

   table3.rows = [][]string{
   	[]string{"header1", "header2", "header3"},
   	[]string{"AAA", "BBB", "CCC"},
   	[]string{"DDD", "EEE", "FFF"},
   	[]string{"GGG", "HHH", "III"},
   }
   table3.text_style = ui.new_style(ui.WHITE)
   table3.row_separator = true
   table3.border_style = ui.new_style(ui.GREEN)
   wg.set_rect(table3, 0, 16, 62, 25)
   table3.fill_row = true
   table3.row_styles[0] = ui.new_style(ui.WHITE, ui.BLACK, ui.BOLD)
   table3.row_styles[2] = ui.new_style(ui.WHITE, ui.RED, ui.BOLD)
   table3.row_styles[3] = ui.new_style(ui.YELLOW)
   wg.render(table3)
   
   ui.present()

   using ui.Event_Type

   for {
   		event := ui.poll_event()
   		if event.type == Keyboard_Event do break
   }

}
