import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

/// Configura el sistema de logging global.
/// Llamar una sola vez desde [main].
void setupLogging() {
  Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;

  Logger.root.onRecord.listen((record) {
    final emoji = _emoji(record.level);
    final msg =
        '$emoji [${record.level.name}] ${record.loggerName}: ${record.message}';

    // En debug usamos debugPrint para evitar truncamiento en consola
    debugPrint(msg);

    if (record.error != null) {
      debugPrint('   ↳ error: ${record.error}');
    }
    if (record.stackTrace != null) {
      debugPrint('   ↳ stackTrace:\n${record.stackTrace}');
    }
  });
}

/// Crea un [Logger] con nombre para una clase o módulo concreto.
///
/// Uso:
/// ```dart
/// final _log = getLogger('GameBloc');
/// _log.info('sesión iniciada');
/// _log.severe('error inesperado', e, st);
/// ```
Logger getLogger(String name) => Logger(name);

String _emoji(Level level) {
  if (level >= Level.SEVERE) return '🔴';
  if (level >= Level.WARNING) return '🟡';
  if (level >= Level.INFO) return '🟢';
  if (level >= Level.CONFIG) return '⚙️ ';
  return '🔵'; // FINE / FINER / FINEST
}
