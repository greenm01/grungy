package ui

Point :: struct {
	x, y: int,
}

pt :: proc(x, y: int) -> Point {
	return Point{x, y}
}

pt_in :: proc(p: Point, r: Rectangle) -> bool {
	return r.min.x <= p.x && p.x < r.max.x &&
		r.min.y <= p.y && p.y < r.max.y
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

Rectangle :: struct {
	min, max: Point,
}

rect :: proc(x0, y0, x1, y1: int) -> Rectangle {
	p1 := Point{x0, y0}
	p2 := Point{x1, y1}
	return Rectangle{p1, p2}
}

rect_dx :: proc(r: Rectangle) -> int {
	return r.max.x - r.min.x
}

rect_dy :: proc(r: Rectangle) -> int {
	return r.max.y - r.min.y
}

rect_size :: proc(r: Rectangle) -> Point {
	return Point{
		r.max.x - r.min.x,
		r.max.y - r.min.y,
	}
}
