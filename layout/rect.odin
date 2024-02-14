package layout

import "core:math"

Rect :: struct {
   x:      int,
   y:      int,
   width:  int,
   height: int,
}

Offset :: struct {
   // how much to move the X axis
   x: int,
   // how much to move the Y axis
   y: int,
}

new_rect :: proc(x, y, width, height: int) -> (rect: Rect) {
   max_area := math.max(int)
   clipped_width, clipped_height: int
   if width * height > max_area {
      aspect_ratio := f64(width) / f64(height)
      max_area_f := f64(max_area)
      height_f := math.sqrt_f64(max_area_f / aspect_ratio)
      width_f := height_f * aspect_ratio
      clipped_width = int(width_f)
      clipped_height = int(height_f)
   } else {
      clipped_width = width
      clipped_height = height
   }
   rect = Rect{x, y, clipped_width, clipped_height}
   return
}
