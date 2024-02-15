package layout

/// Position in the terminal
///
/// The position is relative to the top left corner of the terminal window, with the top left corner
/// being (0, 0). The x axis is horizontal increasing to the right, and the y axis is vertical
/// increasing downwards.
Position :: struct {
    x: int,
    y: int,
}
