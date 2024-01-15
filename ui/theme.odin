// Copyright 2017 Zack Guo <zack.y.guo@gmail.com>. All rights reserved.
// Use of this source code is governed by a MIT license that can
// be found in the LICENSE file.

package ui

standard_colors := []Color{RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE}

standard_styles := []Style {
	new_style(RED),
	new_style(GREEN),
	new_style(YELLOW),
	new_style(BLUE),
	new_style(MAGENTA),
	new_style(CYAN),
	new_style(WHITE),
}

Root_Theme :: struct {
	default:           Style,
	block:             Block_Theme,
	bar_chart:         Bar_Chart_Theme,
	gauge:             Gauge_Theme,
	plot:              Plot_Theme,
	list:              List_Theme,
	tree:              Tree_Theme,
	paragraph:         Paragraph_Theme,
	pie_chart:         Pie_Chart_Theme,
	sparkline:         Sparkline_Theme,
	stacked_bar_chart: Stacked_Bar_Chart_Theme,
	tab:               Tab_Theme,
	table:             Table_Theme,
}

Block_Theme :: struct {
	title:  Style,
	border: Style,
}

Bar_Chart_Theme :: struct {
	bars:   []Color,
	nums:   []Style,
	labels: []Style,
}

Gauge_Theme :: struct {
	bar:   Color,
	label: Style,
}

Plot_Theme :: struct {
	lines: []Color,
	axes:  Color,
}

List_Theme :: struct {
	text: Style,
}

Tree_Theme :: struct {
	text:      Style,
	collapsed: rune,
	expanded:  rune,
}

Paragraph_Theme :: struct {
	text: Style,
}

Pie_Chart_Theme :: struct {
	slices: []Color,
}

Sparkline_Theme :: struct {
	title: Style,
	line:  Color,
}

Stacked_Bar_Chart_Theme :: struct {
	bars:   []Color,
	nums:   []Style,
	labels: []Style,
}

Tab_Theme :: struct {
	active:   Style,
	inactive: Style,
}

Table_Theme :: struct {
	text: Style,
}

// Theme holds the default Styles and Colors for all widgets.
// You can set default widget Styles by modifying the Theme before creating the widgets.
theme := Root_Theme {
	default = new_style(WHITE),
	block = Block_Theme{new_style(WHITE), new_style(WHITE)},
	bar_chart = Bar_Chart_Theme{standard_colors, standard_styles, standard_styles},
	paragraph = Paragraph_Theme{new_style(WHITE)},
	pie_chart = Pie_Chart_Theme{standard_colors},
	list = List_Theme{new_style(WHITE)},
	tree = Tree_Theme{new_style(WHITE), COLLAPSED, EXPANDED},
	stacked_bar_chart = Stacked_Bar_Chart_Theme{standard_colors, standard_styles, standard_styles},
	gauge = Gauge_Theme{WHITE, new_style(WHITE)},
	sparkline = Sparkline_Theme{new_style(WHITE), WHITE},
	plot = Plot_Theme{standard_colors, WHITE},
	table = Table_Theme{new_style(WHITE)},
	tab = Tab_Theme{new_style(RED), new_style(WHITE)},
}
