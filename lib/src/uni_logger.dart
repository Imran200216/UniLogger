import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class UniLogger {
  static final Logger _logger = Logger(
    level: kReleaseMode ? Level.off : Level.debug,
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static void log(String message) => _logger.i(message);

  static void success(String message) => _logger.i(message);

  static void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  static void warn(String message) => _logger.w(message);

  static void debug(String message) => _logger.d(message);
}
