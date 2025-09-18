import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:unilogger/unilogger.dart';

class UniGraphqlLoggerExample extends StatefulWidget {
  const UniGraphqlLoggerExample({super.key});

  @override
  State<UniGraphqlLoggerExample> createState() =>
      _UniGraphqlLoggerExampleState();
}

class _UniGraphqlLoggerExampleState extends State<UniGraphqlLoggerExample> {
  List<String> usernames = [];
  bool isLoading = true;

  late final GraphQLClient client;

  @override
  void initState() {
    super.initState();

    final HttpLink httpLink = HttpLink('https://graphqlzero.almansi.me/api');

    // Wrap with UniGraphqlLogger
    final link = UniGraphqlLogger(
      logRequestBody: true,
      logResponseBody: true,
      logHeaders: true,
    ).concat(httpLink);

    client = GraphQLClient(cache: GraphQLCache(), link: link);

    fetchUsers();
  }

  Future<void> fetchUsers() async {
    const String query = r'''
      query Albums {
        users {
          data {
            username
          }
        }
      }
    ''';

    try {
      UniLogger.log("Fetching users from GraphQL...");

      final result = await client.query(QueryOptions(document: gql(query)));

      if (result.hasException) {
        UniLogger.error("GraphQL Error", result.exception);
      } else {
        UniLogger.success("Fetched users successfully!");
        final data = result.data?['users']['data'] as List<dynamic>;
        setState(() {
          usernames = data.map((e) => e['username'] as String).toList();
        });
      }
    } catch (e, st) {
      UniLogger.error("Failed to fetch users", e, st);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UniGraphqlLogger Example')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: usernames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(usernames[index]),
                );
              },
            ),
    );
  }
}
