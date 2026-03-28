enum BracketFormat {
  /// Standard single-elimination (knockout) tournament.
  singleElimination('Single Elimination'),

  /// Double-elimination tournament with winners / losers brackets and grand
  /// finals.
  doubleElimination('Double Elimination');

  const BracketFormat(this.displayLabel);

  /// Human-readable label used in UI text, PDF headers, and snapshot labels.
  final String displayLabel;
}
