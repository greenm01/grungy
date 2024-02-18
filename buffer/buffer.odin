package buffer

import "core:math"
import "core:unicode/utf8"

import wc "../deps/karvi/wcwidth"

import "../style"
import "../layout"
import "../text"

Buffer :: struct {
   area:    Rect,
   content: []Cell,
}

empty_buffer :: proc(area: Rect) -> Buffer {
   cell := default_cell()
   return buffer_filled(area, cell)
}

buffer_filled :: proc(area: Rect, c: Cell) -> Buffer {
   size := layout.area(area)
   content := make([]Cell, size)
   for i in 0..<size {
      content[i] = c
   }
   return Buffer{area, content}
}

/// Reset all cells in the buffer
buffer_reset :: proc(b: ^Buffer) {
   for _, i  in b.content {
      b.content[i] = default_cell()
   }
}

buffer_with_lines :: proc(lines: []Line) -> (buffer: Buffer) {
   height := len(lines)
   width: int
   for l in lines {
      w := text.line_width(l)
      width = w > width ? w : width
   }
   buffer = empty_buffer(Rect{0, 0, width, height})
   for line, y in lines {
      buffer_set_line(&buffer, 0, y, line, width)
   }
   return
}

/// Returns the index in the Cell for the given global (x, y) coordinates.
///
/// Global coordinates are offset by the Buffer's area offset (`x`/`y`).
index_of :: proc(buf: ^Buffer, x, y: int) -> int {
   assert(condition = 
      x >= layout.left(buf.area) && x < layout.right(buf.area) &&
      y >= layout.top(buf.area) && y < layout.bottom(buf.area),
      message = "Trying to access position outside the buffer")
   return ((y - buf.area.y) * buf.area.width + (x - buf.area.x))
}

/// Print at most the first n characters of a string if enough space is available
/// until the end of the line
set_stringn :: proc(buf: ^Buffer, x, y: int,
   str: string, width: int, style: Style) -> (int, int) {
   
   index := index_of(buf, x, y)
   x_offset := x
   graphemes := utf8.string_to_runes(str)
   max_offset := math.min(layout.right(buf.area), width + x)
   
   for s in graphemes {
      w := wc.rune_width(s)
      if w == 0 do continue
      if w > max_offset - x_offset do break

      set_symbol(&buf.content[index], s)
      set_style(&buf.content[index], style)
      // Reset following cells if multi-width (they would be hidden by the grapheme),
      for i in index + 1..=index + w {
          buf.content[i] = default_cell()
      }
      index += w
      x_offset += w
   }
   return x_offset, y
}

/// Print a line, starting at the position (x, y)
buffer_set_line :: proc(buf: ^Buffer, x, y: int, line: Line, width: int) -> (int, int) {
   remaining_width := width
   x := x
   for span in line.spans {
      if remaining_width == 0 do break
      pos, _ := set_stringn(
          buf,
          x,
          y,
          span.content,
          remaining_width,
          style.patch(line.style, span.style),
      )
      w := pos - x
      x = pos
      remaining_width = remaining_width - w
   }
   return x, y
}
