package ui

import "core:os"
import "core:strings"
import "core:fmt"

import tb "../termbox2"

/*
List of events:
	mouse events:
		<MouseLeft> <MouseRight> <MouseMiddle>
		<MouseWheelUp> <MouseWheelDown>
	keyboard events:
		any uppercase or lowercase letter like j or J
		<C-d> etc
		<M-d> etc
		<Up> <Down> <Left> <Right>
		<Insert> <Delete> <Home> <End> <Previous> <Next>
		<Backspace> <Tab> <Enter> <Escape> <Space>
		<C-<Space>> etc
	terminal events:
        <Resize>

    keyboard events that do not work:
        <C-->
        <C-2> <C-~>
        <C-h>
        <C-i>
        <C-m>
        <C-[> <C-3>
        <C-\\>
        <C-]>
        <C-/> <C-_>
        <C-8>
*/

Event_Type :: enum {Keyboard_Event, Mouse_Event, Resize_Event} 
	
Event :: struct {
	type:    Event_Type,
	id:      string,
	payload: union {Keyboard, Mouse, Resize},
}

Keyboard :: struct {
	using event: ^Event,
}

// Mouse payload.
Mouse :: struct {
	using event: ^Event,
	drag:        bool,
	x:           int,
	y:           int,
}

// Resize payload.
Resize :: struct {
	using event: ^Event,
	width:       int,
	height:      int,
}

new_keyboard_event :: proc(id: string) -> ^Event {
	e := new(Event)
	e.type = .Keyboard_Event
	e.id = id
	e.payload = Keyboard{event = e}
	return e
}
	
new_mouse_event :: proc(id: string, x, y: int, drag: bool) -> ^Event {
	e := new(Event)
	e.type    = .Mouse_Event
	e.id      = id
	e.payload = Mouse{e, drag, x, y}
	return e	
}

new_resize_event :: proc(w, h: int) -> ^Event {
	e := new(Event)
	e.type    = .Resize_Event
	e.id      = "<Resize>"
	e.payload = Resize{e, w, h}
	return e
}

new_event :: proc($T: typeid, type: Event_Type, id: string) -> ^Event {
	t := new(Event)
	t.payload = T{event = t}
	t.type = type
	t.id = id
	return t
}

// PollEvents gets events from termbox, converts them, then sends them to each of its channels.
// TODO: make multi-threaded?
poll_event :: proc() -> ^Event {
	e := new(tb.Event)
	if tb.poll_event(e) == tb.OK {
		return convert_termbox_event(e)
	}
	return new(Event)
}

keyboard_map := map[tb.Key]string {
	tb.KEY_F1          = "<F1>",
	tb.KEY_F2          = "<F2>",
	tb.KEY_F3          = "<F3>",
	tb.KEY_F4          = "<F4>",
	tb.KEY_F5          = "<F5>",
	tb.KEY_F6          = "<F6>",
	tb.KEY_F7          = "<F7>",
	tb.KEY_F8          = "<F8>",
	tb.KEY_F9          = "<F9>",
	tb.KEY_F10         = "<F10>",
	tb.KEY_F11         = "<F11>",
	tb.KEY_F12         = "<F12>",
	tb.KEY_INSERT      = "<Insert>",
	tb.KEY_DELETE      = "<Delete>",
	tb.KEY_HOME        = "<Home>",
	tb.KEY_END         = "<End>",
	tb.KEY_PGUP        = "<PageUp>",
	tb.KEY_PGDN        = "<PageDown>",
	tb.KEY_ARROW_UP    = "<Up>",
	tb.KEY_ARROW_DOWN  = "<Down>",
	tb.KEY_ARROW_LEFT  = "<Left>",
	tb.KEY_ARROW_RIGHT = "<Right>",
	tb.KEY_CTRL_SPACE  = "<C-<Space>>", // tb.KEY_CTRL_2 tb.KEY_CTRL_Tilde
	tb.KEY_CTRL_A      = "<C-a>",
	tb.KEY_CTRL_B      = "<C-b>",
	tb.KEY_CTRL_C      = "<C-c>",
	tb.KEY_CTRL_D      = "<C-d>",
	tb.KEY_CTRL_E      = "<C-e>",
	tb.KEY_CTRL_F      = "<C-f>",
	tb.KEY_CTRL_G      = "<C-g>",
	tb.KEY_BACKSPACE   = "<C-<Backspace>>", // tb.KEY_CTRL_H
	tb.KEY_TAB         = "<Tab>", // tb.KEY_CTRL_I
	tb.KEY_CTRL_J      = "<C-j>",
	tb.KEY_CTRL_K      = "<C-k>",
	tb.KEY_CTRL_L      = "<C-l>",
	tb.KEY_ENTER       = "<Enter>", // tb.KEY_CTRL_M
	tb.KEY_CTRL_N      = "<C-n>",
	tb.KEY_CTRL_O      = "<C-o>",
	tb.KEY_CTRL_P      = "<C-p>",
	tb.KEY_CTRL_Q      = "<C-q>",
	tb.KEY_CTRL_R      = "<C-r>",
	tb.KEY_CTRL_S      = "<C-s>",
	tb.KEY_CTRL_T      = "<C-t>",
	tb.KEY_CTRL_U      = "<C-u>",
	tb.KEY_CTRL_V      = "<C-v>",
	tb.KEY_CTRL_W      = "<C-w>",
	tb.KEY_CTRL_X      = "<C-x>",
	tb.KEY_CTRL_Y      = "<C-y>",
	tb.KEY_CTRL_Z      = "<C-z>",
	tb.KEY_ESC         = "<Escape>", // tb.KEY_CTRL_LsqBracket tb.KEY_CTRL_3
	tb.KEY_CTRL_4      = "<C-4>", // tb.KEY_CTRL_Backslash
	tb.KEY_CTRL_5      = "<C-5>", // tb.KEY_CTRL_RsqBracket
	tb.KEY_CTRL_6      = "<C-6>",
	tb.KEY_CTRL_7      = "<C-7>", // tb.KEY_CTRL_Slash tb.KEY_CTRL_Underscore
	tb.KEY_SPACE       = "<Space>",
	tb.KEY_BACKSPACE2 = "<Backspace>", // tb.KeyCTRL_8:
}

// convertTermboxKeyboardEvent converts a termbox keyboard event to a more friendly string format.
// Combines modifiers into the string instead of having them as additional fields in an event.
convert_termbox_keyboard_event :: proc(e: ^tb.Event) -> ^Event {
	id := "%s"
	if e.mod == tb.MOD_ALT {
		id = "<M-%s>"
	}

	if e.ch != 0 {
		sb := strings.builder_make()
		strings.write_string(&sb, id)
		strings.write_uint(&sb, uint(e.ch))
		id = strings.to_string(sb)
	} else {
		converted, ok := keyboard_map[e.key]
		if !ok {
			converted = ""
		}
		s := []string{id, converted}
		id = strings.concatenate(s)
	}
	return new_keyboard_event(id)
}

mouse_button_map := map[tb.Key]string {
	tb.MOUSE_LEFT       = "<MouseLeft>",
	tb.MOUSE_MIDDLE     = "<MouseMiddle>",
	tb.MOUSE_RIGHT      = "<MouseRight>",
	tb.MOUSE_RELEASE    = "<MouseRelease>",
	tb.MOUSE_WHEEL_UP   = "<MouseWheelUp>",
	tb.MOUSE_WHEEL_DOWN = "<MouseWheelDown>",
}

convert_termbox_mouse_event :: proc(e: ^tb.Event) -> ^Event {
	converted, ok := mouse_button_map[e.key]
	if !ok {
		converted = "Unknown_Mouse_Button"
	}
	drag := e.mod == tb.MOD_MOTION
	return new_mouse_event(converted, int(e.x), int(e.y), drag)
}

// convertTermboxEvent turns a termbox event into a grungy event.
convert_termbox_event :: proc(e: ^tb.Event) -> ^Event {
	/*
	if e.type == tb.EVENT_ERROR {
		fmt.println("Event error!")
		os.exit(1)
	} */
	switch e.type {
	case tb.EVENT_KEY:
		return convert_termbox_keyboard_event(e)
	case tb.EVENT_MOUSE:
		return convert_termbox_mouse_event(e)
	case tb.EVENT_RESIZE:
		return new_resize_event(int(e.w), int(e.h))
	}
	return new(Event)
}
