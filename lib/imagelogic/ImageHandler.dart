import 'dart:convert';
import 'dart:io';

import 'package:dating/GraphQLHandler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
class ImageHandler {

  static Future<QueryResult> uploadImage(File file, String userid,
      bool profile) async {
    String r;
    String date = new DateTime.now().toString();
    print(new DateTime.now().toString());
    final bytes = await file.readAsBytes();
    String img64 = base64Encode(bytes);
    const String mutation = r"""mutation ImgM($img:String!, $userid:String!,$pfp:Boolean!){
  upload(img:$img,userid:$userid,pfp:$pfp)
  }
  """;
    GraphQLClient client = GraphQLClient(cache: InMemoryCache(),
        link: HttpLink(uri: 'http://192.168.56.1:8090/graphql'));
    return client.mutate(MutationOptions(documentNode: gql(mutation),
        variables: {'img': img64, 'userid': userid, 'pfp': profile}));
  }

  static Future<QueryResult> openGallery(String userid,bool profile) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return uploadImage(image,userid,profile);
  }
}