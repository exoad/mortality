import 'dart:async';

import 'package:logging/logging.dart';
import 'package:mortality_app/shared.dart';

class Debug {
  Debug._();
  static final Debug _singleton = Debug._();

  factory Debug() {
    return _singleton;
  }

  late final Logger _logger;

  void init() {
    _logger = Logger(kLoggerName);
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((LogRecord rec) => print(
        '[${rec.level.name.substring(0, 4)}] ${rec.time} ${rec.loggerName} >   ${rec.message}'));
  }

  void warn(dynamic msg) => _logger.warning(msg);

  void info(dynamic msg) => _logger.info(msg);

  void error(dynamic msg) => _logger.severe(msg);

  StreamSubscription<LogRecord> listen(
          void Function(LogRecord record) listener) =>
      _logger.onRecord.asBroadcastStream().listen(listener);
}
