import 'package:graphql_flutter/graphql_flutter.dart';

import 'GraphQLHandler.dart';

class GraphQLRequests{

  static Future<QueryResult> popularUsers(int start, int end) async{
    //FIRST CHECK IF LOCALLY there are prev messages
    //TODO
    return await GraphQLHandler.client2.mutate(MutationOptions(documentNode: gql(GraphQLHandler.mostPopular),variables: {'start':start,'end':end}));

    //PROCEED TO DOWNLOAD recent messages if not
  }
}