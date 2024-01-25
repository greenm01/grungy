package widgets

import "../ui"

standard_colors := []ui.Color{ui.RED, ui.GREEN, ui.YELLOW, ui.BLUE, ui.MAGENTA, ui.CYAN, ui.WHITE}

standard_styles := []ui.Style {
	ui.new_style(ui.RED),
	ui.new_style(ui.GREEN),
	ui.new_style(ui.YELLOW),
	ui.new_style(ui.BLUE),
	ui.new_style(ui.MAGENTA),
	ui.new_style(ui.CYAN),
	ui.new_style(ui.WHITE),
}

Root_Theme :: struct {
	default:           ui.Style,
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
	title:  ui.Style,
	border: ui.Style,
}

Bar_Chart_Theme :: struct {
	bars:   []ui.Color,
	nums:   []ui.Style,
	labels: []ui.Style,
}

Gauge_Theme :: struct {
	bar:   ui.Color,
	label: ui.Style,
}

Plot_Theme :: struct {
	lines: []ui.Color,
	axes:  ui.Color,
}

List_Theme :: struct {
	text: ui.Style,
}

Tree_Theme :: struct {
	text:      ui.Style,
	collapsed: rune,
	expanded:  rune,
}

Paragraph_Theme :: struct {
	text: ui.Style,
}

Pie_Chart_Theme :: struct {
	slices: []ui.Color,
}

Sparkline_Theme :: struct {
	title: ui.Style,
	line:  ui.Color,
}

Stacked_Bar_Chart_Theme :: struct {
	bars:   []ui.Color,
	nums:   []ui.Style,
	labels: []ui.Style,
}

Tab_Theme :: struct {
	active:   ui.Style,
	inactive: ui.Style,
}

Table_Theme :: struct {
	text: ui.Style,
}

// Theme holds the default Styles and Colors for all widgets.
// You can set default widget Styles by modifying the Theme before creating the widgets.
theme := Root_Theme {
	default = ui.new_style(ui.WHITE),
	block = Block_Theme{ui.new_style(ui.WHITE), ui.new_style(ui.WHITE)},
	bar_chart = Bar_Chart_Theme{standard_colors, standard_styles, standard_styles},
	paragraph = Paragraph_Theme{ui.new_style(ui.WHITE)},
	pie_chart = Pie_Chart_Theme{standard_colors},
	list = List_Theme{ui.new_style(ui.WHITE)},
	tree = Tree_Theme{ui.new_style(ui.WHITE), ui.COLLAPSED, ui.EXPANDED},
	stacked_bar_chart = Stacked_Bar_Chart_Theme{standard_colors, standard_styles, standard_styles},
	gauge = Gauge_Theme{ui.WHITE, ui.new_style(ui.WHITE)},
	sparkline = Sparkline_Theme{ui.new_style(ui.WHITE), ui.WHITE},
	plot = Plot_Theme{standard_colors, ui.WHITE},
	table = Table_Theme{ui.new_style(ui.WHITE)},
	tab = Tab_Theme{ui.new_style(ui.RED), ui.new_style(ui.WHITE)},
}
