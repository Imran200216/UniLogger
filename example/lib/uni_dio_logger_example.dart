import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:unilogger/unilogger.dart';

class UniDioLoggerExample extends StatefulWidget {
  const UniDioLoggerExample({super.key});

  @override
  State<UniDioLoggerExample> createState() => _UniDioLoggerExampleState();
}

class _UniDioLoggerExampleState extends State<UniDioLoggerExample> {
  final Dio _dio = Dio();

  List products = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Add UniDioLogger interceptor
    _dio.interceptors.add(
      UniDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        maxWidth: 80,
      ),
    );

    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      UniLogger.log("Fetching products from DummyJSON...");

      final response = await _dio.get('https://dummyjson.com/products');

      UniLogger.success("Fetched products successfully!");
      UniLogger.log("Response data: ${response.data}");

      setState(() {
        products = response.data['products'];
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UniDioLogger Example')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  leading: Image.network(
                    product['thumbnail'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['title']),
                  subtitle: Text(product['description']),
                  trailing: Text("\$${product['price']}"),
                );
              },
            ),
    );
  }
}
