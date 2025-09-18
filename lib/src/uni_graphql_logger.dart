import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'log_colors.dart';

class UniGraphqlLogger extends Link {
  final bool logRequestBody;
  final bool logResponseBody;
  final bool logHeaders;

  /// Disable logs automatically in release mode
  final bool enabled;

  UniGraphqlLogger({
    this.logRequestBody = true,
    this.logResponseBody = true,
    this.logHeaders = false,
    bool? enabled,
  }) : enabled = enabled ?? !kReleaseMode;

  @override
  Stream<Response> request(Request request, [NextLink? forward]) {
    if (!enabled) return forward!(request); // 🚀 Skip logging in release mode

    final stopwatch = Stopwatch()..start();

    _printRequest(request);

    final Stream<Response> responseStream = forward!(request);

    return responseStream.map((response) {
      stopwatch.stop();
      _printResponse(request, response, stopwatch.elapsedMilliseconds);
      return response;
    });
  }

  void _printRequest(Request request) {
    if (!enabled) return;

    final buffer = StringBuffer();

    buffer.writeln(
      "${LogColors.cyan}${LogColors.bold}🔼 ─────── [GraphQL Request] ───────${LogColors.reset}",
    );
    buffer.writeln(
      "${LogColors.blue}Operation:${LogColors.reset} ${request.operation.operationName}",
    );

    if (logHeaders) {
      final headers = request.context.entry<HttpLinkHeaders>()?.headers ?? {};
      buffer.writeln(
        "${LogColors.magenta}Headers:${LogColors.reset} ${jsonEncode(headers)}",
      );
    }

    if (logRequestBody) {
      buffer.writeln(
        "${LogColors.yellow}Query:${LogColors.reset}\n${request.operation.document}",
      );
      if (request.variables.isNotEmpty) {
        buffer.writeln(
          "${LogColors.white}Variables:${LogColors.reset}\n${_prettyJson(request.variables)}",
        );
      }
    }

    buffer.writeln(
      "${LogColors.cyan}${LogColors.bold}─────────────────────────────────────${LogColors.reset}",
    );

    print(buffer.toString());
  }

  void _printResponse(Request request, Response response, int elapsedMs) {
    if (!enabled) return;

    final buffer = StringBuffer();

    buffer.writeln(
      "${LogColors.green}${LogColors.bold}🔽 ─────── [GraphQL Response] ───────${LogColors.reset}",
    );
    buffer.writeln(
      "${LogColors.blue}Operation:${LogColors.reset} ${request.operation.operationName}",
    );
    buffer.writeln(
      "${LogColors.magenta}Elapsed:${LogColors.reset} ${elapsedMs}ms",
    );

    if (logResponseBody) {
      if (response.errors?.isNotEmpty == true) {
        buffer.writeln(
          "${LogColors.red}❌ Errors:${LogColors.reset}\n${_prettyJson(response.errors!)}",
        );
      }
      if (response.data != null) {
        buffer.writeln(
          "${LogColors.green}✅ Data:${LogColors.reset}\n${_prettyJson(response.data!)}",
        );
      }
    }

    buffer.writeln(
      "${LogColors.green}${LogColors.bold}─────────────────────────────────────${LogColors.reset}",
    );

    print(buffer.toString());
  }

  String _prettyJson(Object jsonObject) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonObject);
    } catch (_) {
      return jsonObject.toString();
    }
  }
}
