import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'main.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:escouniv/RegistrationStep2.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    border: Border.all(),
  );
}

class _RegistrationState extends State<Registration> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conpasswordController = TextEditingController();
  final _emailController = TextEditingController();
  bool isLoggedIn = false;
  bool usernameChecked = false;
  bool emailChecked = false;
  String _socialEmail, _socialType, _socialid;
  UserType _character;
  GoogleSignInAccount _currentUser;
  bool _saving = false;
  SharedPreferences prefs;
  bool _groupValuenew = false;

//Google Sign in

  showMyDialog(BuildContext context, String strmsg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Text(
              strmsg,
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'profile',

    ],
  );
  //Facebook Login------------------------
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

//Facebook Login------------------------
  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    setState(() {
      _saving = true;
    });
    var facebookLoginResult =
    await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${facebookLoginResult
               .accessToken.token}');
        final profile = json.decode(graphResponse.body);

        _socialEmail = profile["email"];
        _socialid = profile["id"];
        _socialType = "facebook";
        _socialLoginAPI("facebook");
        onLoginStatusChanged(true);
        break;
    }
  }
  //API Integration-----------------------------------------------
  Future Check_ForAlredadyRegister(String strtype) async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetCheckExist;
    final client = new http.Client();

    if (strtype == "email") {
      // for email existence check
      final streamedRest = await client.post(
        url,
        body: {'email': _emailController.text},
        //  headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
      );
      if(streamedRest.statusCode == 200)
      {
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        print("print existence response = &()");
        print(map);
        dynamic status = map["status"].toString();

        setState(() {
          _saving = false;
        });
        if (status == "200") {
          emailChecked = true;
        } else {
          emailChecked = false;
          showMyDialog(context, map["message"].toString());
          return;
        }
      }else{
        setState(() {
          _saving = false;
        });
        if (streamedRest.statusCode == 400)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
        }
        else if (streamedRest.statusCode == 401)
        {
          showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
        }
        else if (streamedRest.statusCode == 500)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
        }
        else if (streamedRest.statusCode == 1001)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
        }
        else if (streamedRest.statusCode == 1005)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
        }
        else if (streamedRest.statusCode == 999)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
        }
        else
        {
          Map<dynamic, dynamic> map = json.decode(streamedRest.body);
          print("print existence response = &()");
          print(map);
          dynamic status = map["status"].toString();
          showMyDialog(context, map["romanMsg"].toString());

        }
      }

    }
    else {
      //For username existance check
      final streamedRest = await client.post(
        url,
        body: {'username': _nameController.text},
        //  headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
      );

      if(streamedRest.statusCode == 200) {
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        print("print existence response = &()");
        print(map);
        dynamic status = map["status"].toString();
        _saving = false;
        if (status == "200") {
          usernameChecked = true;
        } else {
          usernameChecked = false;
          showMyDialog(context, map["message"].toString());
          return;
        }
      }else
      {
        setState(() {
          _saving = false;
        });
        if (streamedRest.statusCode == 400)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
        }
        else if (streamedRest.statusCode == 401)
        {
          showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
        }
        else if (streamedRest.statusCode == 500)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
        }
        else if (streamedRest.statusCode == 1001)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
        }
        else if (streamedRest.statusCode == 1005)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
        }
        else if (streamedRest.statusCode == 999)
        {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
        }
        else
        {
          Map<dynamic, dynamic> map = json.decode(streamedRest.body);
          print("print existence response = &()");
          print(map);
          dynamic status = map["status"].toString();
          showMyDialog(context, map["message"].toString());
        }
      }
    }
  }
  Future _socialLoginAPI(String socialType) async {
    setState(() {
      _saving = true;
    });
    //http://192.168.1.20:8000/api/user/register
    //https://escouniv.ro/api/social/login
   /// final String url = "http://192.168.1.111:8000/api/social/login";
    final String url = "https://escouniv.ro/api/social/login";
    final client = new http.Client();
    Map _payload = {
      'email': _socialEmail,
      'type': _socialType,
      'socialId': _socialid
    };
    print("print payload $_payload");

    final streamedRest = await client.post(url,
      body:_payload,
      //  headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    );
    print("print social logi response");
    print(streamedRest.body);
    if (streamedRest.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      dynamic status = map["status"];

      setState(() {
        _saving = false;
      });
      if (status == "Active" && map.containsKey("email")) {
        String type = map["role"].toString();

        if (type == "student") {
          _character = UserType.Student;
        }
        else if (type == "consilier-cariera") {
          _character = UserType.CCounsellor;
        }
        else if (type == "public") {
          _character = UserType.Pupil;
        }
        else if (type == "mentor") {
          _character = UserType.Mentor;
        }
        else if (type == "firma") {
          _character = UserType.CP;
        }
        else {

          _character = UserType.Pcounsellor;
        }

        print("print user type = _character");
        print(_character);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(StrUserType: _character)));
      }
      else if (status == "Register step 2")
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => registrationStep2(
                    strUsername:"",
                    strEmail: _socialEmail,
                    registrationTye: "Social")));
      }
      else if (status == "Register step 2")
      {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => registrationStep2(
                    strUsername:"",
                    strEmail: _socialEmail,
                    registrationTye: "Social")));
      }
      else if (status == "Register waiting approval")
      {
        showMyDialog(context, "Înregistrarea așteaptă aprobarea");
      }

      print(map);
    } else {
      setState(() {
        _saving = false;
      });
      if (streamedRest.statusCode == 400)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
      }
      else if (streamedRest.statusCode == 401)
      {
        showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
      }
      else if (streamedRest.statusCode == 500)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
      }
      else if (streamedRest.statusCode == 1001)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
      }
      else if (streamedRest.statusCode == 1005)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
      }
      else if (streamedRest.statusCode == 999)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
      }
      else
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
      }

    }
  }
//Change facebook login status here--------------------------
  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      setState(() {
        _saving = false;
      });
      this.isLoggedIn = isLoggedIn;
      if (this.isLoggedIn == true)
      {

        _socialType = "facebook";
        _socialLoginAPI("facebook");
      }
    });
  }

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getSharedPrefs();

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        print("google detail");
        print(_currentUser.displayName);
        print(_currentUser.email);
        _socialEmail = _currentUser.email;
        _socialid = _currentUser.id;
        _socialType = "google";
        _socialLoginAPI("google");
      }
    });
    //   _googleSignIn.signInSilently();

    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }
  Widget build(BuildContext context) {


    //Validation-------------------------------------
    void RegistrationValidation() {
      if (_nameController.text.length < 1) {
        showMyDialog(context, "Introduceți numele");
      } else if (_emailController.text.length < 1) {
        showMyDialog(context, "Introduceți codul de e-mail");
      } else if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(_emailController.text) ==
          false) {
        showMyDialog(context, "Introduceți un ID de e-mail valid");
      } else if (_passwordController.text.length < 1) {
        showMyDialog(context, "Te rog introdu parola");
      } else if (_conpasswordController.text.length < 1) {
        showMyDialog(context, "Introduceți Confirmare parolă");
      }
      else if (_passwordController.text != _conpasswordController.text) {
        showMyDialog(context,
            "Parola și confirmarea parolei ar trebui să fie identice.");
      }
      else {
        setState(() {
          if (usernameChecked == true && emailChecked == true) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        registrationStep2(
                            strUsername: _nameController.text,
                            strEmail: _emailController.text,
                            strPassword: _passwordController.text,registrationTye: "Normal",)));
          } else {
            Check_ForAlredadyRegister('username');

            Check_ForAlredadyRegister('email');
            setState(() {
              if (usernameChecked == true && emailChecked == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            registrationStep2(
                              strUsername: _nameController.text,
                              strEmail: _emailController.text,
                              strPassword: _passwordController.text,
                              registrationTye: "Normal",)));
              }
            });
          }
        });
      }
    }
    final RegistrationButon = Material(
        elevation: 18.0,
        color: Colors.transparent,
        child: OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 2,
                  child: Text("Inregistreaza-te",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'regular',
                          fontSize: 16)))
            ],
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.white,
          onPressed: () {
            RegistrationValidation();
           // Navigator.push(
           //     context,
           //     MaterialPageRoute(builder: (context) => registrationStep2(strUsername: _nameController.text, strEmail: _emailController.text, strPassword: _passwordController.text)));
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.white, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        ));
    final googleButon = Material(
        color: Colors.transparent,
        child: OutlineButton(
          child: Stack(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 15.0,
                    width: 15.0,
                    margin: EdgeInsets.only(left: 10.0),
                    child: new Image.asset('Assets/Images/Vectorgoogle.png'),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 40.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Google",
                    style: TextStyle(fontFamily: 'regular', fontSize: 16),
                  ))
            ],
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0)),
          textColor: Colors.white,
          onPressed: () {
            _handleSignIn();
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.white, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        ));
    final facebookButon = Material(
//      elevation: 18.0,
        color: Colors.transparent,
        child: OutlineButton(
          child: Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 5.0),

//                alignment: Alignment.centerLeft,
                  //widthFactor: 5,
                  child: Container(
                    height: 20.0,
                    width: 20,
                    margin: EdgeInsets.only(left: 10.0),
                    child: new Image.asset('Assets/Images/Vectorfacebook.png'),
                  )),
              Container(
                  margin: EdgeInsets.only(left: 40.0),
//                alignment: Alignment.center,
                  child: Text(
                    "Facebook",
                    style: TextStyle(fontFamily: 'regular', fontSize: 16),
                  ))
            ],
          ),
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.white,
          onPressed: () {
            initiateFacebookLogin();
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.white, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        ));
    var Seperator = Container(
      color: Colors.grey.withOpacity(1),
      width: 1,
      height: 50,
    );
    final NameField = Container(
      child: Row(
        children: <Widget>[
          new IconButton(
            icon: const Icon(
              Icons.person,
              color: Appcolor.redHeader,
            ),
            iconSize: 20,
          ),
          Seperator,
          SizedBox(
            width: 5,
          ),
          new Expanded(
            child: TextFormField(
              controller: _nameController,
              obscureText: false,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                border: InputBorder.none,
                hintText: 'Nume utilizator',
                // prefixIcon: new Image(image: AssetImage("Assets/Images/Vectorpassword.png")),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
    final EmailField = Container(
      child: Row(
        children: <Widget>[
          new IconButton(
            icon: const Icon(
              Icons.email,
              color: Appcolor.redHeader,
            ),
            iconSize: 20,
          ),
          Seperator,
          SizedBox(
            width: 5,
          ),
          new Expanded(
            child: TextFormField(
              controller: _emailController,
              obscureText: false,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                border: InputBorder.none,
                hintText: 'E-mail',
                // prefixIcon: new Image(image: AssetImage("Assets/Images/Vectorpassword.png")),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
    final passwordField = Container(
      child: Row(
        children: <Widget>[
          new IconButton(
            icon: new Image(
                image: AssetImage("Assets/Images/Vectorpassword.png")),
            iconSize: 20,
          ),
          Seperator,
          SizedBox(
            width: 5,
          ),
          new Expanded(
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                border: InputBorder.none,
                hintText: 'Parola',
                // prefixIcon: new Image(image: AssetImage("Assets/Images/Vectorpassword.png")),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
    final conpasswordField = Container(
      child: Row(
        children: <Widget>[
          new IconButton(
            icon: new Image(
                image: AssetImage("Assets/Images/Vectorpassword.png")),
            iconSize: 20,
          ),
          Seperator,
          SizedBox(
            width: 5,
          ),
          new Expanded(
            child: TextFormField(
              controller: _conpasswordController,
              obscureText: true,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black, fontSize: 16.0),
                border: InputBorder.none,
                hintText: 'Confirma parola',
                // prefixIcon: new Image(image: AssetImage("Assets/Images/Vectorpassword.png")),
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
    return new Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: false,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("Assets/Images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
              child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 174.0,
                    height: 70,
                    margin: EdgeInsets.only(top: 30.0),
                    alignment: AlignmentDirectional.center,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: new AssetImage("Assets/Images/logo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Container(
                    //  color:Colors.red,
                    height: 140.0,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 10, left: 15.0, right: 15),
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image:
                            new AssetImage("Assets/Images/logo-escouniv.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                      margin: EdgeInsets.only(top: 10, left: 35.0, right: 35),
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.all(
                              const Radius.circular(10.0))),
                      //  margin: EdgeInsets.only(left:10,right: 10,top: 20),
                      child: Column(
                        children: <Widget>[
                          NameField,
                          aGreyHorizonalLine,
                          EmailField,
                          aGreyHorizonalLine,
                          passwordField,
                          aGreyHorizonalLine,
                          conpasswordField
                        ],
                      )),
                  SizedBox(height: 15),
                  CheckboxListTile(
                    title: Text("Ați citit politica de confidențialitate și cookies și sunteți de acord cu procesarea datelor",style: TextStyle(color: Colors.white),),
                    value: _groupValuenew,
                    onChanged: (newValue) {
                      setState(() {
                        _groupValuenew = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),
                  SizedBox(height: 5),
                  RegistrationButon,
                  SizedBox(height: 20),
                  Container(
                    height: 30.0,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        googleButon,
                        SizedBox(width: 10),
                        facebookButon
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 40),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Ai un cont ?',
                          style: TextStyle(
                              fontFamily: 'regular',
                              fontSize: 16,
                              color: Colors.white),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        new GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);

                          },
                          child: new Text(
                            'Intra in cont',
                            style: TextStyle(
                                fontFamily: 'regular',
                                fontSize: 16,
                                color: Colors.yellow),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}