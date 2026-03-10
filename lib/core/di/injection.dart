import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

/// The global service locator instance.
final GetIt getIt = GetIt.instance;

/// Call once in [main] before [runApp].
/// Wires all dependencies via [injectable]-generated code.
@InjectableInit()
void configureDependencies() => getIt.init();
