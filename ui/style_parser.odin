package ui

import "core:strings"
import "core:unicode/utf8"

TOKEN_FG :: "fg"
TOKEN_BG :: "bg"
TOKEN_MODIFIER :: "mod"
TOKEN_ITEM_SEPERATOR :: ","
TOKEN_VALUE_SEPERATOR :: ":"
TOKEN_BEGIN_STYLED_TEXT :: '['
TOKEN_END_STYLED_TEXT :: ']'
TOKEN_BEGIN_STYLE :: '('
TOKEN_END_STYLE :: ')'

Parser_State :: distinct uint

PARSER_STATE_DEFAULT: Parser_State : 0
PARSER_STATE_STYLE_ITEMS: Parser_State : 1
PARSER_STATE_STYLE_TEXT: Parser_State : 2

// StyleParserColorMap can be modified to add custom color parsing to text
parser_color_map := map[string]Color {
	"red"     = RED,
	"blue"    = BLUE,
	"black"   = BLACK,
	"cyan"    = CYAN,
	"yellow"  = YELLOW,
	"white"   = WHITE,
	"clear"   = COLOR_CLEAR,
	"green"   = GREEN,
	"magenta" = MAGENTA,
}

modifier_map := map[string]Modifier {
	"bold"      = BOLD,
	"underline" = UNDERLINE,
	"reverse"   = REVERSE,
}

// readStyle translates an []rune like `fg:red,mod:bold,bg:white` to a style
read_style :: proc(runes: []rune, default_style: Style) -> Style {
	style := default_style
	s := utf8.runes_to_string(runes)
	split := strings.split(s, TOKEN_ITEM_SEPERATOR)
	for item, _ in split {
		pair := strings.split(item, TOKEN_VALUE_SEPERATOR)
		if len(pair) == 2 {
			switch pair[0] {
			case TOKEN_FG:
				style.fg = parser_color_map[pair[1]]
			case TOKEN_BG:
				style.bg = parser_color_map[pair[1]]
			case TOKEN_MODIFIER:
				style.modifier = modifier_map[pair[1]]
			}
		}
	}
	return style
}

// ParseStyles parses a string for embedded Styles and returns []Cell with the correct styling.
// Uses defaultStyle for any text without an embedded style.
// Syntax is of the form [text](fg:<color>,mod:<attribute>,bg:<color>).
// Ordering does not matter. All fields are optional.
parse_styles :: proc(s: string, default_style: Style) -> []Cell {

	Parser :: struct {
		cells:        [dynamic]Cell,
		runes:        []rune,
		state:        Parser_State,
		styled_text:  [dynamic]rune,
		style_items:  [dynamic]rune,
		square_count: int,
	}

	p := Parser {
		make([dynamic]Cell),
		utf8.string_to_runes(s),
		PARSER_STATE_DEFAULT,
		make([dynamic]rune),
		make([dynamic]rune),
		0,
	}

	reset :: proc(p: ^Parser) {
		clear_dynamic_array(&p.styled_text)
		clear_dynamic_array(&p.style_items)
		p.state = PARSER_STATE_DEFAULT
		p.square_count = 0
	}

	rollback :: proc(p: ^Parser, default_style: Style) {
		append(&p.cells, ..runes_to_styled_cells(p.styled_text[:], default_style))
		append(&p.cells, ..runes_to_styled_cells(p.style_items[:], default_style))
		reset(p)
	}

	// chop first and last runes
	chop :: proc(s: []rune) -> []rune {
		return s[1:len(s) - 1]
	}

	for _rune, i in p.runes {
		switch p.state {
		case PARSER_STATE_DEFAULT:
			if _rune == TOKEN_BEGIN_STYLED_TEXT {
				p.state = PARSER_STATE_STYLE_TEXT
				p.square_count = 1
				append(&p.styled_text, _rune)
			} else {
				append(&p.cells, Cell{_rune, default_style})
			}
		case PARSER_STATE_STYLE_TEXT:
			switch {
			case p.square_count == 0:
				switch _rune {
				case TOKEN_BEGIN_STYLE:
					p.state = PARSER_STATE_STYLE_ITEMS
					append(&p.style_items, _rune)
				case:
					rollback(&p, default_style)
					switch _rune {
					case TOKEN_BEGIN_STYLED_TEXT:
						p.state = PARSER_STATE_STYLE_TEXT
						p.square_count = 1
						append(&p.style_items, _rune)
					case:
						append(&p.cells, Cell{_rune, default_style})
					}
				}
			case len(p.runes) == i + 1:
				rollback(&p, default_style)
				append(&p.styled_text, _rune)
			case _rune == TOKEN_BEGIN_STYLED_TEXT:
				p.square_count += 1
				append(&p.styled_text, _rune)
			case _rune == TOKEN_END_STYLED_TEXT:
				p.square_count -= 1
				append(&p.styled_text, _rune)
			case:
				append(&p.styled_text, _rune)
			}
		case PARSER_STATE_STYLE_ITEMS:
			append(&p.style_items, _rune)
			if _rune == TOKEN_END_STYLE {
				style := read_style(chop(p.style_items[:]), default_style)
				append(&p.cells, ..runes_to_styled_cells(chop(p.styled_text[:]), style))
				reset(&p)
			} else if len(p.runes) == i + 1 {
				rollback(&p, default_style)
			}
		}
	}

	return p.cells[:]

}
