import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// UniDioLogger is a wrapper around Dio's PrettyDioLogger
/// so you can keep a unified naming style with UniLogger & UniGraphqlLogger.
class UniDioLogger extends PrettyDioLogger {
  UniDioLogger({
    super.requestHeader = true,
    super.requestBody = true,
    super.responseHeader = false,
    super.responseBody = true,
    super.error = true,
    super.maxWidth = 90,
  }) : super(
         enabled: !kReleaseMode, // 👈 disables logging in release mode
       );
}
