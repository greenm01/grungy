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

Rectangle :: struct {
	min, max: Point,
}

rect :: proc(x0, y0, x1, y1: int) -> Rectangle {
	p1 := Point{x0, y0}
	p2 := Point{x1, y1}
	return Rectangle{p1, p2}
}

dx :: proc(r: Rectangle) -> int {
	return r.max.x - r.min.x
}

dy :: proc(r: Rectangle) -> int {
	return r.max.y - r.min.y
}
