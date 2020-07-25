import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';
import 'common.dart';

class GraphQLHandler {

  static GraphQLClient client2 = GraphQLClient(
    link: HttpLink(uri:'http://54.37.205.205:8090/graphql'),
    cache: InMemoryCache()
  );

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: InMemoryCache(),
      link: HttpLink(uri:'http://54.37.205.205:8090/graphql'),
    ),
  );

  static ValueNotifier<GraphQLClient> getClient(){
    return client;
  }

  static const String registerUser = r"""
    mutation AddUserManual($name: String!, $password: String!, $premium: Boolean!, $email: String!, $gender: Boolean!, $birthday: String!, $country: String!, $haircolor: String, $eyecolor: String, $body: String, $height: Int, $ethnicity: String, $religion: String, $state: String!, $facebook: String) {
      addUser(name: $name, gender: $gender, password: $password, premium: $premium, email: $email, birthday: $birthday, country: $country, haircolor: $haircolor, eyecolor: $eyecolor, body: $body, height: $height, ethnicity: $ethnicity, religion: $religion, state: $state, facebook: $facebook) {
        userid
      }
    }
  """;

  static const String refreshLikesViews = r"""
    mutation refreshLikesViews($userid: String!) {
	    getLikesViews(userid: $userid) {
	      info {
	        stats {
	          totallikes
	          totalviews
	        }
	      }
	    }
    }
  """;

  static Future<QueryResult> getLists() {
    return client2.mutate(MutationOptions(documentNode: gql(GraphQLHandler.getFullLikesViews),variables: {'userid':Common.userid}));
  }

  static const String getFullLikesViews = r"""
    mutation getLikesandViewsFully($userid: String!) {
	    getFullStats(userid: $userid) {
	      views {
	        by
          byName
          byPicture
        }
	      likes {
	        by
          byName
          byPicture
        }
      }
    }
  """;

  static const String addFacebookUser = r"""
    mutation createFacebook($name: String!, $premium: Boolean!, $gender: Boolean!, $fbid: String!, $profile: String!) {
      addFacebook(name: $name, premium: $premium, gender: $gender, fbid: $fbid, profile: $profile) {
        userid
        info {
          name 
        }
      }
    }
  """;

  static const String getProfile = r"""
    mutation getProfileUID($userid: String!) {
      getProfileUID(userid: $userid) {
        profilepic
        pictures {
          filepath
        }
        info{
          name
          stats {
            totalviews
            totallikes
          }
        }
      }
    }
  """;

  static const String loginUser = r"""
    mutation LoginM($email: String!, $password: String!) {
      loginManual(email: $email, password: $password) {
        userid
        info {
          name
          stats {
            totalviews
            totallikes
          }
        }
        profilepic
        pictures {
          filepath
        }
      }
    }
  """;

  static const String facebookLinked = r"""
    mutation FacebookLinked($fbid: String!) {
      FacebookLinked(fbid: $fbid) {
        userid
        info {
          name
          stats {
            totalviews
            totallikes
          }
        }
        profilepic
        pictures {
          filepath
        }
      }
    }
  """;

  /*
  final AuthLink authLink = AuthLink(
    getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
    // OR
    // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  );

  final Link link = authLink.concat(httpLink); */

}
