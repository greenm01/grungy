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

/// Returns the rect area
area :: proc(r: Rect) -> int {
   return r.width * r.height   
}

/// Returns true of the rect has no area
is_empty :: proc(r: Rect) -> bool {
   return r.width == 0 || r.height == 0
}

/// Returns the left coordinate of the rect
left :: proc(r: Rect) -> int {
   return r.x
}

/// Returns the right coordinate of the rect. This is the first coordinate outside of the rect.i
right :: proc(r: Rect) -> int {
   return r.x + r.width
}

/// Returns the top coordinate of the rect.
top :: proc(r: Rect) -> int {
   return r.y
}

/// Returns the bottom coordinate of the rect. This is the first coordinate outside of the rect.
bottom :: proc(r: Rect) -> int {
   return r.y + r.height
}

/// Returns a new rect inside the current one, with the given margin on each side.
inner :: proc(r: Rect, margin: Margin) -> Rect {
   doubled_margin_horizontal := 2 * margin.horizontal
   doubled_margin_vertical := 2 * margin.vertical

   if r.width < doubled_margin_horizontal || r.height < doubled_margin_vertical {
      return Rect{}
   }
    
   return Rect {
       x = r.x + margin.horizontal,
       y = r.y + margin.vertical,
       width = r.width - doubled_margin_horizontal,
       height = r.height - doubled_margin_vertical,
   }
}

/// Moves the `Rect` without modifying its size.
offset :: proc(r: Rect, offset: Offset) -> Rect {
   x := r.x + offset.x
   x = math.clamp(x, 0, math.max(int) - r.width)
   y := r.y + offset.y
   y = math.clamp(y, 0, math.max(int) - r.height)
   return Rect {x, y, r.width, r.height}
}

/// Returns a new rect that contains both the current one and the given one.
merge :: proc(r, other: Rect) -> Rect {
   x1 := math.min(r.x, other.x)
   y1 := math.min(r.y, other.y)
   x2 := math.max(right(r), right(other))
   y2 := math.max(bottom(r), bottom(other))
   return Rect {
      x = x1,
      y = y1,
      width = x2 - x1,
      height = y2 - y1,
   }
}

/// Returns a new rect that is the intersection of the current one and the given one.
///
/// If the two rects do not intersect, the returned rect will have no area.
intersection :: proc(r, other: Rect) -> Rect {
   x1 := math.max(r.x, other.x)
   y1 := math.max(r.y, other.y)
   x2 := math.min(right(r), right(other))
   y2 := math.min(bottom(r), bottom(other))
   return Rect {
      x = x1,
      y = y1,
      width = x2 - x1,
      height = y2 - y1,
   }
}

/// Returns true if the two rects intersect.
intersects :: proc(r, other: Rect) -> bool {
   return r.x < right(other) && right(r) > other.x && r.y < bottom(other) && bottom(r) > other.y
}

/// Returns true if the given position is inside the rect.
///
/// The position is considered inside the rect if it is on the rect's border.
contains :: proc(r: Rect, position: Position) -> bool {
   return position.x >= r.x &&
      position.x < right(r) &&
      position.y >= r.y &&
      position.y < bottom(r)

}

/// Clamp this rect to fit inside the other rect.
///
/// If the width or height of this rect is larger than the other rect, it will be clamped to the
/// other rect's width or height.
///
/// If the left or top coordinate of this rect is smaller than the other rect, it will be
/// clamped to the other rect's left or top coordinate.
///
/// If the right or bottom coordinate of this rect is larger than the other rect, it will be
/// clamped to the other rect's right or bottom coordinate.
clamp :: proc(r, other: Rect) -> Rect {
   width := r.width.min(other.width);
   height := r.height.min(other.height);
   x := r.x.clamp(other.x, other.right().saturating_sub(width));
   y := r.y.clamp(other.y, other.bottom().saturating_sub(height));
   return Rect{x, y, width, height}
}

/// Returns a [`Position`] with the same coordinates as this rect.
as_position :: proc(r: Rect) -> Position {
   return Position {
      x = r.x,
      y = r.y,
   }
}

/// Converts the rect into a size struct.
as_size :: proc(r: Rect) -> Size {
   return Size {
      width = r.width,
      height = r.height,
   }
}
