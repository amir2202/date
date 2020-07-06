import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
class GraphQLHandler {

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(uri:'http://192.168.0.14:8091/graphql'),
    ),
  );

  static ValueNotifier<GraphQLClient> getClient(){
    return client;
  }



  /*
  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    // OR
    // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  );

  final Link link = authLink.concat(httpLink); */

}
