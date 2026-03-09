class TournamentInfo {
  final String tournamentName;
  final String dateRange;
  final String venue;
  final String organizer;
  final String categoryLabel; // e.g., "JUNIOR"
  final String divisionLabel; // e.g., "BOYS"

  const TournamentInfo({
    this.tournamentName = '',
    this.dateRange = '',
    this.venue = '',
    this.organizer = '',
    this.categoryLabel = '',
    this.divisionLabel = '',
  });

  TournamentInfo copyWith({
    String? tournamentName,
    String? dateRange,
    String? venue,
    String? organizer,
    String? categoryLabel,
    String? divisionLabel,
  }) {
    return TournamentInfo(
      tournamentName: tournamentName ?? this.tournamentName,
      dateRange: dateRange ?? this.dateRange,
      venue: venue ?? this.venue,
      organizer: organizer ?? this.organizer,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      divisionLabel: divisionLabel ?? this.divisionLabel,
    );
  }
}
