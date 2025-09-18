import 'package:example/uni_dio_logger_example.dart';
import 'package:example/uni_graphql_logger_example.dart';
import 'package:example/uni_http_logger_example.dart';
import 'package:example/uni_logger_example.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "UniLogger Types",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            // Uni Logger Example
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UniLoggerExample();
                    },
                  ),
                );
              },
              child: Text("Uni Logger Example"),
            ),

            // Uni Dio Logger Example
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UniDioLoggerExample();
                    },
                  ),
                );
              },
              child: Text("Uni Dio Logger Example"),
            ),

            // Uni Http Logger Example
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UniHttpLoggerExample();
                    },
                  ),
                );
              },
              child: Text("Uni Http Logger Example"),
            ),

            // Uni Graphql Logger Example
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return UniGraphqlLoggerExample();
                    },
                  ),
                );
              },
              child: Text("Uni Graphql Logger Example"),
            ),
          ],
        ),
      ),
    );
  }
}
