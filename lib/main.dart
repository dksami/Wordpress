import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:wordpress/pages/root_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    final HttpLink httpLink = HttpLink(
      uri: 'https://eproject.tk/graphql',
    );

    ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        cache: InMemoryCache(),
        link: httpLink as Link,
      ),
    );
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: new MaterialApp(
          title: 'Display Tracker',
          debugShowCheckedModeBanner: false,
          theme: new ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: new RootPage(),
        ),
      ),
    );
  }
}
