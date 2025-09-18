import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'log_colors.dart';

class UniHttpLogger extends http.BaseClient {
  final http.Client _inner;

  final bool logRequestBody;
  final bool logResponseBody;
  final bool logHeaders;

  /// Disable logs automatically in release mode
  final bool enabled;

  UniHttpLogger({
    http.Client? inner,
    this.logRequestBody = true,
    this.logResponseBody = true,
    this.logHeaders = false,
    bool? enabled,
  }) : _inner = inner ?? http.Client(),
       enabled = enabled ?? !kReleaseMode;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!enabled) {
      return _inner.send(request); // 🚀 Skip logging in release mode
    }

    final stopwatch = Stopwatch()..start();

    _printRequest(request);

    if (request is http.Request && logRequestBody && request.body.isNotEmpty) {
      print("${LogColors.yellow}Body:${LogColors.reset} ${request.body}");
    }

    final response = await _inner.send(request);
    stopwatch.stop();

    final resp = await http.Response.fromStream(response);
    _printResponse(request, resp, stopwatch.elapsedMilliseconds);

    // Return a new StreamedResponse so caller can still consume
    return http.StreamedResponse(
      Stream.value(resp.bodyBytes),
      resp.statusCode,
      request: request,
      headers: resp.headers,
      reasonPhrase: resp.reasonPhrase,
    );
  }

  void _printRequest(http.BaseRequest request) {
    final buffer = StringBuffer();
    buffer.writeln(
      "${LogColors.cyan}${LogColors.bold}🔼 ─────── [HTTP Request] ───────${LogColors.reset}",
    );
    buffer.writeln(
      "${LogColors.blue}Method:${LogColors.reset} ${request.method}",
    );
    buffer.writeln("${LogColors.blue}URL:${LogColors.reset} ${request.url}");
    if (logHeaders) {
      buffer.writeln(
        "${LogColors.magenta}Headers:${LogColors.reset} ${jsonEncode(request.headers)}",
      );
    }
    buffer.writeln(
      "${LogColors.cyan}${LogColors.bold}────────────────────────────────${LogColors.reset}",
    );
    print(buffer.toString());
  }

  void _printResponse(
    http.BaseRequest request,
    http.Response response,
    int elapsedMs,
  ) {
    final buffer = StringBuffer();
    buffer.writeln(
      "${LogColors.green}${LogColors.bold}🔽 ─────── [HTTP Response] ───────${LogColors.reset}",
    );
    buffer.writeln("${LogColors.blue}URL:${LogColors.reset} ${request.url}");
    buffer.writeln(
      "${LogColors.blue}Status:${LogColors.reset} ${response.statusCode}",
    );
    buffer.writeln(
      "${LogColors.magenta}Elapsed:${LogColors.reset} ${elapsedMs}ms",
    );

    if (logResponseBody) {
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains("application/json")) {
        buffer.writeln(
          "${LogColors.green}✅ Body:${LogColors.reset}\n${_prettyJson(response.body)}",
        );
      } else {
        buffer.writeln(
          "${LogColors.green}✅ Body:${LogColors.reset} ${response.body}",
        );
      }
    }

    buffer.writeln(
      "${LogColors.green}${LogColors.bold}──────────────────────────────${LogColors.reset}",
    );
    print(buffer.toString());
  }

  String _prettyJson(String source) {
    try {
      final jsonObject = json.decode(source);
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(jsonObject);
    } catch (_) {
      return source;
    }
  }
}
