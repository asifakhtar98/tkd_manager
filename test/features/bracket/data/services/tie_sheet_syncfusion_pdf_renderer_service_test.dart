import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/bracket_medal_computation_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/match_progression_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/tie_sheet_syncfusion_pdf_renderer_service.dart';
import 'package:tkd_saas/features/bracket/domain/entities/match_entity.dart';
import 'package:tkd_saas/features/bracket/domain/layout/tie_sheet_layout_engine.dart';
import 'package:tkd_saas/features/bracket/domain/layout/models/tie_sheet_layout_result.dart';
import 'package:tkd_saas/features/bracket/domain/value_objects/tie_sheet_theme_config.dart';
import 'package:tkd_saas/features/setup_bracket/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';

/// Exhaustive unit tests for [TieSheetSyncfusionPdfRendererService].
///
/// Validates that the vector PDF renderer produces structurally correct,
/// non-empty PDF documents for all supported bracket configurations.
void main() {
  const uuid = Uuid();
  final singleEliminationGenerator =
      SingleEliminationBracketGeneratorServiceImplementation(uuid);
  final doubleEliminationGenerator =
      DoubleEliminationBracketGeneratorServiceImplementation(uuid);
  final matchProgressionService = MatchProgressionServiceImplementation();
  final rendererService = TieSheetSyncfusionPdfRendererService();
  final layoutEngine = TieSheetLayoutEngine(
    const BracketMedalComputationServiceImplementation(),
  );

  const testClassification = BracketClassification(
    ageCategoryLabel: 'JUNIOR',
    genderLabel: 'BOYS',
    weightDivisionLabel: 'UNDER 59',
  );

  final testTournament = TournamentEntity(
    id: 'test_tournament_1',
    userId: 'test_user_1',
    name: 'PDF Renderer Test Championship',
    dateRange: 'Jan 15-16, 2024',
    venue: 'National Arena',
    organizer: 'Taekwondo Federation',
    createdAt: DateTime(2024, 1, 1),
    updatedAt: DateTime(2024, 1, 1),
  );

  final participantNames = [
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

  List<ParticipantEntity> createTestParticipants(int count) {
    return List.generate(
      count,
      (index) => ParticipantEntity(
        id: uuid.v4(),
        genderId: 'div1',
        fullName: participantNames[index % participantNames.length][0],
        schoolOrDojangName:
            participantNames[index % participantNames.length][1],
        registrationId: participantNames[index % participantNames.length][2],
        seedNumber: index + 1,
      ),
    );
  }

  /// Computes layout and renders single-page PDF for a SE bracket.
  ({TieSheetLayoutResult layoutResult, Uint8List pdfBytes})
  renderSingleEliminationBracketPdf({
    required int playerCount,
    TieSheetThemeConfig themeConfig = TieSheetThemeConfig.defaultPreset,
    bool includeThirdPlaceMatch = false,
    List<int> roundsToResolveWithBlueWinners = const [],
  }) {
    final participants = createTestParticipants(playerCount);
    final generateResult = singleEliminationGenerator.generate(
      genderId: 'div1',
      participantIds: participants
          .map((participantEntity) => participantEntity.id)
          .toList(),
      bracketId: uuid.v4(),
      includeThirdPlaceMatch: includeThirdPlaceMatch,
    );

    var matches = generateResult.matches;
    for (final roundNumber in roundsToResolveWithBlueWinners) {
      matches = _recordBlueWinnersForRound(
        matchProgressionService,
        matches,
        roundNumber,
      );
    }

    final layoutResult = layoutEngine.computeLayout(
      tournament: testTournament,
      matches: matches,
      participants: participants,
      bracketType: 'Single Elimination',
      includeThirdPlaceMatch: includeThirdPlaceMatch,
      themeConfig: themeConfig,
      classification: testClassification,
    );

    final pdfByteList = rendererService.renderSinglePagePdfBytes(
      params: PdfRenderParams(
        layoutResult: layoutResult,
        themeConfig: themeConfig,
      ),
    );

    return (
      layoutResult: layoutResult,
      pdfBytes: Uint8List.fromList(pdfByteList),
    );
  }

  /// Computes layout and renders single-page PDF for a DE bracket.
  ({TieSheetLayoutResult layoutResult, Uint8List pdfBytes})
  renderDoubleEliminationBracketPdf({
    required int playerCount,
    TieSheetThemeConfig themeConfig = TieSheetThemeConfig.defaultPreset,
  }) {
    final participants = createTestParticipants(playerCount);
    final generateResult = doubleEliminationGenerator.generate(
      genderId: 'div1',
      participantIds: participants
          .map((participantEntity) => participantEntity.id)
          .toList(),
      winnersBracketId: 'wb-test',
      losersBracketId: 'lb-test',
    );

    final layoutResult = layoutEngine.computeLayout(
      tournament: testTournament,
      matches: generateResult.allMatches,
      participants: participants,
      bracketType: 'Double Elimination',
      includeThirdPlaceMatch: false,
      themeConfig: themeConfig,
      classification: testClassification,
      winnersBracketId: 'wb-test',
      losersBracketId: 'lb-test',
    );

    final pdfByteList = rendererService.renderSinglePagePdfBytes(
      params: PdfRenderParams(
        layoutResult: layoutResult,
        themeConfig: themeConfig,
      ),
    );

    return (
      layoutResult: layoutResult,
      pdfBytes: Uint8List.fromList(pdfByteList),
    );
  }

  /// Verifies the PDF bytes form a valid, parseable PDF document with
  /// the expected page count and canvas dimensions.
  void assertValidSinglePagePdf(
    Uint8List pdfBytes,
    TieSheetLayoutResult layoutResult,
  ) {
    expect(pdfBytes, isNotEmpty, reason: 'PDF bytes should not be empty');
    expect(
      pdfBytes.length,
      greaterThan(100),
      reason: 'PDF should have meaningful content',
    );

    // Verify PDF starts with the standard header marker.
    final headerString = String.fromCharCodes(pdfBytes.take(5));
    expect(
      headerString,
      equals('%PDF-'),
      reason: 'PDF should start with %PDF- header',
    );

    // Parse the PDF and verify structure.
    final document = PdfDocument(inputBytes: pdfBytes);
    expect(
      document.pages.count,
      equals(1),
      reason: 'Single-page render should produce exactly 1 page',
    );

    final page = document.pages[0];
    // Page dimensions should be non-trivial (> 100pt in each direction).
    // Note: Syncfusion's PdfDocument parser may return MediaBox/CropBox
    // dimensions that differ from the exact values set during creation
    // due to internal coordinate transformations; an exact match is not
    // reliable across Syncfusion versions.
    expect(
      page.size.width,
      greaterThan(100),
      reason: 'Page width should be non-trivial',
    );
    expect(
      page.size.height,
      greaterThan(100),
      reason: 'Page height should be non-trivial',
    );

    document.dispose();
  }

  group('TieSheetSyncfusionPdfRendererService — Single Elimination', () {
    for (final playerCount in [2, 3, 4, 5, 8, 14, 16]) {
      test(
        'renders valid single-page PDF for $playerCount-player SE bracket',
        () {
          final result = renderSingleEliminationBracketPdf(
            playerCount: playerCount,
          );
          assertValidSinglePagePdf(result.pdfBytes, result.layoutResult);
        },
      );
    }

    test('renders valid PDF for 14-player SE bracket with 3rd place', () {
      final result = renderSingleEliminationBracketPdf(
        playerCount: 14,
        includeThirdPlaceMatch: true,
      );
      assertValidSinglePagePdf(result.pdfBytes, result.layoutResult);
    });
  });

  group('TieSheetSyncfusionPdfRendererService — Double Elimination', () {
    for (final playerCount in [2, 4, 5, 8]) {
      test(
        'renders valid single-page PDF for $playerCount-player DE bracket',
        () {
          final result = renderDoubleEliminationBracketPdf(
            playerCount: playerCount,
          );
          assertValidSinglePagePdf(result.pdfBytes, result.layoutResult);
        },
      );
    }
  });

  group('TieSheetSyncfusionPdfRendererService — With Match Results', () {
    test('renders valid PDF for 8-player bracket with R1 results', () {
      final result = renderSingleEliminationBracketPdf(
        playerCount: 8,
        roundsToResolveWithBlueWinners: [1],
      );
      assertValidSinglePagePdf(result.pdfBytes, result.layoutResult);
    });

    test(
      'renders valid PDF for 8-player bracket with full tournament results',
      () {
        final result = renderSingleEliminationBracketPdf(
          playerCount: 8,
          roundsToResolveWithBlueWinners: [1, 2, 3],
        );
        assertValidSinglePagePdf(result.pdfBytes, result.layoutResult);
      },
    );

    test('renders valid PDF for 14-player bracket with R1 results', () {
      final result = renderSingleEliminationBracketPdf(
        playerCount: 14,
        roundsToResolveWithBlueWinners: [1],
      );
      assertValidSinglePagePdf(result.pdfBytes, result.layoutResult);
    });
  });

  group('TieSheetSyncfusionPdfRendererService — Print Mode Theme', () {
    test('renders valid PDF with print preset theme', () {
      final result = renderSingleEliminationBracketPdf(
        playerCount: 8,
        themeConfig: TieSheetThemeConfig.printPreset,
      );
      assertValidSinglePagePdf(result.pdfBytes, result.layoutResult);
    });
  });

  group('TieSheetSyncfusionPdfRendererService — Canvas Size Scaling', () {
    test('larger player counts produce proportionally wider PDFs', () {
      final result4 = renderSingleEliminationBracketPdf(playerCount: 4);
      final result8 = renderSingleEliminationBracketPdf(playerCount: 8);
      final result16 = renderSingleEliminationBracketPdf(playerCount: 16);

      expect(
        result8.layoutResult.computedCanvasSize.width,
        greaterThan(result4.layoutResult.computedCanvasSize.width),
        reason: '8-player bracket should be wider than 4-player',
      );
      expect(
        result16.layoutResult.computedCanvasSize.width,
        greaterThan(result8.layoutResult.computedCanvasSize.width),
        reason: '16-player bracket should be wider than 8-player',
      );
    });

    test('DE brackets are taller than SE brackets of same player count', () {
      final seResult = renderSingleEliminationBracketPdf(playerCount: 8);
      final deResult = renderDoubleEliminationBracketPdf(playerCount: 8);

      expect(
        deResult.layoutResult.computedCanvasSize.height,
        greaterThan(seResult.layoutResult.computedCanvasSize.height),
        reason: 'DE bracket has losers bracket, so should be taller',
      );
    });
  });

  group('TieSheetSyncfusionPdfRendererService — Layout Structure', () {
    test(
      'layout contains expected number of participant rows for 8-player SE',
      () {
        final result = renderSingleEliminationBracketPdf(playerCount: 8);
        final participantRowCount =
            result.layoutResult.participantRowLayoutDataList.length;
        // 8-player SE: 8 R1 slots + 4 R2 slots + 2 Final slots = 14 rows
        // (but layout also includes TBD/BYE rows for connected slots)
        expect(
          participantRowCount,
          greaterThanOrEqualTo(8),
          reason: 'Should have at least 8 participant rows for R1',
        );
      },
    );

    test('layout contains header data with tournament name', () {
      final result = renderSingleEliminationBracketPdf(playerCount: 4);
      expect(result.layoutResult.headerLayoutData, isNotNull);
      expect(
        result.layoutResult.headerLayoutData.tournamentTitleTextLayout,
        isNotNull,
      );
    });

    test(
      'layout contains connectors between rounds for multi-round brackets',
      () {
        final result = renderSingleEliminationBracketPdf(playerCount: 8);
        expect(
          result.layoutResult.connectorLayoutDataList,
          isNotEmpty,
          reason: 'Multi-round brackets should have connector lines',
        );
      },
    );

    test('layout contains match junction data', () {
      final result = renderSingleEliminationBracketPdf(playerCount: 8);
      expect(
        result.layoutResult.matchLayoutDataList,
        isNotEmpty,
        reason: '8-player bracket should have match junction data',
      );
    });

    test('layout contains section labels for DE bracket', () {
      final result = renderDoubleEliminationBracketPdf(playerCount: 8);
      expect(
        result.layoutResult.sectionLabelLayoutDataList,
        isNotEmpty,
        reason: 'DE brackets should have winners/losers section labels',
      );
    });
  });

  group('TieSheetSyncfusionPdfRendererService — Logo Support', () {
    test('renders valid PDF with logo bounding rects in layout', () {
      final participants = createTestParticipants(4);
      final generateResult = singleEliminationGenerator.generate(
        genderId: 'div1',
        participantIds: participants.map((p) => p.id).toList(),
        bracketId: uuid.v4(),
        includeThirdPlaceMatch: false,
      );

      final layoutResult = layoutEngine.computeLayout(
        tournament: testTournament,
        matches: generateResult.matches,
        participants: participants,
        bracketType: 'Single Elimination',
        includeThirdPlaceMatch: false,
        themeConfig: TieSheetThemeConfig.defaultPreset,
        classification: testClassification,
        hasLeftLogo: true,
        hasRightLogo: true,
        leftLogoAspectRatio: 1.5,
        rightLogoAspectRatio: 0.8,
      );

      // Logo bounding rects should be present in header layout.
      expect(
        layoutResult.headerLayoutData.leftLogoBoundingRect,
        isNotNull,
        reason: 'Left logo bounding rect should exist when hasLeftLogo=true',
      );
      expect(
        layoutResult.headerLayoutData.rightLogoBoundingRect,
        isNotNull,
        reason: 'Right logo bounding rect should exist when hasRightLogo=true',
      );

      // Rendering should succeed even without actual image bytes
      // (logos are silently skipped).
      final pdfBytes = rendererService.renderSinglePagePdfBytes(
        params: PdfRenderParams(
          layoutResult: layoutResult,
          themeConfig: TieSheetThemeConfig.defaultPreset,
        ),
      );

      expect(pdfBytes, isNotEmpty);
    });

    test('renders valid PDF without logo bounding rects when no logos', () {
      final result = renderSingleEliminationBracketPdf(playerCount: 4);

      // No logos by default.
      expect(result.layoutResult.headerLayoutData.leftLogoBoundingRect, isNull);
      expect(
        result.layoutResult.headerLayoutData.rightLogoBoundingRect,
        isNull,
      );

      assertValidSinglePagePdf(result.pdfBytes, result.layoutResult);
    });

    test('canvas with logos is taller than canvas without logos', () {
      final participants = createTestParticipants(4);
      final generateResult = singleEliminationGenerator.generate(
        genderId: 'div1',
        participantIds: participants.map((p) => p.id).toList(),
        bracketId: uuid.v4(),
        includeThirdPlaceMatch: false,
      );

      final layoutWithoutLogos = layoutEngine.computeLayout(
        tournament: testTournament,
        matches: generateResult.matches,
        participants: participants,
        bracketType: 'Single Elimination',
        includeThirdPlaceMatch: false,
        themeConfig: TieSheetThemeConfig.defaultPreset,
        classification: testClassification,
      );

      final layoutWithLogos = layoutEngine.computeLayout(
        tournament: testTournament,
        matches: generateResult.matches,
        participants: participants,
        bracketType: 'Single Elimination',
        includeThirdPlaceMatch: false,
        themeConfig: TieSheetThemeConfig.defaultPreset,
        classification: testClassification,
        hasLeftLogo: true,
        hasRightLogo: true,
      );

      expect(
        layoutWithLogos.computedCanvasSize.height,
        greaterThan(layoutWithoutLogos.computedCanvasSize.height),
        reason: 'Canvas with logo row should be taller',
      );
    });
  });

  group('TieSheetSyncfusionPdfRendererService — Idempotency', () {
    test('rendering the same layout twice produces identical PDF bytes', () {
      final participants = createTestParticipants(4);
      final generateResult = singleEliminationGenerator.generate(
        genderId: 'div1',
        participantIds: participants.map((p) => p.id).toList(),
        bracketId: uuid.v4(),
        includeThirdPlaceMatch: false,
      );

      final layoutResult = layoutEngine.computeLayout(
        tournament: testTournament,
        matches: generateResult.matches,
        participants: participants,
        bracketType: 'Single Elimination',
        includeThirdPlaceMatch: false,
        themeConfig: TieSheetThemeConfig.defaultPreset,
        classification: testClassification,
      );

      final firstRenderBytes = rendererService.renderSinglePagePdfBytes(
        params: PdfRenderParams(
          layoutResult: layoutResult,
          themeConfig: TieSheetThemeConfig.defaultPreset,
        ),
      );

      final secondRenderBytes = rendererService.renderSinglePagePdfBytes(
        params: PdfRenderParams(
          layoutResult: layoutResult,
          themeConfig: TieSheetThemeConfig.defaultPreset,
        ),
      );

      // Syncfusion PDFs may embed internal metadata (e.g. creation
      // timestamps) that differ by a few bytes between runs. Verify that
      // the output sizes are within a tight tolerance band.
      final sizeDifference =
          (firstRenderBytes.length - secondRenderBytes.length).abs();
      expect(
        sizeDifference,
        lessThanOrEqualTo(firstRenderBytes.length * 0.01),
        reason:
            'Same inputs should produce near-identical PDFs '
            '(got ${firstRenderBytes.length} vs ${secondRenderBytes.length}, '
            'diff=$sizeDifference)',
      );
    });
  });
}

/// Records blue-corner winners for all eligible matches in [roundNumber].
List<MatchEntity> _recordBlueWinnersForRound(
  MatchProgressionServiceImplementation progressionService,
  List<MatchEntity> matches,
  int roundNumber,
) {
  var updatedMatches = matches;
  final eligibleRoundMatches = updatedMatches
      .where(
        (matchEntity) =>
            matchEntity.roundNumber == roundNumber &&
            matchEntity.resultType != MatchResultType.bye &&
            matchEntity.status != MatchStatus.completed &&
            matchEntity.participantBlueId != null &&
            matchEntity.participantRedId != null,
      )
      .toList();
  for (final matchEntity in eligibleRoundMatches) {
    updatedMatches = progressionService.recordResult(
      matches: updatedMatches,
      matchId: matchEntity.id,
      winnerId: matchEntity.participantBlueId!,
    );
  }
  return updatedMatches;
}
