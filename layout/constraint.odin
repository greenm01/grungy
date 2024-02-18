package layout

/// A constraint that defines the size of a layout element.
///
/// Constraints can be used to specify a fixed size, a percentage of the available space, a ratio of
/// the available space, a minimum or maximum size or a fill proportional value for a layout
/// element.
///
/// Relative constraints (percentage, ratio) are calculated relative to the entire space being
/// divided, rather than the space available after applying more fixed constraints (min, max,
/// length).
///
/// Constraints are prioritized in the following order:
///
/// 1. Constraint.Min
/// 2. Constraint.Max
/// 3. Constraint.Length
/// 4. Constraint.Percentage
/// 5. Constraint.Ratio
/// 6. Constraint.Fill

Constraint :: enum {
    /// Applies a minimum size constraint to the element
    ///
    /// The element size is set to at least the specified amount.
    ///
    /// # Examples
    ///
    /// `[Percentage(100), Min(20)]`
    ///
    /// ```plain
    /// ┌────────────────────────────┐┌──────────────────┐
    /// │            30 px           ││       20 px      │
    /// └────────────────────────────┘└──────────────────┘
    /// ```
    ///
    /// `[Percentage(100), Min(10)]`
    ///
    /// ```plain
    /// ┌──────────────────────────────────────┐┌────────┐
    /// │                 40 px                ││  10 px │
    /// └──────────────────────────────────────┘└────────┘
    /// ```
    Min,

    /// Applies a maximum size constraint to the element
    ///
    /// The element size is set to at most the specified amount.
    ///
    /// # Examples
    ///
    /// `[Percentage(0), Max(20)]`
    ///
    /// ```plain
    /// ┌────────────────────────────┐┌──────────────────┐
    /// │            30 px           ││       20 px      │
    /// └────────────────────────────┘└──────────────────┘
    /// ```
    ///
    /// `[Percentage(0), Max(10)]`
    ///
    /// ```plain
    /// ┌──────────────────────────────────────┐┌────────┐
    /// │                 40 px                ││  10 px │
    /// └──────────────────────────────────────┘└────────┘
    /// ```
    Max,

    /// Applies a length constraint to the element
    ///
    /// The element size is set to the specified amount.
    ///
    /// # Examples
    ///
    /// `[Length(20), Length(20)]`
    ///
    /// ```plain
    /// ┌──────────────────┐┌──────────────────┐
    /// │       20 px      ││       20 px      │
    /// └──────────────────┘└──────────────────┘
    /// ```
    ///
    /// `[Length(20), Length(30)]`
    ///
    /// ```plain
    /// ┌──────────────────┐┌────────────────────────────┐
    /// │       20 px      ││            30 px           │
    /// └──────────────────┘└────────────────────────────┘
    /// ```
    Length,

    /// Applies a percentage of the available space to the element
    ///
    /// Converts the given percentage to a floating-point value and multiplies that with area.
    /// This value is rounded back to a integer as part of the layout split calculation.
    ///
    /// # Examples
    ///
    /// `[Percentage(75), Fill(1)]`
    ///
    /// ```plain
    /// ┌────────────────────────────────────┐┌──────────┐
    /// │                38 px               ││   12 px  │
    /// └────────────────────────────────────┘└──────────┘
    /// ```
    ///
    /// `[Percentage(50), Fill(1)]`
    ///
    /// ```plain
    /// ┌───────────────────────┐┌───────────────────────┐
    /// │         25 px         ││         25 px         │
    /// └───────────────────────┘└───────────────────────┘
    /// ```
    Percentage,

    /// Applies a ratio of the available space to the element
    ///
    /// Converts the given ratio to a floating-point value and multiplies that with area.
    /// This value is rounded back to a integer as part of the layout split calculation.
    ///
    /// # Examples
    ///
    /// `[Ratio(1, 2) ; 2]`
    ///
    /// ```plain
    /// ┌───────────────────────┐┌───────────────────────┐
    /// │         25 px         ││         25 px         │
    /// └───────────────────────┘└───────────────────────┘
    /// ```
    ///
    /// `[Ratio(1, 4) ; 4]`
    ///
    /// ```plain
    /// ┌───────────┐┌──────────┐┌───────────┐┌──────────┐
    /// │   13 px   ││   12 px  ││   13 px   ││   12 px  │
    /// └───────────┘└──────────┘└───────────┘└──────────┘
    /// ```
    Ratio,

    /// Applies the scaling factor proportional to all other [`Constraint::Fill`] elements
    /// to fill excess space
    ///
    /// The element will only expand or fill into excess available space, proportionally matching
    /// other [`Constraint::Fill`] elements while satisfying all other constraints.
    ///
    /// # Examples
    ///
    ///
    /// `[Fill(1), Fill(2), Fill(3)]`
    ///
    /// ```plain
    /// ┌──────┐┌───────────────┐┌───────────────────────┐
    /// │ 8 px ││     17 px     ││         25 px         │
    /// └──────┘└───────────────┘└───────────────────────┘
    /// ```
    ///
    /// `[Fill(1), Percentage(50), Fill(1)]`
    ///
    /// ```plain
    /// ┌───────────┐┌───────────────────────┐┌──────────┐
    /// │   13 px   ││         25 px         ││   12 px  │
    /// └───────────┘└───────────────────────┘└──────────┘
    /// ```
    Fill,
}

from_lengths :: proc(lengths: []int) -> (cnst: map[int]Constraint) {
   cnst = make(map[int]Constraint)
   for i in lengths {
      cnst[i] = Constraint.Length
   }
   return
}
