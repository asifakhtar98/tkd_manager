import 'package:tkd_saas/core/router/app_routes.dart';
import 'package:tkd_saas/features/bracket/data/services/double_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/participant/domain/entities/participant_entity.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_classification.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:uuid/uuid.dart';

/// Generates pre-built [BracketSnapshot]s for the demo tournament.
///
/// Uses the real bracket-generation service implementations (they are
/// stateless, pure functions that only need a [Uuid]). This keeps the
/// demo data 100 % consistent with user-generated brackets.
class DemoBracketSnapshotFactory {
  DemoBracketSnapshotFactory._();

  static const _uuid = Uuid();

  // ── 100 unique demo participant names ──────────────────────────────────

  static const _fullNames = [
    // 1–20
    'Aarav Patel',
    'Diya Sharma',
    'Vihaan Singh',
    'Aanya Gupta',
    'Arjun Kumar',
    'Kiara Reddy',
    'Rohan Desai',
    'Isha Joshi',
    'Aditya Verma',
    'Meera Nair',
    'Kabir Das',
    'Ananya Rao',
    'Dhruv Iyer',
    'Neha Pillai',
    'Aryan Mehta',
    'Riya Kapoor',
    'Siddharth Thakur',
    'Priya Menon',
    'Tanish Bhatt',
    'Kavya Sethi',
    // 21–40
    'Ishaan Saxena',
    'Shruti Bose',
    'Harsh Choudhary',
    'Pooja Mishra',
    'Vivek Malhotra',
    'Simran Kaur',
    'Manav Tiwari',
    'Deepika Hegde',
    'Yash Pandey',
    'Ritika Narayan',
    'Karan Bhatia',
    'Sneha Kulkarni',
    'Nikhil Chatterjee',
    'Tanya Srinivasan',
    'Rahul Agarwal',
    'Meghna Deshpande',
    'Samar Bajaj',
    'Nikita Ranganathan',
    'Pranav Khanna',
    'Aditi Venkatesh',
    // 41–60
    'Kunal Banerjee',
    'Swati Raghavan',
    'Ajay Chauhan',
    'Pallavi Suresh',
    'Dev Rajput',
    'Nandini Gopalan',
    'Vikram Soni',
    'Lakshmi Ramesh',
    'Abhishek Dalal',
    'Gayatri Sundaram',
    'Tarun Jain',
    'Shweta Chandra',
    'Mayank Trivedi',
    'Divya Mahajan',
    'Rohit Khatri',
    'Kamini Shukla',
    'Gaurav Vohra',
    'Aparna Subramaniam',
    'Sachin Parikh',
    'Jyoti Mukherjee',
    // 61–80
    'Ankur Grover',
    'Varsha Krishnan',
    'Nitin Walia',
    'Sonal Pathak',
    'Hemant Kohli',
    'Renu Venkataraman',
    'Pankaj Reddy',
    'Anita Nambiar',
    'Saurabh Mittal',
    'Bhavna Kulkarni',
    'Raghav Sharma',
    'Sunita Raghunath',
    'Omkar Jha',
    'Kriti Kapadia',
    'Vishal Pandya',
    'Meenakshi Sundaram',
    'Tejas Barve',
    'Janhavi Deshpande',
    'Kartik Nanda',
    'Rashmi Iyer',
    // 81–100
    'Sahil Mathur',
    'Bhoomika Rao',
    'Naveen Chaturvedi',
    'Tanvi Kulkarni',
    'Girish Yadav',
    'Lavanya Suresh',
    'Anand Shetty',
    'Chandni Sethi',
    'Prakash Menon',
    'Hema Narayan',
    'Uday Thakkar',
    'Nisha Bhandari',
    'Rajat Oberoi',
    'Saanvi Gopinath',
    'Manish Dabas',
    'Poonam Kumar',
    'Suresh Nair',
    'Archana Pillai',
    'Deepak Malhotra',
    'Trupti Joshi',
  ];

  /// 16 unique dojangs for realistic affiliation variety.
  static const _schools = [
    'Kerala Martial Arts',
    'Mumbai Taekwondo',
    'Delhi Sports Club',
    'Bengaluru Dojang',
    'Chennai Dragons',
    'Punjab Tigers',
    'Hyderabad Warriors',
    'Kolkata Kicks',
    'Jaipur Dojang',
    'Lucknow Academy',
    'Pune Power TKD',
    'Ahmedabad Strikers',
    'Chandigarh Sparks',
    'Goa Combat Academy',
    'Bhopal Tiger TKD',
    'Mysuru Champions',
  ];

  // ── Public API ─────────────────────────────────────────────────────────

  /// Generates all showcase bracket snapshots for the demo tournament.
  ///
  /// Covers every format × size combination the system supports, including
  /// odd participant counts (which trigger BYE-handling), 3rd-place matches,
  /// and large 64/100-player brackets.
  static List<BracketSnapshot> generateAllDemoBracketSnapshots() {
    final singleEliminationGenerator =
        SingleEliminationBracketGeneratorServiceImplementation(_uuid);
    final doubleEliminationGenerator =
        DoubleEliminationBracketGeneratorServiceImplementation(_uuid);

    final baseTimestamp = DateTime(2026, 3, 10, 10, 0);
    var snapshotIndex = 0;

    DateTime nextTimestamp() =>
        baseTimestamp.add(Duration(minutes: 5 * snapshotIndex++));

    return [
      // ── Single Elimination ───────────────────────────────────────────

      // 1. SE — 3 Players (odd → 1 BYE, minimal bracket)
      _buildSingleEliminationSnapshot(
        generator: singleEliminationGenerator,
        participantCount: 3,
        includeThirdPlaceMatch: false,
        classification: const BracketClassification(
          ageCategoryLabel: 'CADET',
          genderLabel: 'BOYS',
          weightDivisionLabel: 'UNDER 33 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 2. SE — 4 Players + 3rd Place
      _buildSingleEliminationSnapshot(
        generator: singleEliminationGenerator,
        participantCount: 4,
        includeThirdPlaceMatch: true,
        classification: const BracketClassification(
          ageCategoryLabel: 'CADET',
          genderLabel: 'GIRLS',
          weightDivisionLabel: 'UNDER 41 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 3. SE — 7 Players (odd → multiple BYEs)
      _buildSingleEliminationSnapshot(
        generator: singleEliminationGenerator,
        participantCount: 7,
        includeThirdPlaceMatch: true,
        classification: const BracketClassification(
          ageCategoryLabel: 'CADET',
          genderLabel: 'BOYS',
          weightDivisionLabel: 'UNDER 45 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 4. SE — 8 Players
      _buildSingleEliminationSnapshot(
        generator: singleEliminationGenerator,
        participantCount: 8,
        includeThirdPlaceMatch: false,
        classification: const BracketClassification(
          ageCategoryLabel: 'JUNIOR',
          genderLabel: 'GIRLS',
          weightDivisionLabel: 'UNDER 55 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 5. SE — 12 Players (odd → BYEs in a larger bracket)
      _buildSingleEliminationSnapshot(
        generator: singleEliminationGenerator,
        participantCount: 12,
        includeThirdPlaceMatch: true,
        classification: const BracketClassification(
          ageCategoryLabel: 'JUNIOR',
          genderLabel: 'BOYS',
          weightDivisionLabel: 'UNDER 48 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 6. SE — 16 Players + 3rd Place
      _buildSingleEliminationSnapshot(
        generator: singleEliminationGenerator,
        participantCount: 16,
        includeThirdPlaceMatch: true,
        classification: const BracketClassification(
          ageCategoryLabel: 'SENIOR',
          genderLabel: 'MEN',
          weightDivisionLabel: 'UNDER 68 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 7. SE — 32 Players + 3rd Place
      _buildSingleEliminationSnapshot(
        generator: singleEliminationGenerator,
        participantCount: 32,
        includeThirdPlaceMatch: true,
        classification: const BracketClassification(
          ageCategoryLabel: 'SENIOR',
          genderLabel: 'WOMEN',
          weightDivisionLabel: 'UNDER 57 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 8. SE — 64 Players (full 64-draw, no 3rd place)
      _buildSingleEliminationSnapshot(
        generator: singleEliminationGenerator,
        participantCount: 64,
        includeThirdPlaceMatch: false,
        classification: const BracketClassification(
          ageCategoryLabel: 'SENIOR',
          genderLabel: 'MEN',
          weightDivisionLabel: 'UNDER 80 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 9. SE — 100 Players + 3rd Place (max showcase, heavy BYE handling)
      _buildSingleEliminationSnapshot(
        generator: singleEliminationGenerator,
        participantCount: 100,
        includeThirdPlaceMatch: true,
        classification: const BracketClassification(
          ageCategoryLabel: 'SENIOR',
          genderLabel: 'MEN',
          weightDivisionLabel: 'OVER 87 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // ── Double Elimination ───────────────────────────────────────────

      // 10. DE — 4 Players (minimal double elim)
      _buildDoubleEliminationSnapshot(
        generator: doubleEliminationGenerator,
        participantCount: 4,
        classification: const BracketClassification(
          ageCategoryLabel: 'CADET',
          genderLabel: 'GIRLS',
          weightDivisionLabel: 'UNDER 37 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 11. DE — 6 Players (odd → BYE handling in WB + LB)
      _buildDoubleEliminationSnapshot(
        generator: doubleEliminationGenerator,
        participantCount: 6,
        classification: const BracketClassification(
          ageCategoryLabel: 'JUNIOR',
          genderLabel: 'BOYS',
          weightDivisionLabel: 'UNDER 51 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 12. DE — 8 Players
      _buildDoubleEliminationSnapshot(
        generator: doubleEliminationGenerator,
        participantCount: 8,
        classification: const BracketClassification(
          ageCategoryLabel: 'JUNIOR',
          genderLabel: 'GIRLS',
          weightDivisionLabel: 'UNDER 59 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 13. DE — 16 Players
      _buildDoubleEliminationSnapshot(
        generator: doubleEliminationGenerator,
        participantCount: 16,
        classification: const BracketClassification(
          ageCategoryLabel: 'SENIOR',
          genderLabel: 'MEN',
          weightDivisionLabel: 'UNDER 74 KG',
        ),
        generatedAt: nextTimestamp(),
      ),

      // 14. DE — 32 Players (large double elim)
      _buildDoubleEliminationSnapshot(
        generator: doubleEliminationGenerator,
        participantCount: 32,
        classification: const BracketClassification(
          ageCategoryLabel: 'SENIOR',
          genderLabel: 'WOMEN',
          weightDivisionLabel: 'UNDER 67 KG',
        ),
        generatedAt: nextTimestamp(),
      ),
    ];
  }

  // ── Private builders ───────────────────────────────────────────────────

  static BracketSnapshot _buildSingleEliminationSnapshot({
    required SingleEliminationBracketGeneratorServiceImplementation generator,
    required int participantCount,
    required bool includeThirdPlaceMatch,
    required BracketClassification classification,
    required DateTime generatedAt,
  }) {
    final participants = _generateParticipants(participantCount);
    final participantIds = participants
        .map((participant) => participant.id)
        .toList();

    final generationResult = generator.generate(
      genderId: 'demo-gender-${_uuid.v4()}',
      participantIds: participantIds,
      bracketId: _uuid.v4(),
      includeThirdPlaceMatch: includeThirdPlaceMatch,
    );

    final snapshotId = _uuid.v4();
    final thirdPlaceSuffix = includeThirdPlaceMatch ? ' + 3rd Place' : '';
    final label = 'Single Elim — $participantCount Players$thirdPlaceSuffix';

    return BracketSnapshot(
      id: snapshotId,
      userId: 'demo-user-1',
      tournamentId: 'demo-tournament-1',
      label: label,
      format: BracketFormat.singleElimination,
      participantCount: participantCount,
      includeThirdPlaceMatch: includeThirdPlaceMatch,
      dojangSeparation: false,
      classification: classification,
      generatedAt: generatedAt,
      updatedAt: generatedAt,
      participants: participants,
      result: BracketResult.singleElimination(generationResult),
    );
  }

  static BracketSnapshot _buildDoubleEliminationSnapshot({
    required DoubleEliminationBracketGeneratorServiceImplementation generator,
    required int participantCount,
    required BracketClassification classification,
    required DateTime generatedAt,
  }) {
    final participants = _generateParticipants(participantCount);
    final participantIds = participants
        .map((participant) => participant.id)
        .toList();

    final generationResult = generator.generate(
      genderId: 'demo-gender-${_uuid.v4()}',
      participantIds: participantIds,
      winnersBracketId: _uuid.v4(),
      losersBracketId: _uuid.v4(),
    );

    return BracketSnapshot(
      id: 'double_elim_demo',
      userId: 'demo-user-1',
      tournamentId: 'demo-tournament-1',
      label: 'Double Elim - 8 Players',
      format: BracketFormat.doubleElimination,
      participantCount: participantCount,
      includeThirdPlaceMatch: false,
      dojangSeparation: false,
      classification: classification,
      generatedAt: generatedAt,
      updatedAt: generatedAt,
      participants: participants,
      result: BracketResult.doubleElimination(generationResult),
    );
  }

  /// Builds a deterministic list of [count] participants.
  ///
  /// Names and schools cycle through the pools if [count] exceeds their
  /// length, so any participant count up to 100+ is supported.
  static List<ParticipantEntity> _generateParticipants(int count) {
    return List.generate(count, (index) {
      return ParticipantEntity(
        id: 'demo-p-$count-${index + 1}',
        genderId: 'demo_division',
        fullName: _fullNames[index % _fullNames.length],
        schoolOrDojangName: _schools[index % _schools.length],
        registrationId: 'DEMO-${1000 + index}',
        seedNumber: index + 1,
      );
    });
  }
}
