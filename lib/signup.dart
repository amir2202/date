import 'package:date/common.dart';
import 'package:date/country_suggetions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'GraphQLHandler.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {

  final _nameFocusNode = new FocusNode();
  final _countryFocusNode = new FocusNode();
  final _emailFocusNode = new FocusNode();
  final _passwordFocusNode = new FocusNode();

  final _countryTypeAheadController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  static final _defaultEnabledBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.grey));
  static final _defaultFocusedBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Color(0xFFCA436B)));
  static final _errorBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide(color: Colors.red));

  OutlineInputBorder _nameEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _nameFocusedBorder = _defaultFocusedBorder;
  bool _nameCorrect = true;
  OutlineInputBorder _genderEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _genderFocusedBorder = _defaultFocusedBorder;
  bool _genderCorrect = true;
  OutlineInputBorder _countryEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _countryFocusedBorder = _defaultFocusedBorder;
  bool _countryCorrect = true;
  OutlineInputBorder _emailEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _emailFocusedBorder = _defaultFocusedBorder;
  bool _emailCorrect = true;
  OutlineInputBorder _passwordEnabledBorder = _defaultEnabledBorder;
  OutlineInputBorder _passwordFocusedBorder = _defaultFocusedBorder;
  bool _passwordCorrect = true;

  String _selectedGender;
  String _selectedCountry;

  final _formKey = GlobalKey<FormState>();

  //TO DO memory deallocation

 /* @override
  void dispose(){

  }
*/
  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() { setState(() {}); });
    _countryFocusNode.addListener(() { setState(() {}); });
    _emailFocusNode.addListener(() { setState(() {}); });
    _passwordFocusNode.addListener(() { setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {

    if (Common.screenWidth == null || Common.screenHeight == null) {
      Common.screenWidth = MediaQuery.of(context).size.width;
      Common.screenHeight = MediaQuery.of(context).size.height;
    }

    return GraphQLProvider(
      client: GraphQLHandler.client/*ValueNotifier(
        GraphQLClient(
          cache: InMemoryCache(),
          link: api as Link,
        ),
      )*/,
      child: Scaffold(
        body: Stack(
          alignment:Alignment.center,
          children: <Widget>[

            // Gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF915FB5), Color(0xFFCA436B)],
                  begin: FractionalOffset.topLeft,
                  end: FractionalOffset.bottomRight,
                  stops: [0.0,1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                SizedBox(
                  width: Common.screenWidth * 0.9,
                  height: Common.screenHeight * 0.47,
                  child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Material(
                                      color: Colors.white,
                                      child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            _nameEnabledBorder = _defaultEnabledBorder;
                                            _nameFocusedBorder = _defaultFocusedBorder;
                                            _nameCorrect = true;
                                          });
                                        },
                                        controller: _nameController,
                                        focusNode: _nameFocusNode,
                                        decoration: InputDecoration(
                                          enabledBorder: _nameEnabledBorder,
                                          focusedBorder: _nameFocusedBorder,
                                          labelText: 'Full name',
                                          labelStyle: _nameCorrect ? TextStyle(color: _nameFocusNode.hasFocus ? Color(0xFFCA436B) : Colors.grey) : TextStyle(color: Colors.red),
                                          contentPadding: EdgeInsets.all(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                          enabledBorder: _genderEnabledBorder,
                                          focusedBorder: _genderFocusedBorder,
                                          labelText: 'Gender',
                                          labelStyle: TextStyle(color: _genderCorrect ? Colors.grey : Colors.red),
                                          contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 16)
                                      ),
                                      value: null,
                                      items: <String>[
                                        'Male',
                                        'Female',
                                      ].map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(value: value, child: Text(value),);
                                      }).toList(),
                                      onChanged: (String gender) {
                                        setState(() {
                                          _genderEnabledBorder = _defaultEnabledBorder;
                                          _genderFocusedBorder = _defaultFocusedBorder;
                                          _genderCorrect = true;
                                          _selectedGender = gender;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  Expanded(
                                    child: TypeAheadFormField(
                                      textFieldConfiguration: TextFieldConfiguration(
                                        onChanged: (value) {
                                          this._selectedCountry = value;
                                          setState(() {
                                            _countryEnabledBorder = _defaultEnabledBorder;
                                            _countryFocusedBorder = _defaultFocusedBorder;
                                            _countryCorrect = true;
                                          });
                                        },
                                        focusNode: _countryFocusNode,
                                        controller: _countryTypeAheadController,
                                        decoration: InputDecoration(
                                          enabledBorder: _countryEnabledBorder,
                                          focusedBorder: _countryFocusedBorder,
                                          labelText: 'Country',
                                          labelStyle: _countryCorrect ? TextStyle(color: _countryFocusNode.hasFocus ? Color(0xFFCA436B) : Colors.grey) : TextStyle(color: Colors.red),
                                          contentPadding: EdgeInsets.all(20),
                                        ),
                                      ),
                                      suggestionsCallback: (pattern) {
                                        return CountrySuggestions.getCountrySuggestions(pattern);
                                      },
                                      itemBuilder: (context, suggestion) {
                                        return ListTile(
                                          title: Text(suggestion),
                                        );
                                      },
                                      transitionBuilder: (context, suggestionsBox, controller) {
                                        return suggestionsBox;
                                      },
                                      noItemsFoundBuilder: (context) {
                                        return SizedBox();
                                      },
                                      onSuggestionSelected: (suggestion) {
                                        this._countryTypeAheadController.text = suggestion;
                                        this._selectedCountry = suggestion;
                                        _countryEnabledBorder = _defaultEnabledBorder;
                                        _countryFocusedBorder = _defaultFocusedBorder;
                                        _countryCorrect = true;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Material(
                                color: Colors.white,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      _emailEnabledBorder = _defaultEnabledBorder;
                                      _emailFocusedBorder = _defaultFocusedBorder;
                                      _emailCorrect = true;
                                    });
                                  },
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  decoration: InputDecoration(
                                    enabledBorder: _emailEnabledBorder,
                                    focusedBorder: _emailFocusedBorder,
                                    labelText: 'Email',
                                    labelStyle: _emailCorrect ? TextStyle(color: _emailFocusNode.hasFocus ? Color(0xFFCA436B) : Colors.grey) : TextStyle(color: Colors.red),
                                    contentPadding: EdgeInsets.all(20),
                                  )
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Material(
                                color: Colors.white,
                                child: TextFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      _passwordEnabledBorder = _defaultEnabledBorder;
                                      _passwordFocusedBorder = _defaultFocusedBorder;
                                      _passwordCorrect = true;
                                    });
                                  },
                                    controller: _passwordController,
                                    focusNode: _passwordFocusNode,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      enabledBorder: _passwordEnabledBorder,
                                      focusedBorder: _passwordFocusedBorder,
                                      labelText: 'Password',
                                      labelStyle: _passwordCorrect ? TextStyle(color: _passwordFocusNode.hasFocus ? Color(0xFFCA436B) : Colors.grey) : TextStyle(color: Colors.red),
                                      contentPadding: EdgeInsets.all(20),
                                    )
                                ),
                              ),
                            ],
                          ),
                        )
                      )
                  ),
                ),
                SizedBox(
                  height: Common.screenHeight * 0.05,
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Mutation(options: MutationOptions(
                    documentNode: gql(GraphQLHandler.registerUser),
                    update: (Cache cache, QueryResult result) {
                      return cache;
                    },
                    // or do something with the result.data on completion
                    onCompleted: (dynamic resultData) {
                      print(resultData);
                    },
                  ), builder: (RunMutation runMutation, QueryResult result){
                    return RaisedButton(
                      elevation: 5,
                      onPressed: () {
                        if (_nameController.text.isEmpty ||
                            _selectedGender == null ||
                            _selectedCountry == null || _selectedCountry.isEmpty || !CountrySuggestions.countries.contains(_selectedCountry) ||
                            _emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {

                          setState(() {
                            if (_nameController.text.isEmpty) {
                              _nameEnabledBorder = _errorBorder;
                              _nameFocusedBorder = _errorBorder;
                              _nameCorrect = false;
                            }
                            if (_selectedGender == null) {
                              _genderEnabledBorder = _errorBorder;
                              _genderFocusedBorder = _errorBorder;
                              _genderCorrect = false;
                            }
                            if (_selectedCountry == null || _selectedCountry.isEmpty || !CountrySuggestions.countries.contains(_selectedCountry)) {
                              _countryEnabledBorder = _errorBorder;
                              _countryFocusedBorder = _errorBorder;
                              _countryCorrect = false;
                            }
                            if (_emailController.text.isEmpty) { // || TODO: regex email match)
                              _emailEnabledBorder = _errorBorder;
                              _emailFocusedBorder = _errorBorder;
                              _emailCorrect = false;
                            }
                            if (_passwordController.text.isEmpty) { // || TODO: regex password / check length and requirements
                              _passwordEnabledBorder = _errorBorder;
                              _passwordFocusedBorder = _errorBorder;
                              _passwordCorrect = false;
                            }
                          });
                        }
                        else {
                          Navigator.pushNamed(context, 'signup');
                        }
                        /*bool gen = selectedGender == "Male";
                        print(result.data);
                        print(selectedGender);
                        print(_selectedCountry);
                        runMutation({'name':nameController.text,'password':passwordController.text,'premium':false,'email':emailController.text,'gender':gen,'country':_selectedCountry});
                        */
                      },
                      child: Text('NEXT'),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    );
                  })
                ),
                SizedBox(
                  height: Common.screenHeight * 0.1,
                ),
//                Material(
//                    type: MaterialType.transparency,
//                    child: Text(
//                      'By pressing "SIGN UP", you acknowledge that\n you have read and understand our Privacy Policy and our Terms of Service.',
//                      style: TextStyle(color: Colors.white, fontSize: 10),
//                      textAlign: TextAlign.center,
//                    )
//                ),
                SizedBox(
                  height: Common.screenHeight * 0.1,
                ),
              ],
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
      )
    );

  }

}