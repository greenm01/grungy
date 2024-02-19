package widgets

// Elements related to the `Block` base widget.
//
// This holds everything needed to display and configure a [`Block`].
//
// In its simplest form, a `Block` is a [border](Borders) around another widget. It can have a

Block :: struct  {
    titles:           []Title,
    titles_style:     Style,
    titles_alignment: Alignment,
    titles_position:  Position,
    borders:          Borders,
    border_style:     Style,
    border_set:       Border_Set,
    style:            Style,
    padding:          Padding,

    widget:           Widget_List,
}

BorderType :: enum {
    /// A plain, simple border.
    ///
    /// This is the default
    ///
    /// # Example
    ///
    /// ```plain
    /// ┌───────┐
    /// │       │
    /// └───────┘
    /// ```
    Plain,
    /// A plain border with rounded corners.
    ///
    /// # Example
    ///
    /// ```plain
    /// ╭───────╮
    /// │       │
    /// ╰───────╯
    /// ```
    Rounded,
    /// A doubled border.
    ///
    /// Note this uses one character that draws two lines.
    ///
    /// # Example
    ///
    /// ```plain
    /// ╔═══════╗
    /// ║       ║
    /// ╚═══════╝
    /// ```
    Double,
    /// A thick border.
    ///
    /// # Example
    ///
    /// ```plain
    /// ┏━━━━━━━┓
    /// ┃       ┃
    /// ┗━━━━━━━┛
    /// ```
    Thick,
    /// A border with a single line on the inside of a half block.
    ///
    /// # Example
    ///
    /// ```plain
    /// ▗▄▄▄▄▄▄▄▖
    /// ▐       ▌
    /// ▐       ▌
    /// ▝▀▀▀▀▀▀▀▘
    QuadrantInside,

    /// A border with a single line on the outside of a half block.
    ///
    /// # Example
    ///
    /// ```plain
    /// ▛▀▀▀▀▀▀▀▜
    /// ▌       ▐
    /// ▌       ▐
    /// ▙▄▄▄▄▄▄▄▟
    QuadrantOutside,
}
