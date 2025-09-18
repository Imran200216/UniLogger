import 'package:flutter/material.dart';
import 'package:unilogger/unilogger.dart';

class UniLoggerExample extends StatelessWidget {
  const UniLoggerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Uni Logger Success
            TextButton(
              onPressed: () {
                UniLogger.success('Hello Success Uni logger');
              },
              child: const Text('Hello Success Uni logger'),
            ),

            // Uni Logger Failure
            TextButton(
              onPressed: () {
                UniLogger.error('Hello Failure Uni logger');
              },
              child: const Text('Hello Failure Uni logger'),
            ),

            // Uni Logger Warning
            TextButton(
              onPressed: () {
                UniLogger.warn('Hello Warning Uni logger');
              },
              child: const Text('Hello Warning Uni logger'),
            ),
          ],
        ),
      ),
    );
  }
}
