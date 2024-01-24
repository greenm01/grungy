package widgets

import str "core:strings"
import "core:fmt"

import "../ui"
import wc "../deps/wcwidth"

TREE_INDENT :: "  "

// TreeNode is a tree node.
Tree_Node :: struct {
	value:    string,
	expanded: bool,
	nodes:    []Tree_Node,
	// level stores the node level in the tree.
	level:    int,
}

// tree_walk is a function used for walking a Tree.
// To interrupt the walking process function should return false.
tree_walk :: proc(n: ^Tree_Node) -> bool

parse_styles :: proc(tn: ^Tree_Node, style: ui.Style) -> []ui.Cell {
	sb: str.Builder
	if len(tn.nodes) == 0 {
		str.write_string(&sb, str.repeat(TREE_INDENT, tn.level+1))
	} else {
		str.write_string(&sb, str.repeat(TREE_INDENT, tn.level))
		if tn.expanded {
			str.write_rune(&sb, ui.theme.tree.expanded)
		} else {
			str.write_rune(&sb, ui.theme.tree.collapsed)
		}
		str.write_byte(&sb, ' ')
	}
	str.write_string(&sb, tn.value)
	return ui.parse_styles(str.to_string(sb), style)
}

// Tree is a tree widget.
Tree :: struct {
	using block:        ^Block,
	text_style:         ui.Style,
	selected_row_style: ui.Style,
	wrap_text:          bool,
	selected_row:       int,
	nodes:              []Tree_Node,
	// rows is flatten nodes for rendering.
	rows:               [dynamic]^Tree_Node,
	top_row:            int,
}

// NewTree creates a new Tree widget.
new_tree :: proc() -> (tree: ^Tree) {
	b := new(Block)
	tree = new(Tree)
	tree.block = b 
	tree.text_style = ui.theme.tree.text
	tree.selected_row_style = ui.theme.tree.text
	tree.wrap_text = true
	b.widget = tree
	return
}

del_tree :: proc(t: ^Tree) {
	/*
	for n in t.nodes {
		del_tree_node(n)
	}
	for r in t.rows {
		del_tree_node(r)
	}
	delete(t.nodes)
	delete(t.rows)
	*/
	del_block(t)	 
}

set_nodes :: proc(t: ^Tree, nodes: []Tree_Node) {
	t.nodes = nodes
	prepare_nodes(t)
}

prepare_nodes :: proc(t: ^Tree) {
	t.rows = make([dynamic]^Tree_Node)
	for _, i in t.nodes {
		prepare_node(t, &t.nodes[i], 0)
	}
}

prepare_node :: proc(t: ^Tree, node: ^Tree_Node, level: int) {
	append(&t.rows, node)
	node.level = level
	
	if node.expanded {
		for _, i in node.nodes {
			prepare_node(t, &node.nodes[i], level + 1)
		}
	}
}

walk :: proc{
	walk_tree,
	walk_node	
}

walk_tree :: proc(t: ^Tree, p: tree_walk) {
	for _, i in t.nodes {
		if !walk(&t.nodes[i], p) {
			break
		}
	}
}

walk_node :: proc(n: ^Tree_Node, p: tree_walk) -> bool {
	if !p(n) {
		return false
	}

	for _, i in n.nodes {
		if !walk(&n.nodes[i], p) {
			return false
		}
	}

	return true
}

draw_tree :: proc(t: ^Tree, buf: ^ui.Buffer) {
	draw_block(t, buf)
	point := t.inner.min

	// adjusts view into widget
	if t.selected_row >= ui.rect_dy(t.inner)+t.top_row {
		t.top_row = t.selected_row - ui.rect_dy(t.inner) + 1
	} else if t.selected_row < t.top_row {
		t.top_row = t.selected_row
	}

	// draw rows
	for row := t.top_row; row < len(t.rows) && point.y < t.inner.max.y; row += 1 {
		cells := parse_styles(t.rows[row], t.text_style)
		if t.wrap_text {
			cells = ui.wrap_cells(cells, ui.rect_dx(t.inner))
		}
		for j := 0; j < len(cells) && point.y < t.inner.max.y; j += 1 {
			style := cells[j].style
			if row == t.selected_row {
				style = t.selected_row_style
			}
			if point.x + 1 == t.inner.max.x + 1 && len(cells) > ui.rect_dx(t.inner) {
				ui.buffer_set_cell(
					buf,
					ui.new_cell(ui.ELLIPSES, style),
					ui.pt_add(point, ui.pt(-1, 0))
				)
			} else {
				ui.buffer_set_cell(
					buf,
					ui.new_cell(cells[j]._rune, style),
					point
				)
				point = ui.pt_add(point, ui.pt(wc.rune_width(cells[j]._rune), 0))
			}
		}
		point = ui.pt(t.inner.min.x, point.y + 1)
	}

	// draw UP_ARROW if needed
	if t.top_row > 0 {
		ui.buffer_set_cell(
			buf,
			ui.new_cell(ui.UP_ARROW, ui.new_style(ui.WHITE)),
			ui.pt(t.inner.max.x - 1, t.inner.min.y),
		)
	}

	// draw DOWN_ARROW if needed
	if len(t.rows) > int(t.top_row) + ui.rect_dy(t.inner) {
		ui.buffer_set_cell(
			buf,
			ui.new_cell(ui.DOWN_ARROW, ui.new_style(ui.WHITE)),
			ui.pt(t.inner.max.x - 1, t.inner.max.y - 1),
		)
	}
}

// scroll_amount scrolls by amount given. If amount is < 0, then scroll up.
// There is no need to set self.top_row, as this will be set automatically when drawn,
// since if the selected item is off screen then the top_row variable will change accordingly.
scroll_amount :: proc(t: ^Tree, amount: int) {
	if len(t.rows)-int(t.selected_row) <= amount {
		t.selected_row = len(t.rows) - 1
	} else if int(t.selected_row)+amount < 0 {
		t.selected_row = 0
	} else {
		t.selected_row += amount
	}
}

selected_node :: proc(t: ^Tree) -> ^Tree_Node {
	if len(t.rows) == 0 {
		return new(Tree_Node)
	}
	return t.rows[t.selected_row]
}

scroll_up :: proc(t: ^Tree) {
	scroll_amount(t, -1)
}

scroll_down :: proc(t: ^Tree) {
	scroll_amount(t, 1)
}

scroll_page_up :: proc(t: ^Tree) {
	// If an item is selected below top row, then go to the top row.
	if t.selected_row > t.top_row {
		t.selected_row = t.top_row
	} else {
		scroll_amount(t, -ui.rect_dy(t.inner))
	}
}

scroll_page_down :: proc(t: ^Tree) {
	scroll_amount(t, ui.rect_dy(t.inner))
}

scroll_half_page_up :: proc(t: ^Tree) {
	scroll_amount(t, -int(ui.floor_f64(f64(ui.rect_dy(t.inner)) / 2)))
}

scroll_half_page_down :: proc(t: ^Tree) {
	scroll_amount(t, int(ui.floor_f64(f64(ui.rect_dy(t.inner)) / 2)))
}

scroll_top :: proc(t: ^Tree) {
	t.selected_row = 0
}

scroll_bottom :: proc(t: ^Tree) {
	t.selected_row = len(t.rows) - 1
}

collapse :: proc(t: ^Tree) {
	t.rows[t.selected_row].expanded = false
	prepare_nodes(t)
}

expand :: proc(t: ^Tree) {
	node := t.rows[t.selected_row]
	if len(node.nodes) > 0 {
		t.rows[t.selected_row].expanded = true
	}
	prepare_nodes(t)
}

toggle_expand :: proc(t: ^Tree) {
	node := t.rows[t.selected_row] 
	if len(node.nodes) > 0 {
		node.expanded = !node.expanded
	}
	prepare_nodes(t)
}

expand_all :: proc(t: ^Tree) {
	walk(t, proc(n: ^Tree_Node) -> bool {
		if len(n.nodes) > 0 {
			n.expanded = true
		}
		return true
	})
	prepare_nodes(t)
}

collapse_all :: proc(t: ^Tree) {
	walk(t, proc(n: ^Tree_Node) -> bool {
		n.expanded = false
		return true
	})
	prepare_nodes(t)
}
