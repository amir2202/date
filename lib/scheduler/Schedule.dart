import 'dart:async';

import 'package:dating/GraphQLHandler.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../common.dart';
class Schedule{

  static void scheduleOnlinePing() {
    const oneSec = const Duration(seconds:30);
    new Timer.periodic(oneSec, (Timer t) {
      if(Common.userid != 0 && Common.userid != null){
        GraphQLHandler.client2.mutate(MutationOptions(documentNode: gql(GraphQLHandler.pingOnline),variables: {"userid":int.parse(Common.userid)})).then((value) => print(value.data));
      }
    });
  }
}