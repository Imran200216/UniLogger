import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unilogger/unilogger.dart';

class UniHttpLoggerExample extends StatefulWidget {
  const UniHttpLoggerExample({super.key});

  @override
  State<UniHttpLoggerExample> createState() => _UniHttpLoggerExampleState();
}

class _UniHttpLoggerExampleState extends State<UniHttpLoggerExample> {
  List products = [];
  bool isLoading = false;

  late final http.Client client;

  @override
  void initState() {
    super.initState();
    // Wrap default client with UniHttpLogger
    client = UniHttpLogger(
      logHeaders: true,
      logRequestBody: true,
      logResponseBody: true,
    );
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      UniLogger.log("Fetching products from DummyJSON...");

      // Perform GET request
      final streamedResponse = await client.get(
        Uri.parse('https://dummyjson.com/products'),
      );

      // UniHttpLogger already logs the request/response in console

      // If you want to parse the response
      final responseBody = streamedResponse.body; // <-- now body is available
      UniLogger.success("Fetched products successfully!");
      UniLogger.log("Response body: $responseBody");

      // Decode JSON
      final decoded = jsonDecode(responseBody);
      setState(() {
        products = decoded['products'];
      });
    } catch (e, st) {
      UniLogger.error("Failed to fetch products", e, st);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UniHttpLogger Example')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product['title'] ?? ''),
                  subtitle: Text(product['description'] ?? ''),
                  trailing: Text("\$${product['price'] ?? ''}"),
                );
              },
            ),
    );
  }
}
