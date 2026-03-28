import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tkd_saas/features/tournament/domain/entities/bracket_snapshot.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/bracket_snapshot_repository.dart';
import 'package:tkd_saas/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tkd_saas/features/tournament/presentation/bloc/tournament_bloc.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_format.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_generation_result.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_entity.dart';

import 'package:fpdart/fpdart.dart';
import 'package:tkd_saas/core/error/failures.dart';
class MockTournamentRepository extends Mock implements TournamentRepository {}
class MockBracketSnapshotRepository extends Mock implements BracketSnapshotRepository {}
class FakeTournamentEntity extends Fake implements TournamentEntity {}
class FakeBracketSnapshot extends Fake implements BracketSnapshot {}

void main() {
  group('TournamentBloc', () {
    late MockTournamentRepository mockTournamentRepo;
    late MockBracketSnapshotRepository mockBracketRepo;
    late TournamentBloc bloc;

    final dummyTournament = TournamentEntity(
      id: 'tourney_1',
      userId: 'user_1',
      name: 'Test Tournament',
      dateRange: 'Jan 1 - Dec 31',
      venue: 'Test Venue',
      organizer: 'Test Organizer',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final dummyBracketSnapshot = BracketSnapshot(
      id: 'bracket_1',
      userId: 'user_1',
      tournamentId: 'tourney_1',
      label: 'Test Bracket',
      format: BracketFormat.singleElimination,
      participantCount: 4,
      includeThirdPlaceMatch: false,
      dojangSeparation: false,
      participants: const [],
      result: BracketResult.singleElimination(BracketGenerationResult(
        bracket: BracketEntity(
          id: 'b1', 
          genderId: '', 
          bracketType: BracketType.winners, 
          totalRounds: 2, 
          createdAtTimestamp: DateTime.now(), 
          updatedAtTimestamp: DateTime.now()
        ), 
        matches: [],
      )),
      generatedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setUpAll(() {
      registerFallbackValue(FakeTournamentEntity());
      registerFallbackValue(FakeBracketSnapshot());
    });

    setUp(() {
      mockTournamentRepo = MockTournamentRepository();
      mockBracketRepo = MockBracketSnapshotRepository();
      bloc = TournamentBloc(mockTournamentRepo, mockBracketRepo);
    });

    tearDown(() {
      bloc.close();
    });

    group('Load Requested', () {
      test('emits loaded tournaments maintaining DemoData on success', () async {
        when(() => mockTournamentRepo.getTournaments()).thenAnswer((_) async => Right([dummyTournament]));
        when(() => mockBracketRepo.getBracketSnapshots(dummyTournament.id)).thenAnswer((_) async => Right([dummyBracketSnapshot]));
        
        final expectedStates = <TournamentState>[];
        final subscription = bloc.stream.listen(expectedStates.add);

        bloc.add(const TournamentLoadRequested());

        // Give event loop time to process async repository call
        await Future.delayed(Duration.zero);
        await subscription.cancel();

        expect(expectedStates, isNotEmpty);
        expect(expectedStates.first.isLoading, isTrue); // initial emission
        expect(expectedStates.last.isLoading, isFalse);
        expect(expectedStates.last.tournaments.length, 2); // demo + remote
        expect(expectedStates.last.bracketsByTournamentId.containsKey(dummyTournament.id), true);
        
        verify(() => mockTournamentRepo.getTournaments()).called(1);
      });

      test('emits errorMessage when load encounters an exception', () async {
        when(() => mockTournamentRepo.getTournaments())
            .thenAnswer((_) async => const Left(NetworkFailure('Failed to load tournaments.')));
            
        final expectedStates = <TournamentState>[];
        final subscription = bloc.stream.listen(expectedStates.add);

        bloc.add(const TournamentLoadRequested());

        await Future.delayed(Duration.zero);
        await subscription.cancel();

        expect(expectedStates, isNotEmpty);
        expect(expectedStates.last.isLoading, isFalse);
        expect(expectedStates.last.errorMessage, 'Failed to load tournaments.');

        verify(() => mockTournamentRepo.getTournaments()).called(1);
      });
    });

    group('Load More Requested', () {
      test('emits new tournaments and sets hasReachedMax if less than limit', () async {
        when(() => mockTournamentRepo.getTournaments(limit: 20, offset: any(named: 'offset')))
            .thenAnswer((_) async => Right([dummyTournament]));
        when(() => mockBracketRepo.getBracketSnapshots(dummyTournament.id)).thenAnswer((_) async => const Right([]));

        final expectedStates = <TournamentState>[];
        final subscription = bloc.stream.listen(expectedStates.add);

        bloc.add(const TournamentLoadMoreRequested());

        await Future.delayed(Duration.zero);
        await subscription.cancel();

        expect(expectedStates, isNotEmpty);
        expect(expectedStates.last.isFetchingMore, isFalse);
        expect(expectedStates.last.hasReachedMax, isTrue);
        expect(expectedStates.last.tournaments.length, 2);
      });
    });

    group('Mutations', () {
      test('TournamentCreated adds tournament to top of list', () async {
        when(() => mockTournamentRepo.createTournament(any()))
            .thenAnswer((_) async => Right(dummyTournament));

        final expectedStates = <TournamentState>[];
        final subscription = bloc.stream.listen(expectedStates.add);

        bloc.add(TournamentCreated(dummyTournament));

        await Future.delayed(Duration.zero);
        await subscription.cancel();

        expect(expectedStates.last.isSaving, isFalse);
        expect(expectedStates.last.tournaments.first, dummyTournament);
      });

      test('TournamentUpdated updates the specific tournament', () async {
        final updatedTournament = dummyTournament.copyWith(name: 'Updated Name');
        
        // Let's set the initial state to have the tournament
         when(() => mockTournamentRepo.getTournaments()).thenAnswer((_) async => Right([dummyTournament]));
         when(() => mockBracketRepo.getBracketSnapshots(dummyTournament.id)).thenAnswer((_) async => const Right([]));
         bloc.add(const TournamentLoadRequested());
         await Future.delayed(Duration.zero);

        when(() => mockTournamentRepo.updateTournament(any()))
            .thenAnswer((_) async => Right(updatedTournament));

        final expectedStates = <TournamentState>[];
        final subscription = bloc.stream.listen(expectedStates.add);

        bloc.add(TournamentUpdated(updatedTournament));

         await Future.delayed(Duration.zero);
         await subscription.cancel();

         expect(expectedStates.last.isSaving, isFalse);
         expect(expectedStates.last.tournaments.firstWhere((t) => t.id == 'tourney_1').name, 'Updated Name');
      });

      test('TournamentDeleted removes the tournament', () async {
        when(() => mockTournamentRepo.getTournaments()).thenAnswer((_) async => Right([dummyTournament]));
        when(() => mockBracketRepo.getBracketSnapshots(dummyTournament.id)).thenAnswer((_) async => Right([dummyBracketSnapshot]));
        bloc.add(const TournamentLoadRequested());
        await Future.delayed(Duration.zero);

        when(() => mockTournamentRepo.deleteTournament(any()))
            .thenAnswer((_) async => const Right(null));

        final expectedStates = <TournamentState>[];
        final subscription = bloc.stream.listen(expectedStates.add);

        bloc.add(TournamentDeleted(dummyTournament.id));

        await Future.delayed(Duration.zero);
        await subscription.cancel();

        expect(expectedStates.last.isSaving, isFalse);
        expect(expectedStates.last.tournaments.where((t) => t.id == dummyTournament.id), isEmpty);
        expect(expectedStates.last.bracketsByTournamentId.containsKey(dummyTournament.id), isFalse);
      });

      test('TournamentBracketSnapshotAdded adds snapshot to map', () async {
        when(() => mockBracketRepo.createBracketSnapshot(any(), any()))
            .thenAnswer((_) async => Right(dummyBracketSnapshot));

        bloc.add(TournamentBracketSnapshotAdded(snapshot: dummyBracketSnapshot, tournamentId: dummyTournament.id));
        await Future.delayed(Duration.zero);

        expect(bloc.state.bracketsByTournamentId[dummyTournament.id]?.first, dummyBracketSnapshot);
      });

      test('TournamentBracketSnapshotRemoved removes snapshot from map', () async {
        when(() => mockBracketRepo.createBracketSnapshot(any(), any()))
            .thenAnswer((_) async => Right(dummyBracketSnapshot));
        bloc.add(TournamentBracketSnapshotAdded(snapshot: dummyBracketSnapshot, tournamentId: dummyTournament.id));
        await Future.delayed(Duration.zero);
        
        when(() => mockBracketRepo.deleteBracketSnapshot(any()))
            .thenAnswer((_) async => const Right(null));

        bloc.add(TournamentBracketSnapshotRemoved(snapshotId: dummyBracketSnapshot.id, tournamentId: dummyTournament.id));
        await Future.delayed(Duration.zero);

        expect(bloc.state.bracketsByTournamentId[dummyTournament.id]?.where((s) => s.id == dummyBracketSnapshot.id), isEmpty);
      });
      
      test('TournamentBracketSnapshotUpdated updates snapshot in map', () async {
        when(() => mockBracketRepo.createBracketSnapshot(any(), any()))
            .thenAnswer((_) async => Right(dummyBracketSnapshot));
        bloc.add(TournamentBracketSnapshotAdded(snapshot: dummyBracketSnapshot, tournamentId: dummyTournament.id));
        await Future.delayed(Duration.zero);

        final updatedSnapshot = dummyBracketSnapshot.copyWith(label: 'Updated Label');

        when(() => mockBracketRepo.updateBracketSnapshot(any()))
            .thenAnswer((_) async => Right(updatedSnapshot));

        bloc.add(TournamentBracketSnapshotUpdated(updatedSnapshot));
        await Future.delayed(Duration.zero);

        expect(bloc.state.bracketsByTournamentId[dummyTournament.id]?.firstWhere((s) => s.id == dummyBracketSnapshot.id).label, 'Updated Label');
      });
    });
  });
}
