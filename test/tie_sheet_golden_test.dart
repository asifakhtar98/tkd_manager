import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:tkd_saas/features/bracket/domain/entities/tournament_info.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';
// TieSheetPainter is in tie_sheet_canvas_widget.dart
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

void main() {
  const uuid = Uuid();

  List<ParticipantEntity> make14Players() {
    final data = [
      ['Saiansh', 'Mathur', 'Delhi', 'DL012025-22514'],
      ['R.S.', 'Vignesh', 'Tamil Nadu', 'TN012024-14083'],
      ['Shashi', 'Kumar', 'Haryana', 'HR172026-26123'],
      ['J.', 'Vino', 'Tamil Nadu', 'TN222026-26267'],
      ['Aarush', 'Barua', 'Chandigarh', 'CH012026-26255'],
      ['Asad', 'Khan', 'UP', 'UP322025-20125'],
      ['Arsalan Siraj', 'Khan', 'Maharashtra', 'MH032025-25234'],
      ['Ayush', 'Kumar', 'UP', 'UP53202525572'],
      ['Lakshay', 'Goyar', 'Rajasthan', 'RJ162026-25767'],
      ['Akash', 'Kumar', 'UP', 'UP322024-16826'],
      ['Gedajit', 'Irengbam', 'Manipur', 'MN042023-5340'],
      ['Pranjit', 'Sakia', 'Assam', 'AS132023-6969'],
      ['Rajat', 'Solanki', 'Rajasthan', 'RJ062022-4069'],
      ['Jay Dinesh', 'Salaskar', 'Maharashtra', 'MH332025-25272'],
    ];
    return List.generate(data.length, (i) => ParticipantEntity(
      id: uuid.v4(),
      divisionId: 'div1',
      firstName: data[i][0],
      lastName: data[i][1],
      schoolOrDojangName: data[i][2],
      registrationId: data[i][3],
      seedNumber: i + 1,
    ));
  }

  testWidgets('14-player tie sheet renders correctly', (tester) async {
    final participants = make14Players();
    final generator = SingleEliminationBracketGeneratorServiceImplementation(uuid);
    final result = generator.generate(
      divisionId: 'div1',
      participantIds: participants.map((p) => p.id).toList(),
      bracketId: uuid.v4(),
    );

    final tournamentInfo = TournamentInfo(
      tournamentName: '2ND FEDERATION CUP - 2026 (Kyorugi & Poomsae)',
      dateRange: '18 Jan. to 22 Jan, 2026',
      venue: 'SMS Indoor Stadium, Jaipur, Rajasthan',
      organizer: 'INDIA TAEKWONDO',
      categoryLabel: 'JUNIOR',
      divisionLabel: 'BOYS',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: TieSheetCanvasWidget(
                tournamentInfo: tournamentInfo,
                matches: result.matches,
                participants: participants,
                bracketType: 'Single Elimination',
                onMatchTap: (_) {},
                printKey: GlobalKey(),
                includeThirdPlaceMatch: false,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify no errors during rendering
    expect(find.byType(CustomPaint), findsWidgets);

    // Verify canvas has proper size - find the one with TieSheetPainter
    final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
    final tiePaint = customPaints.firstWhere((cp) => cp.painter is TieSheetPainter);
    expect(tiePaint.size, isNotNull);
    expect(tiePaint.size!.width, greaterThan(0));
    expect(tiePaint.size!.height, greaterThan(0));

    // Debug: Print match info
    debugPrint('=== MATCH INFO ===');
    debugPrint('Total matches: ${result.matches.length}');
    for (final m in result.matches) {
      final red = m.participantRedId != null
          ? participants.where((p) => p.id == m.participantRedId).firstOrNull
          : null;
      final blue = m.participantBlueId != null
          ? participants.where((p) => p.id == m.participantBlueId).firstOrNull
          : null;
      debugPrint('R${m.roundNumber} M${m.matchNumberInRound}: '
          'Red=${red?.lastName ?? "null"} Blue=${blue?.lastName ?? "null"} '
          'Status=${m.status} Result=${m.resultType} Winner=${m.winnerId != null ? "yes" : "null"}');
    }

    // Print canvas size
    debugPrint('Canvas size: ${tiePaint.size}');
  });

  testWidgets('4-player tie sheet renders correctly', (tester) async {
    final participants = [
      ParticipantEntity(id: uuid.v4(), divisionId: 'div1', firstName: 'John', lastName: 'Doe',
          schoolOrDojangName: 'Eagle TKD', registrationId: 'DL012025-22514', seedNumber: 1),
      ParticipantEntity(id: uuid.v4(), divisionId: 'div1', firstName: 'Jane', lastName: 'Smith',
          schoolOrDojangName: 'Tiger TKD', registrationId: 'TN012024-14083', seedNumber: 2),
      ParticipantEntity(id: uuid.v4(), divisionId: 'div1', firstName: 'Mike', lastName: 'Lee',
          schoolOrDojangName: 'Eagle TKD', registrationId: 'HR172026-26123', seedNumber: 3),
      ParticipantEntity(id: uuid.v4(), divisionId: 'div1', firstName: 'Sarah', lastName: 'Connor',
          schoolOrDojangName: 'Dragon TKD', registrationId: 'TN222026-26267', seedNumber: 4),
    ];

    final generator = SingleEliminationBracketGeneratorServiceImplementation(uuid);
    final result = generator.generate(
      divisionId: 'div1',
      participantIds: participants.map((p) => p.id).toList(),
      bracketId: uuid.v4(),
    );

    final tournamentInfo = TournamentInfo(
      tournamentName: 'TEST TOURNAMENT',
      dateRange: '2026',
      venue: 'Test Venue',
      organizer: 'TEST ORG',
      categoryLabel: 'JUNIOR',
      divisionLabel: 'BOYS',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: TieSheetCanvasWidget(
                tournamentInfo: tournamentInfo,
                matches: result.matches,
                participants: participants,
                bracketType: 'Single Elimination',
                onMatchTap: (_) {},
                printKey: GlobalKey(),
                includeThirdPlaceMatch: false,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CustomPaint), findsWidgets);

    debugPrint('=== 4 PLAYER MATCH INFO ===');
    for (final m in result.matches) {
      final red = m.participantRedId != null
          ? participants.where((p) => p.id == m.participantRedId).firstOrNull
          : null;
      final blue = m.participantBlueId != null
          ? participants.where((p) => p.id == m.participantBlueId).firstOrNull
          : null;
      debugPrint('R${m.roundNumber} M${m.matchNumberInRound}: '
          'Red=${red?.lastName ?? "null"} Blue=${blue?.lastName ?? "null"} '
          'Status=${m.status} Result=${m.resultType}');
    }
  });
}
