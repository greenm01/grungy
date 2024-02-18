package block

Padding :: struct {
    left:   int,
    right:  int,
    top:    int,
    bottom: int,
}

/// Creates a `Padding` with all fields set to `0`.
zero :: proc() -> Padding {
   return Padding{0, 0, 0, 0}
}

/// Creates a `Padding` with the same value for `left` and `right`.
horizontal :: proc(value: int) -> Padding {
   return Padding {value, value, 0, 0}
}

/// Creates a `Padding` with the same value for `top` and `bottom`.
vertical :: proc(value: int) -> Padding {
   return Padding {0, 0, value, value}
}

/// Creates a `Padding` with the same value for all fields.
uniform :: proc(value: int) -> Padding {
   return Padding {value, value, value, value}
}

/// Creates a `Padding` that is visually proportional to the terminal.
///
/// This represents a padding of 2x the value for `left` and `right` and 1x the value for
/// `top` and `bottom`.
proportional :: proc(value: int) -> Padding {
   return Padding {2 * value, 2 * value, value, value}
}

/// Creates a `Padding` that is symmetric.
///
/// The `x` value is used for `left` and `right` and the `y` value is used for `top` and
/// `bottom`.
symmetric :: proc(x, y: int) -> Padding {
   return Padding {x, x, y, y}
}
