import 'dart:convert';
import 'dart:io';

import 'package:dating/GraphQLHandler.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
class ImageHandler{

  static Future<bool> uploadImage(File file, String userid) async {
    bool upload = false;
    final bytes = await file.readAsBytes();
    String img64 = base64Encode(bytes);
    GraphQLClient client = GraphQLClient(cache: InMemoryCache(), link: HttpLink(uri:'http://192.168.0.14:8090/graphql'));
    client.mutate(MutationOptions(documentNode:gql(GraphQLHandler.uploadImage),variables:{'id':userid,'img':img64}));
    print("Doing stuff");
    return upload;
  }


}