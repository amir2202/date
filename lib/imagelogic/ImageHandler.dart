import 'dart:convert';
import 'dart:io';

import 'package:dating/GraphQLHandler.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
class ImageHandler{

  static Future<String> uploadImage(File file, String userid,bool profile) async {
    String r;
    final bytes = await file.readAsBytes();
    String img64 = base64Encode(bytes);
    const String mutation = r"""mutation ImgM($img:String!, $userid:String!,$pfp:Boolean!){
  upload(img:$img,userid:$userid,pfp:$pfp)
  }
  """;
    GraphQLClient client = GraphQLClient(cache: InMemoryCache(), link: HttpLink(uri:'http://192.168.0.14:8090/graphql'));
    client.mutate(MutationOptions(documentNode:gql(mutation),variables: {'img':img64,'userid':userid,'pfp':profile},onCompleted: (dynamic result){
      r = result['upload'];
    }));
    
  }
  
}