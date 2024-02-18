package style

BLOCK_FULL           :: "█"
BLOCK_SEVEN_EIGHTHS  :: "▉"
BLOCK_THREE_QUARTERS :: "▊"
BLOCK_FIVE_EIGHTHS   :: "▋"
BLOCK_HALF           :: "▌"
BLOCK_THREE_EIGHTHS  :: "▍"
BLOCK_ONE_QUARTER    :: "▎"
BLOCK_ONE_EIGHTH     :: "▏"

Block_Set :: struct {
   full:           string,
   seven_eighths:  string,
   three_quarters: string,
   five_eighths:   string,
   half:           string,
   three_eighths:  string,
   one_quarter:    string,
   one_eighth:     string,
   empty:          string,
}

default_block_set :: proc() -> Block_Set {
   return NINE_LEVELS_BLOCK
}

THREE_LEVELS_BLOCK :: Block_Set {
   full =           BLOCK_FULL,
   seven_eighths =  BLOCK_FULL,
   three_quarters = BLOCK_HALF,
   five_eighths =   BLOCK_HALF,
   half =           BLOCK_HALF,
   three_eighths =  BLOCK_HALF,
   one_quarter =    BLOCK_HALF,
   one_eighth =     " ",
   empty =          " ",
}

NINE_LEVELS_BLOCK :: Block_Set {
   full =           BLOCK_FULL,
   seven_eighths =  BLOCK_SEVEN_EIGHTHS,
   three_quarters = BLOCK_THREE_QUARTERS,
   five_eighths =   BLOCK_FIVE_EIGHTHS,
   half =           BLOCK_HALF,
   three_eighths =  BLOCK_THREE_EIGHTHS,
   one_quarter =    BLOCK_ONE_QUARTER,
   one_eighth =     BLOCK_ONE_EIGHTH,
   empty =          " ",
}

HALF_BLOCK_UPPER :: '▀'
HALF_BLOCK_LOWER :: '▄'
HALF_BLOCK_FULL  :: '█'

BAR_FULL           :: "█"
BAR_SEVEN_EIGHTHS  :: "▇"
BAR_THREE_QUARTERS :: "▆"
BAR_FIVE_EIGHTHS   :: "▅"
BAR_HALF           :: "▄"
BAR_THREE_EIGHTHS  :: "▃"
BAR_ONE_QUARTER    :: "▂"
BAR_ONE_EIGHTH     :: "▁"

Bar_Set :: struct {
   full:           string, 
   seven_eighths:  string,
   three_quarters: string,
   five_eighths:   string,
   half:           string,
   three_eighths:  string,
   one_quarter:    string,
   one_eighth:     string,
   empty:          string,
}

default_bar_set :: proc() -> Bar_Set {
   return NINE_LEVELS_BAR
}

THREE_LEVELS_BAR :: Bar_Set {
   full =           BAR_FULL,
   seven_eighths =  BAR_FULL,
   three_quarters = BAR_HALF,
   five_eighths =   BAR_HALF,
   half =           BAR_HALF,
   three_eighths =  BAR_HALF,
   one_quarter =    BAR_HALF,
   one_eighth =     " ",
   empty =          " ",
}

NINE_LEVELS_BAR :: Bar_Set {
   full =           BAR_FULL,
   seven_eighths =  BAR_SEVEN_EIGHTHS,
   three_quarters = BAR_THREE_QUARTERS,
   five_eighths =   BAR_FIVE_EIGHTHS,
   half =           BAR_HALF,
   three_eighths =  BAR_THREE_EIGHTHS,
   one_quarter =    BAR_ONE_QUARTER,
   one_eighth =     BAR_ONE_EIGHTH,
   empty =          " ",
}

VERTICAL        :: "│"
DOUBLE_VERTICAL :: "║"
THICK_VERTICAL  :: "┃"

HORIZONTAL        :: "─"
DOUBLE_HORIZONTAL :: "═"
THICK_HORIZONTAL  :: "━"

TOP_RIGHT         :: "┐"
ROUNDED_TOP_RIGHT :: "╮"
DOUBLE_TOP_RIGHT  :: "╗"
THICK_TOP_RIGHT   :: "┓"

TOP_LEFT         :: "┌"
ROUNDED_TOP_LEFT :: "╭"
DOUBLE_TOP_LEFT  :: "╔"
THICK_TOP_LEFT   :: "┏"

BOTTOM_RIGHT         :: "┘"
ROUNDED_BOTTOM_RIGHT :: "╯"
DOUBLE_BOTTOM_RIGHT  :: "╝"
THICK_BOTTOM_RIGHT   :: "┛"

BOTTOM_LEFT         :: "└"
ROUNDED_BOTTOM_LEFT :: "╰"
DOUBLE_BOTTOM_LEFT  :: "╚"
THICK_BOTTOM_LEFT   :: "┗"

VERTICAL_LEFT        :: "┤"
DOUBLE_VERTICAL_LEFT :: "╣"
THICK_VERTICAL_LEFT  :: "┫"

VERTICAL_RIGHT        :: "├"
DOUBLE_VERTICAL_RIGHT :: "╠"
THICK_VERTICAL_RIGHT  :: "┣"

HORIZONTAL_DOWN        :: "┬"
DOUBLE_HORIZONTAL_DOWN :: "╦"
THICK_HORIZONTAL_DOWN  :: "┳"

HORIZONTAL_UP        :: "┴"
DOUBLE_HORIZONTAL_UP :: "╩"
THICK_HORIZONTAL_UP  :: "┻"

CROSS        :: "┼"
DOUBLE_CROSS :: "╬"
THICK_CROSS  :: "╋"

Line_Set :: struct {
   vertical:        string,
   horizontal:      string,
   top_right:       string,
   top_left:        string,
   bottom_right:    string,
   bottom_left:     string,
   vertical_left:   string,
   vertical_right:  string,
   horizontal_down: string,
   horizontal_up:   string,
   cross:           string,
}

default_line :: proc() -> Line_Set {
   return NORMAL_LINE
}

NORMAL_LINE :: Line_Set {
   vertical = VERTICAL,
   horizontal = HORIZONTAL,
   top_right = TOP_RIGHT,
   top_left = TOP_LEFT,
   bottom_right = BOTTOM_RIGHT,
   bottom_left = BOTTOM_LEFT,
   vertical_left = VERTICAL_LEFT,
   vertical_right = VERTICAL_RIGHT,
   horizontal_down = HORIZONTAL_DOWN,
   horizontal_up = HORIZONTAL_UP,
   cross = CROSS,
}

ROUNDED_LINE :: Line_Set {
   vertical = VERTICAL,
   horizontal = HORIZONTAL,
   top_right = ROUNDED_TOP_RIGHT,
   top_left = ROUNDED_TOP_LEFT,
   bottom_right = ROUNDED_BOTTOM_RIGHT,
   bottom_left = ROUNDED_BOTTOM_LEFT,
   vertical_left = VERTICAL_LEFT,
   vertical_right = VERTICAL_RIGHT,
   horizontal_down = HORIZONTAL_DOWN,
   horizontal_up = HORIZONTAL_UP,
   cross = CROSS,
}

DOUBLE_LINE :: Line_Set {
   vertical =        DOUBLE_VERTICAL,
   horizontal =      DOUBLE_HORIZONTAL,
   top_right =       DOUBLE_TOP_RIGHT,
   top_left =        DOUBLE_TOP_LEFT,
   bottom_right =    DOUBLE_BOTTOM_RIGHT,
   bottom_left =     DOUBLE_BOTTOM_LEFT,
   vertical_left =   DOUBLE_VERTICAL_LEFT,
   vertical_right =  DOUBLE_VERTICAL_RIGHT,
   horizontal_down = DOUBLE_HORIZONTAL_DOWN,
   horizontal_up =   DOUBLE_HORIZONTAL_UP,
   cross =           DOUBLE_CROSS,
}

THICK_LINE :: Line_Set {
   vertical =        THICK_VERTICAL,
   horizontal =      THICK_HORIZONTAL,
   top_right =       THICK_TOP_RIGHT,
   top_left =        THICK_TOP_LEFT,
   bottom_right =    THICK_BOTTOM_RIGHT,
   bottom_left =     THICK_BOTTOM_LEFT,
   vertical_left =   THICK_VERTICAL_LEFT,
   vertical_right =  THICK_VERTICAL_RIGHT,
   horizontal_down = THICK_HORIZONTAL_DOWN,
   horizontal_up =   THICK_HORIZONTAL_UP,
   cross =           THICK_CROSS,
}

Border_Set :: struct {
   top_left:          string,
   top_right:         string,
   bottom_left:       string,
   bottom_right:      string,
   vertical_left:     string,
   vertical_right:    string,
   horizontal_top:    string,
   horizontal_bottom: string,
}

default_border :: proc() -> Border_Set {
   return PLAIN_BORDER
}

/// Border Set with a single line width
///
/// ```text
/// ┌─────┐
/// │xxxxx│
/// │xxxxx│
/// └─────┘
PLAIN_BORDER :: Border_Set {
   top_left =          NORMAL_LINE.top_left,
   top_right =         NORMAL_LINE.top_right,
   bottom_left =       NORMAL_LINE.bottom_left,
   bottom_right =      NORMAL_LINE.bottom_right,
   vertical_left =     NORMAL_LINE.vertical,
   vertical_right =    NORMAL_LINE.vertical,
   horizontal_top =    NORMAL_LINE.horizontal,
   horizontal_bottom = NORMAL_LINE.horizontal,
}

/// Border Set with a single line width and rounded corners
///
/// ```text
/// ╭─────╮
/// │xxxxx│
/// │xxxxx│
/// ╰─────╯
ROUNDED_BORDER :: Border_Set {
   top_left =          ROUNDED_LINE.top_left,
   top_right =         ROUNDED_LINE.top_right,
   bottom_left =       ROUNDED_LINE.bottom_left,
   bottom_right =      ROUNDED_LINE.bottom_right,
   vertical_left =     ROUNDED_LINE.vertical,
   vertical_right =    ROUNDED_LINE.vertical,
   horizontal_top =    ROUNDED_LINE.horizontal,
   horizontal_bottom = ROUNDED_LINE.horizontal,
}

/// Border Set with a double line width
///
/// ```text
/// ╔═════╗
/// ║xxxxx║
/// ║xxxxx║
/// ╚═════╝
DOUBLE_BORDER :: Border_Set {
   top_left =          DOUBLE_LINE.top_left,
   top_right =         DOUBLE_LINE.top_right,
   bottom_left =       DOUBLE_LINE.bottom_left,
   bottom_right =      DOUBLE_LINE.bottom_right,
   vertical_left =     DOUBLE_LINE.vertical,
   vertical_right =    DOUBLE_LINE.vertical,
   horizontal_top =    DOUBLE_LINE.horizontal,
   horizontal_bottom = DOUBLE_LINE.horizontal,
}

/// Border Set with a thick line width
///
/// ```text
/// ┏━━━━━┓
/// ┃xxxxx┃
/// ┃xxxxx┃
/// ┗━━━━━┛
THICK_BORDER :: Border_Set {
   top_left =          THICK_LINE.top_left,
   top_right =         THICK_LINE.top_right,
   bottom_left =       THICK_LINE.bottom_left,
   bottom_right =      THICK_LINE.bottom_right,
   vertical_left =     THICK_LINE.vertical,
   vertical_right =    THICK_LINE.vertical,
   horizontal_top =    THICK_LINE.horizontal,
   horizontal_bottom = THICK_LINE.horizontal,
}

QUADRANT_TOP_LEFT                           :: "▘"
QUADRANT_TOP_RIGHT                          :: "▝"
QUADRANT_BOTTOM_LEFT                        :: "▖"
QUADRANT_BOTTOM_RIGHT                       :: "▗"
QUADRANT_TOP_HALF                           :: "▀"
QUADRANT_BOTTOM_HALF                        :: "▄"
QUADRANT_LEFT_HALF                          :: "▌"
QUADRANT_RIGHT_HALF                         :: "▐"
QUADRANT_TOP_LEFT_BOTTOM_LEFT_BOTTOM_RIGHT  :: "▙"
QUADRANT_TOP_LEFT_TOP_RIGHT_BOTTOM_LEFT     :: "▛"
QUADRANT_TOP_LEFT_TOP_RIGHT_BOTTOM_RIGHT    :: "▜"
QUADRANT_TOP_RIGHT_BOTTOM_LEFT_BOTTOM_RIGHT :: "▟"
QUADRANT_TOP_LEFT_BOTTOM_RIGHT              :: "▚"
QUADRANT_TOP_RIGHT_BOTTOM_LEFT              :: "▞"
QUADRANT_BLOCK                              :: "█"

/// Quadrant used for setting a border outside a block by one half cell "pixel".
///
/// ```text
/// ▛▀▀▀▀▀▜
/// ▌xxxxx▐
/// ▌xxxxx▐
/// ▙▄▄▄▄▄▟
/// ```
QUADRANT_OUTSIDE_BORDER :: Border_Set {
   top_left =          QUADRANT_TOP_LEFT_TOP_RIGHT_BOTTOM_LEFT,
   top_right =         QUADRANT_TOP_LEFT_TOP_RIGHT_BOTTOM_RIGHT,
   bottom_left =       QUADRANT_TOP_LEFT_BOTTOM_LEFT_BOTTOM_RIGHT,
   bottom_right =      QUADRANT_TOP_RIGHT_BOTTOM_LEFT_BOTTOM_RIGHT,
   vertical_left =     QUADRANT_LEFT_HALF,
   vertical_right =    QUADRANT_RIGHT_HALF,
   horizontal_top =    QUADRANT_TOP_HALF,
   horizontal_bottom = QUADRANT_BOTTOM_HALF,
};

/// Quadrant used for setting a border inside a block by one half cell "pixel".
///
/// ```text
/// ▗▄▄▄▄▄▖
/// ▐xxxxx▌
/// ▐xxxxx▌
/// ▝▀▀▀▀▀▘
/// ```
QUADRANT_INSIDE_BORDER :: Border_Set {
   top_right =         QUADRANT_BOTTOM_LEFT,
   top_left =          QUADRANT_BOTTOM_RIGHT,
   bottom_right =      QUADRANT_TOP_LEFT,
   bottom_left =       QUADRANT_TOP_RIGHT,
   vertical_left =     QUADRANT_RIGHT_HALF,
   vertical_right =    QUADRANT_LEFT_HALF,
   horizontal_top =    QUADRANT_BOTTOM_HALF,
   horizontal_bottom = QUADRANT_TOP_HALF,
}

ONE_EIGHTH_TOP_EIGHT    :: "▔"
ONE_EIGHTH_BOTTOM_EIGHT :: "▁"
ONE_EIGHTH_LEFT_EIGHT   :: "▏"
ONE_EIGHTH_RIGHT_EIGHT  :: "▕"

/// Wide border set based on McGugan box technique
///
/// ```text
/// ▁▁▁▁▁▁▁
/// ▏xxxxx▕
/// ▏xxxxx▕
/// ▔▔▔▔▔▔▔
/// ```
ONE_EIGHTH_WIDE_BORDER :: Border_Set {
   top_right =         ONE_EIGHTH_BOTTOM_EIGHT,
   top_left =          ONE_EIGHTH_BOTTOM_EIGHT,
   bottom_right =      ONE_EIGHTH_TOP_EIGHT,
   bottom_left =       ONE_EIGHTH_TOP_EIGHT,
   vertical_left =     ONE_EIGHTH_LEFT_EIGHT,
   vertical_right =    ONE_EIGHTH_RIGHT_EIGHT,
   horizontal_top =    ONE_EIGHTH_BOTTOM_EIGHT,
   horizontal_bottom = ONE_EIGHTH_TOP_EIGHT,
}

/// Tall border set based on McGugan box technique
///
/// ```text
/// ▕▔▔▏
/// ▕xx▏
/// ▕xx▏
/// ▕▁▁▏
/// ```
ONE_EIGHTH_TALL_BORDER :: Border_Set {
   top_right =         ONE_EIGHTH_LEFT_EIGHT,
   top_left =          ONE_EIGHTH_RIGHT_EIGHT,
   bottom_right =      ONE_EIGHTH_LEFT_EIGHT,
   bottom_left =       ONE_EIGHTH_RIGHT_EIGHT,
   vertical_left =     ONE_EIGHTH_RIGHT_EIGHT,
   vertical_right =    ONE_EIGHTH_LEFT_EIGHT,
   horizontal_top =    ONE_EIGHTH_TOP_EIGHT,
   horizontal_bottom = ONE_EIGHTH_BOTTOM_EIGHT,
}

/// Wide proportional (visually equal width and height) border with using set of quadrants.
///
/// The border is created by using half blocks for top and bottom, and full
/// blocks for right and left sides to make horizontal and vertical borders seem equal.
///
/// ```text
/// ▄▄▄▄
/// █xx█
/// █xx█
/// ▀▀▀▀
/// ```
PROPORTIONAL_WIDE_BORDER :: Border_Set {
   top_right =         QUADRANT_BOTTOM_HALF,
   top_left =          QUADRANT_BOTTOM_HALF,
   bottom_right =      QUADRANT_TOP_HALF,
   bottom_left =       QUADRANT_TOP_HALF,
   vertical_left =     QUADRANT_BLOCK,
   vertical_right =    QUADRANT_BLOCK,
   horizontal_top =    QUADRANT_BOTTOM_HALF,
   horizontal_bottom = QUADRANT_TOP_HALF,
}

/// Tall proportional (visually equal width and height) border with using set of quadrants.
///
/// The border is created by using full blocks for all sides, except for the top and bottom,
/// which use half blocks to make horizontal and vertical borders seem equal.
///
/// ```text
/// ▕█▀▀█
/// ▕█xx█
/// ▕█xx█
/// ▕█▄▄█
/// ```
PROPORTIONAL_TALL_BORDER :: Border_Set {
   top_right =         QUADRANT_BLOCK,
   top_left =          QUADRANT_BLOCK,
   bottom_right =      QUADRANT_BLOCK,
   bottom_left =       QUADRANT_BLOCK,
   vertical_left =     QUADRANT_BLOCK,
   vertical_right =    QUADRANT_BLOCK,
   horizontal_top =    QUADRANT_TOP_HALF,
   horizontal_bottom = QUADRANT_BOTTOM_HALF,
}

BRAILLE_BLANK: u16 : 0x2800
BRAILLE_DOTS:  [4][2]u16 : {
   {0x0001, 0x0008},
   {0x0002, 0x0010},
   {0x0004, 0x0020},
   {0x0040, 0x0080},
}
