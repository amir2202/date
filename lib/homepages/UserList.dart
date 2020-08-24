import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../GraphQLHandler.dart';

class UserList extends StatefulWidget {
  @override
  UserListState createState() => UserListState();
}

class UserListState extends State<UserList>{

  Future<QueryResult> result;
  bool complete = false;
  dynamic entries;
  @override
  void initState(){
    result = getPopular();
    result.then((value) {
      entries = value.data;
    });
  }

  GraphQLClient client = GraphQLHandler.client2;
  Future<QueryResult> getPopular() async {
    return await client.mutate(MutationOptions(documentNode: gql(GraphQLHandler.mostPopular),variables: {'start':0,'end':0}));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: result,builder: (context,snapshot){
      if(!complete){
          return CircularProgressIndicator();
      }
      else {

      }
    });
  }

}