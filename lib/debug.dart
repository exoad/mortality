import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mortality_app/shared.dart';
import 'package:mortality_app/util/extern/extern_color.dart';

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

class DebugChildWidget extends StatelessWidget {
  final Widget child;

  const DebugChildWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: ColorUtils.randomColor(), width: 4),
            borderRadius: BorderRadius.circular(0)),
        child: child);
  }
}
