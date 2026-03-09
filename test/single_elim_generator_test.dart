import 'package:flutter_test/flutter_test.dart';
import 'package:tkd_saas/features/bracket/data/services/single_elimination_bracket_generator_service_implementation.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('1 player single elim', () {
    final gen = SingleEliminationBracketGeneratorServiceImplementation(Uuid());
    final r = gen.generate(
      divisionId: 'div1',
      participantIds: ['p1'],
      bracketId: 'wb',
    );
    print(r.matches.length);
  });
}
