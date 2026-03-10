import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

/// Provides third-party / external types that cannot be annotated directly.
@module
abstract class AppModule {
  /// Provides a shared [Uuid] instance as a lazy singleton.
  @lazySingleton
  Uuid get uuid => const Uuid();
}
