package table

import "core:os"
import "core:fmt"

import "../ui"

main :: proc() {

   if err := ui.init(); err != 0 {
      fmt.println("failed to initialize grungy: %v", err)
      os.exit(1)
   }
   //defer ui.close()

   ui.clear()
   
   x,y := ui.terminal_dimensions()

   table1 := ui.new_table()
   table1.rows = [][]string{
   	[]string{"header1", "header2", "header3"},
   	[]string{"你好吗", "Odin is so cool", "Im working on Grungy"},
   	[]string{"2024", "01", "19"},
   }
   table1.text_style = ui.new_style(ui.WHITE)
   
   ui.set_rect(table1, 0, 0, 69, 7)
   ui.render(table1)
   
   table2 := ui.new_table()
   table2.rows = [][]string{
   	[]string{"header1", "header2", "header3"},
   	[]string{"Foundations", "Odin is so cool", "Im working on Grungy"},
   	[]string{"2024", "01", "19"},
   }
   table2.text_style = ui.new_style(fg = ui.WHITE)
   table2.text_alignment = ui.ALIGN_CENTER
   table2.row_separator = false
   
   ui.set_rect(table2, 0, 7, 20, 16)
   ui.render(table2)
   
   table3 := ui.new_table()
   table3.rows = [][]string{
   	[]string{"header1", "header2", "header3"},
   	[]string{"AAA", "BBB", "CCC"},
   	[]string{"DDD", "EEE", "FFF"},
   	[]string{"GGG", "HHH", "III"},
   }
   table3.text_style = ui.new_style(ui.WHITE)
   table3.row_separator = true
   table3.border_style = ui.new_style(ui.GREEN)
   ui.set_rect(table3, 0, 16, 62, 25)
   table3.fill_row = true
   table3.row_styles[0] = ui.new_style(ui.WHITE, ui.BLACK, ui.BOLD)
   table3.row_styles[2] = ui.new_style(ui.WHITE, ui.RED, ui.BOLD)
   table3.row_styles[3] = ui.new_style(ui.YELLOW)
   
   ui.render(table3)
   
   ui.present()
   
   for {
   		event := ui.poll_event()
   		if event.type == ui.Event_Type.Keyboard_Event do break
   }

   ui.close()
   fmt.println(x, y)
}
