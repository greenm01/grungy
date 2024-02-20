package layout

Point :: struct {
    x: int,
    y: int,
}

pt :: proc(x, y: int) -> Point {
	return Point{x, y}
}

pt_sub :: proc(p, q: Point) -> Point {
	return Point{p.x - q.x, p.y - q.y}
}

pt_add :: proc(p, q: Point) -> Point {
	return Point{p.x + q.x, p.y + q.y}
}

// Div returns the vector p/k.
pt_div :: proc(p: Point, k: int) -> Point {
	return Point{p.x / k, p.y / k}
}
