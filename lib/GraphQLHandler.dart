import 'package:flutter/cupertino.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
class GraphQLHandler {

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(uri:'http://192.168.56.1:8090/graphql'),
    ),
  );

  static ValueNotifier<GraphQLClient> getClient(){
    return client;
  }
   static const String registerUser = r"""mutation AddUserManual($name: String!,$password: String!, $premium:Boolean!,$email:String!,$gender: Boolean!, $birthday:String!, $country: String!,$haircolor:String,$eyecolor:String,$body:String,$height:Int, $ethnicity:String,$religion:String,$state:String!,$facebook:String) {
      addUser(name:$name,gender:$gender,password:$password,premium:$premium,email:$email,birthday:$birthday,country:$country,haircolor:$haircolor,eyecolor:$eyecolor,body:$body,height:$height,ethnicity:$ethnicity,religion:$religion,state:$state,facebook:$facebook){
      userid
      }
}
""";

  static const String addFacebookUser = r"""mutation createFacebook($name:String!,$premium:Boolean!,$gender:Boolean!,$fbid:String!,$profile:String!){
    addFacebook(name:$name,premium:$premium,gender:$gender,fbid:$fbid,profile:$profile){
     userid
     info{
     name 
     }
    }
    }
  """;

  static const String getProfile = r"""mutation getProfileUID($userid:String!){
   getProfileUID(userid:$userid){
   info{
   name
   }
   profilepic
   pictures
   }
  }""";

  static const String loginUser = r"""mutation LoginM($email:String!, $password:String!){
  loginManual(email:$email,password:$password){
    userid
    info{
    name
    stats{
    totalviews
    totallikes
    }
    }
    profilepic
    pictures{
    filepath
    }
  }
  }
  """;

  static const String facebookLinked = r"""mutation FacebookLinked($fbid:String!){
   FacebookLinked(fbid:$fbid){
   userid
   info{
   name
   stats{
   totalviews
   totallikes
   }
   }
   profilepic
   pictures{
   filepath
   }
   }
  }""";

  /*
  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    // OR
    // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  );

  final Link link = authLink.concat(httpLink); */

}
