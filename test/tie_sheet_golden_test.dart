import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/presentation/widgets/tie_sheet_canvas_widget.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';

void main() {
  const uuid = Uuid();
  final generator = SingleEliminationBracketGeneratorServiceImplementation(uuid);

  final defaultTournament = TournamentEntity(
    id: 'golden-test',
    name: '2ND FEDERATION CUP - 2026 (Kyorugi & Poomsae)',
    dateRange: '18 Jan. to 22 Jan, 2026',
    venue: 'SMS Indoor Stadium, Jaipur, Rajasthan',
    organizer: 'INDIA TAEKWONDO',
    categoryLabel: 'JUNIOR',
    divisionLabel: 'BOYS',
    weightClassLabel: 'UNDER 59',
    createdAt: DateTime(2026),
  );

  List<ParticipantEntity> makeParticipants(int count) {
    final names = [
      ['Saiansh Mathur', 'Delhi', 'DL012025-22514'],
      ['R.S. Vignesh', 'Tamil Nadu', 'TN012024-14083'],
      ['Shashi Kumar', 'Haryana', 'HR172026-26123'],
      ['J. Vino', 'Tamil Nadu', 'TN222026-26267'],
      ['Aarush Barua', 'Chandigarh', 'CH012026-26255'],
      ['Asad Khan', 'UP', 'UP322025-20125'],
      ['Arsalan Siraj Khan', 'Maharashtra', 'MH032025-25234'],
      ['Ayush Kumar', 'UP', 'UP53202525572'],
      ['Lakshay Goyar', 'Rajasthan', 'RJ162026-25767'],
      ['Akash Kumar', 'UP', 'UP322024-16826'],
      ['Gedajit Irengbam', 'Manipur', 'MN042023-5340'],
      ['Pranjit Sakia', 'Assam', 'AS132023-6969'],
      ['Rajat Solanki', 'Rajasthan', 'RJ062022-4069'],
      ['Jay Dinesh Salaskar', 'Maharashtra', 'MH332025-25272'],
      ['Tej Pratap Sharma', 'Rajasthan', 'RJ082025-33001'],
      ['Apoorva Pandey', 'Delhi', 'DL052024-44100'],
    ];
    return List.generate(count, (i) => ParticipantEntity(
      id: uuid.v4(),
      divisionId: 'div1',
      fullName: names[i % names.length][0],
      schoolOrDojangName: names[i % names.length][1],
      registrationId: names[i % names.length][2],
      seedNumber: i + 1,
    ));
  }

  Future<void> runGoldenTest(WidgetTester tester, int playerCount, String goldenFileName, {bool include3rd = false}) async {
    final participants = makeParticipants(playerCount);
    final result = generator.generate(
      divisionId: 'div1',
      participantIds: participants.map((p) => p.id).toList(),
      bracketId: uuid.v4(),
      includeThirdPlaceMatch: include3rd,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: TieSheetCanvasWidget(
                tournament: defaultTournament,
                matches: result.matches,
                participants: participants,
                bracketType: 'Single Elimination',
                onMatchTap: (_) {},
                printKey: GlobalKey(),
                includeThirdPlaceMatch: include3rd,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CustomPaint), findsWidgets);
    await expectLater(
      find.byType(TieSheetCanvasWidget),
      matchesGoldenFile(goldenFileName),
    );

    // Print match info for debugging
    debugPrint('=== $playerCount PLAYER MATCH INFO ===');
    debugPrint('Total matches: ${result.matches.length}');
    for (final m in result.matches) {
      final red = m.participantRedId != null
          ? participants.where((p) => p.id == m.participantRedId).firstOrNull
          : null;
      final blue = m.participantBlueId != null
          ? participants.where((p) => p.id == m.participantBlueId).firstOrNull
          : null;
      debugPrint('R${m.roundNumber} M${m.matchNumberInRound}: '
          'Blue=${blue?.fullName ?? "BYE"} Red=${red?.fullName ?? "BYE"} '
          'Status=${m.status} Result=${m.resultType} '
          'Winner=${m.winnerId != null ? "yes" : "-"}');
    }

    final customPaints = tester.widgetList<CustomPaint>(find.byType(CustomPaint));
    final tiePaint = customPaints.firstWhere((cp) => cp.painter is TieSheetPainter);
    debugPrint('Canvas size: ${tiePaint.size}');
  }

  // 2 players: simplest bracket — 1 match, no BYEs
  testWidgets('2-player bracket', (tester) async {
    await runGoldenTest(tester, 2, '2_player_golden.png');
  });

  // 3 players: 1 BYE, asymmetric bracket
  testWidgets('3-player bracket', (tester) async {
    await runGoldenTest(tester, 3, '3_player_golden.png');
  });

  // 4 players: perfect bracket, no BYEs
  testWidgets('4-player bracket', (tester) async {
    await runGoldenTest(tester, 4, '4_player_golden.png');
  });

  // 5 players: 3 BYEs, heavily asymmetric
  testWidgets('5-player bracket', (tester) async {
    await runGoldenTest(tester, 5, '5_player_golden.png');
  });

  // 8 players: perfect bracket, no BYEs, 2 sides
  testWidgets('8-player bracket', (tester) async {
    await runGoldenTest(tester, 8, '8_player_golden.png');
  });

  // 14 players: 2 BYEs, realistic tournament size
  testWidgets('14-player bracket', (tester) async {
    await runGoldenTest(tester, 14, '14_player_golden.png');
  });

  // 16 players: perfect full bracket, no BYEs
  testWidgets('16-player bracket', (tester) async {
    await runGoldenTest(tester, 16, '16_player_golden.png');
  });

  // 14 players with 3rd place match
  testWidgets('14-player bracket with 3rd place', (tester) async {
    await runGoldenTest(tester, 14, '14_player_3rd_place_golden.png', include3rd: true);
  });

  // ─────────────────────────────────────────────────────────────
  // DOUBLE ELIMINATION GOLDENS
  // ─────────────────────────────────────────────────────────────

  final deGenerator = DoubleEliminationBracketGeneratorServiceImplementation(uuid);

  Future<void> runDEGoldenTest(WidgetTester tester, int playerCount, String goldenFileName) async {
    final participants = makeParticipants(playerCount);
    final result = deGenerator.generate(
      divisionId: 'div1',
      participantIds: participants.map((p) => p.id).toList(),
      winnersBracketId: 'wb-golden',
      losersBracketId: 'lb-golden',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: TieSheetCanvasWidget(
                tournament: defaultTournament,
                matches: result.allMatches,
                participants: participants,
                bracketType: 'Double Elimination',
                onMatchTap: (_) {},
                printKey: GlobalKey(),
                includeThirdPlaceMatch: false,
                winnersBracketId: 'wb-golden',
                losersBracketId: 'lb-golden',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CustomPaint), findsWidgets);
    await expectLater(
      find.byType(TieSheetCanvasWidget),
      matchesGoldenFile(goldenFileName),
    );

    // Print match info for debugging
    debugPrint('=== DE $playerCount PLAYER MATCH INFO ===');
    debugPrint('Total matches: ${result.allMatches.length}');
    final wbMatches = result.allMatches.where((m) => m.bracketId == 'wb-golden').toList();
    final lbMatches = result.allMatches.where((m) => m.bracketId == 'lb-golden').toList();
    final gfMatches = result.allMatches.where((m) => m.bracketId != 'wb-golden' && m.bracketId != 'lb-golden').toList();
    debugPrint('WB matches: ${wbMatches.length}, LB matches: ${lbMatches.length}, GF matches: ${gfMatches.length}');
    for (final m in result.allMatches) {
      final red = m.participantRedId != null
          ? participants.where((p) => p.id == m.participantRedId).firstOrNull
          : null;
      final blue = m.participantBlueId != null
          ? participants.where((p) => p.id == m.participantBlueId).firstOrNull
          : null;
      debugPrint('Bracket=${m.bracketId == 'wb-golden' ? 'WB' : m.bracketId == 'lb-golden' ? 'LB' : 'GF'} '
          'R${m.roundNumber} M${m.matchNumberInRound}: '
          'Blue=${blue?.fullName ?? "TBD"} Red=${red?.fullName ?? "TBD"} '
          'Status=${m.status} Result=${m.resultType}');
    }
  }

  // DE 2 players: simplest — 1 WB match + GF
  testWidgets('DE 2-player bracket', (tester) async {
    await runDEGoldenTest(tester, 2, 'de_2_player_golden.png');
  });

  // DE 4 players: small complete bracket
  testWidgets('DE 4-player bracket', (tester) async {
    await runDEGoldenTest(tester, 4, 'de_4_player_golden.png');
  });

  // DE 5 players: 3 BYEs, asymmetric with phantom LB matches
  testWidgets('DE 5-player bracket', (tester) async {
    await runDEGoldenTest(tester, 5, 'de_5_player_golden.png');
  });

  // DE 8 players: full symmetric bracket, no BYEs
  testWidgets('DE 8-player bracket', (tester) async {
    await runDEGoldenTest(tester, 8, 'de_8_player_golden.png');
  });
}
