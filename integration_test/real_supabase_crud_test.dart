import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tkd_saas/core/config/app_config.dart';
import 'package:tkd_saas/core/di/injection.dart';
import 'package:tkd_saas/features/auth/domain/repositories/authentication_repository.dart';

import 'package:tkd_saas/features/core/data/demo_bracket_snapshot_factory.dart';

import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/bracket_snapshot_repository.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:uuid/uuid.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const realUserEmail = 'asak91298@gmail.com';
  const realUserPassword = '123456';
  const expectedUserId = '5e196368-ae8a-4226-ad16-3c67290161ba';

  group('Real Supabase CRUD - Data Validation', () {
    late AuthenticationRepository authRepo;
    late TournamentRepository tournamentRepo;
    late BracketSnapshotRepository bracketRepo;

    // Test artifacts
    TournamentEntity? createdTournament;

    setUpAll(() async {
      if (AppConfig.isAuthenticationEnabled) {
         await Supabase.initialize(
          url: 'https://lldlunqzkltclpfzpjxh.supabase.co',
          anonKey: 'sb_publishable_Kf90GkwrSzNySWSCqhJT8Q_9b94d-UM',
        );
      }
      configureDependencies();

      authRepo = getIt<AuthenticationRepository>();
      tournamentRepo = getIt<TournamentRepository>();
      bracketRepo = getIt<BracketSnapshotRepository>();

      // Authenticate as the real user!
      await authRepo.signInWithEmailAndPassword(
        email: realUserEmail,
        password: realUserPassword,
      );

      final session = Supabase.instance.client.auth.currentSession;
      assert(session != null, 'Auth session failed to establish.');
      assert(
        session!.user.id == expectedUserId,
        'Auth mis-match. ID is ${session.user.id}',
      );
    });

    tearDownAll(() async {
      await authRepo.signOut();
    });

    test('1. Execute CRUD pipeline purely via remote DB logic', () async {
      final String timestampTag = DateTime.now().toIso8601String();
      
      // Step A: Create Tournament
      TournamentEntity newTournament = TournamentEntity(
        id: const Uuid().v4(), 
        userId: expectedUserId,
        name: 'Integration Test Tournament $timestampTag',
        dateRange: 'Jan 1 - Dec 31',
        venue: 'Automated Simulator',
        organizer: 'Real User Bot',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdTournamentResult = await tournamentRepo.createTournament(newTournament);
      createdTournament = createdTournamentResult.getOrElse((failure) {
        fail('Failed to create tournament: ${failure.message}');
      });
      
      expect(createdTournament, isNotNull);
      expect(createdTournament!.id.isNotEmpty, true, reason: 'Must return a generated ID');

      // Step B: Fetch Tournaments
      final fetchedListResult = await tournamentRepo.getTournaments();
      final fetchedList = fetchedListResult.getOrElse((failure) => fail('Failed to fetch tournaments: ${failure.message}'));
      
      expect(
        fetchedList.any((t) => t.id == createdTournament!.id),
        true,
        reason: 'The newly created tournament must appear in the fetch list.',
      );

      // Step C: Create Brackets (Diverse Demo Data Gallery)
      final demoSnapshots = DemoBracketSnapshotFactory.generateAllDemoBracketSnapshots();
      late BracketSnapshot firstCreatedBracket;

      for (var i = 0; i < demoSnapshots.length; i++) {
        // Hydrate demo snapshot with actual integration test relationships and valid local UUIDs
        final snap = demoSnapshots[i].copyWith(
          id: const Uuid().v4(), 
          tournamentId: createdTournament!.id,
          userId: expectedUserId,
        );

        final createdBracketResult = await bracketRepo.createBracketSnapshot(
          snap, 
          createdTournament!.id,
        );
        final createdBracket = createdBracketResult.getOrElse((failure) => fail('Failed to create bracket: ${failure.message}'));
        
        expect(createdBracket.id.isNotEmpty, true, reason: 'Must return a generated ID for bracket $i');
        
        if (i == 0) {
          firstCreatedBracket = createdBracket;
        }
      }

      // Step D: Update Bracket (using the first one generated)
      final updatedBracket = firstCreatedBracket.copyWith(
        label: 'Updated Label',
      );
      
      // Simulate Finalization inside the snapshot
      final finalizedDataResult = updatedBracket.result.map(
        singleElimination: (s) => BracketResult.singleElimination(s.data.copyWith(
          bracket: s.data.bracket.copyWith(
            isFinalized: true,
            finalMedalPlacements: [],
          ),
        )),
        doubleElimination: (d) => BracketResult.doubleElimination(d.data.copyWith(
          winnersBracket: d.data.winnersBracket.copyWith(
            isFinalized: true,
            finalMedalPlacements: [],
          ),
        )),
      );

      final fullyUpdatedBracket = updatedBracket.copyWith(result: finalizedDataResult);

      final savedUpdatedBracketResult = await bracketRepo.updateBracketSnapshot(
        fullyUpdatedBracket, 
      );
      final savedUpdatedBracket = savedUpdatedBracketResult.getOrElse((failure) => fail('Failed to update bracket: ${failure.message}'));
      
      expect(savedUpdatedBracket.label, 'Updated Label');
      
      final dbBracketEntity = savedUpdatedBracket.result.map(
        singleElimination: (s) => s.data.bracket,
        doubleElimination: (d) => d.data.winnersBracket,
      );
      expect(dbBracketEntity.isFinalized, true);

      // Step E: Fetch Bracket
      final snapshotsResult = await bracketRepo.getBracketSnapshots(createdTournament!.id);
      final snapshots = snapshotsResult.getOrElse((failure) => fail('Failed to fetch bracket snapshots: ${failure.message}'));
      
      expect(snapshots.length, greaterThanOrEqualTo(1));
      expect(snapshots.any((b) => b.id == savedUpdatedBracket.id), true);

      // Cleanup happens via tearDownAll or manual trigger if implemented.
    });
  });
}
