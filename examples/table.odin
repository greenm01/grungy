package table

import "core:os"
import "core:fmt"

import "../ui"

main :: proc() {
   if err := ui.init(); err != nil {
      fmt.println("failed to initialize termui: %v", err)
      os.exit(1)
   }
   defer ui.close()

   table1 := new_table()
   table1.Rows = [][]string{
   	[]string{"header1", "header2", "header3"},
   	[]string{"你好吗", "Odin-lang is so cool", "Im working on Go"},
   	[]string{"2024", "01", "19"},
   }
   table1.TextStyle = ui.NewStyle(ui.ColorWhite)
   table1.SetRect(0, 0, 60, 10)

   ui.Render(table1)

   table2 := new_table()
   table2.Rows = [][]string{
   	[]string{"header1", "header2", "header3"},
   	[]string{"Foundations", "Go-lang is so cool", "Im working on Ruby"},
   	[]string{"2024", "01", "19"},
   }
   table2.TextStyle = ui.NewStyle(ui.ColorWhite)
   table2.TextAlignment = ui.AlignCenter
   table2.RowSeparator = false
   table2.SetRect(0, 10, 20, 20)

   ui.Render(table2)

   table3 := new_table()
   table3.Rows = [][]string{
   	[]string{"header1", "header2", "header3"},
   	[]string{"AAA", "BBB", "CCC"},
   	[]string{"DDD", "EEE", "FFF"},
   	[]string{"GGG", "HHH", "III"},
   }
   table3.TextStyle = ui.NewStyle(ui.ColorWhite)
   table3.RowSeparator = true
   table3.BorderStyle = ui.NewStyle(ui.ColorGreen)
   table3.SetRect(0, 30, 70, 20)
   table3.FillRow = true
   table3.RowStyles[0] = ui.NewStyle(ui.ColorWhite, ui.ColorBlack, ui.ModifierBold)
   table3.RowStyles[2] = ui.NewStyle(ui.ColorWhite, ui.ColorRed, ui.ModifierBold)
   table3.RowStyles[3] = ui.NewStyle(ui.ColorYellow)

   ui.Render(table3)

   uiEvents := ui.PollEvents()
   for {
   	e := <-uiEvents
   	switch e.ID {
   	case "q", "<C-c>":
   		return
   	}
   }
}
