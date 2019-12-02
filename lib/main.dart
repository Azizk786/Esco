import 'package:flutter/material.dart';
import 'package:escouniv/Registration.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:async_loader/async_loader.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/RegistrationStep2.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:escouniv/Notification.dart';
import 'package:overlay_support/overlay_support.dart';
typedef void FCMTokenCallback(String token);

void main() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(OverlaySupport(
      child: MyApp(prefs)
  ));
}

class MyApp extends StatelessWidget {


  final SharedPreferences prefs;
  MyApp(this.prefs);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String type = prefs.getString("UserType");
    UserType _character;
    if(type != null && type != '') {
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
      return Dashboard(StrUserType: _character);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch:createMaterialColor(Appcolor.redHeader)
      ),
      home: Loginpage(),
    );
  }
}

class Loginpage extends StatefulWidget {

  @override
  _LoginpageState createState() => _LoginpageState();
}
   BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    color: Appcolor.redHeader,
    border: Border.all(),
  );
}

class _LoginpageState extends State<Loginpage> {

  //Network connectivity check----------------------

  //-----------End----------------------------------
  bool _saving = false;
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  bool _obscureText = true;
  String _password;
   //for loader------------------------

  final GlobalKey<AsyncLoaderState> _asyncLoaderState =
  new GlobalKey<AsyncLoaderState>();
  //Text input widget
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  //StateModel state;
  UserType _character;
  String selectedUser;
  IconData _Passwordhide = Icons.visibility_off;
  bool isLoggedIn = false;
  GoogleSignInAccount _currentUser;
  String _socialEmail, _socialType, _socialid;
  String _messageText = "Waiting for message...";
  String _deviceToken = "Waiting for message...";



  void autoLogIn() async {


      _clearLoggedInUserdata();

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



  Future<void> _handleSignIn() async {
//    try {
//      await _googleSignIn.signIn();
//
//      print(error);
//    } catch (error) {
//      print(error);
    //}

    try {
      var googleUser = await _googleSignIn.signIn();
      print("google signed in user: ${googleUser?.email}");
    } catch (error) {
      print("google sign in error: $error"); // error is printed here
      return;
    }
  }

  //Private API-------------------------------------

  showMyDialog(BuildContext context, String strmsg)
  {
    showDialog(
        context: context,
        builder: (BuildContext context){
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
        }
    );
  }

  //Login API-----------------------------
  Future _socialLoginAPI(String socialType) async {
    setState(() {
      _saving = true;
    });
   // final String url = 'http://192.168.1.111:8000/api/user/login';
    //https://escouniv.ro/api/social/login
   //final String url = "http://192.168.1.111:8000/api/social/login";
  final String url = "https://escouniv.ro/api/social/login";
    final client = new http.Client();
    Map _payload = {
      'email': _socialEmail,
      'type': _socialType,
      'socialId': _socialid
    };
    print("print payload $_payload");
    /*
    email
type [‘facebook’,’google’]
socialId
    * */
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
      if (status == "Active") {
        String type = map["role"].toString();
        SaveLoggedInUserdata(map, type);

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
  Future LoginAPI() async {
    setState(() {
      _saving = true;
    });

   // final String url = "https://escouniv.ro/api/user/login";
    //http://192.168.1.20:8000/api/user/login

   // final String url = 'http://192.168.1.111:8000/api/user/login';
//
  final String url = "https://escouniv.ro/api/user/login";
    final client = new http.Client();
    final streamedRest = await client.post(url,
//      body: {
//        'username': "shiprian@gmail.com", //_usernameController.text,
//        'password': "123456"//_passwordController.text
//      },
        body: {
          'username': _usernameController.text,
          'password': _passwordController.text
        }
    );

    print(streamedRest);
    if (streamedRest.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      dynamic status = map["status"];
      print("print logi response");

      setState(() {
        _saving = false;
      });
      //|| map["email"].toString() != null
      if (status == "Active") {

        String type = map["role"].toString();

        if (type == "student") {
          _character = UserType.Student;
        }
        else if (type == "consilier-cariera") {
          _character = UserType.CCounsellor;
        }
        else if (type == "mentor") {
          _character = UserType.Mentor;
        }
        else if (type == "firma") {
          _character = UserType.CP;
        }
        else if (type == "consilier-psihologic") {
          _character = UserType.Pcounsellor;
        }
        else if (type == "elev") {
          _character = UserType.Pupil;
        }
        else {
          _character = UserType.Pupil;
        }

        //Ignorat
        print("print user type = _character");
        print(_character);
        SaveLoggedInUserdata(map, type);

        UpdateDeviceToken(map["userid"].toString());
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//                builder: (context) => Dashboard(StrUserType: _character)));

      }
      else {
        if (map["status"].toString() == "Register waiting approval")
          {
            showMyDialog(context, "Contul așteaptă aprobarea");
          }else
            {
              showMyDialog(context, map["message"].toString());
            }
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

  Future UpdateDeviceToken(String userid) async {
    setState(() {
      _saving = true;
    });
String _dtype = "ios";
    if (Platform.isAndroid) {
      // Android-specific code
      _dtype = "android";
    } else if (Platform.isIOS) {
      // iOS-specific code
      _dtype = "ios";
    }
    final String url = API.Base_url + API.UpdateDeviceToken;
    final client = new http.Client();
    final streamedRest = await client.post(url,

        body: {
          'user_id': userid,
          'devicetoken': _deviceToken,
    'device_id':"11111",
    'device_type': _dtype
        }
    );
    print("device jjjjtoken = $_deviceToken");

    print(streamedRest);
    if (streamedRest.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      setState(() {
        _saving = false;
      });

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(StrUserType: _character)));
      }
     else {
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

   SaveLoggedInUserdata(Map map, String type) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString("Userdata", json.encode(map));
    prefs.setString("UserType", type);

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
        print(facebookLoginResult.errorMessage);
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
  //Change facebook login status here--------------------------
  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      setState(() {
        _saving = false;
      });
      this.isLoggedIn = isLoggedIn;
      if (this.isLoggedIn == true)
      {
       // _socialLoginAPI("facebook");
      }
    });
  }

  _clearLoggedInUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("Userdata");
    await prefs.clear();
  }

  FCMTokenCallback(String token) {
    _deviceToken = token;
  }

  @override
  void initState() {
    super.initState();
configureFCMNotification();
    autoLogIn();
  }

  Future<void> onPush(Map<String, dynamic> data) {
    return Future.value();
  }

  configureFCMNotification() {
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
       // _handleNotification(message);

      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

      },
    );

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      {
        _deviceToken = token;
        print("Print device token here=$token");
      }
    });

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

  @override
  Widget build(BuildContext context) {


    showMyDialog(BuildContext context, String strmsg) {
      showDialog(
          context: context,
          builder: (BuildContext context){
            return new AlertDialog(
              content: Text(
                strmsg,
              ),
              title: Text("ESCOUNIV"),
              actions: <Widget>[
                FlatButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          }
      );
    }

  void LoginValidation() {

      if(_usernameController.text.length <1) {

        showMyDialog(context,"Introduceți codul de e-mail");
      }
      else  if(_passwordController.text.length < 1) {
        showMyDialog(context,"Te rog introdu parola");
      }
//      else if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_usernameController.text)== false)
//      {
//        showMyDialog(context,"te rog introdu un email valid");
//      }
//      else if(_passwordController.text.length < 6)
//      {
//        showMyDialog(context,"Password ");
//      }

      else {
        LoginAPI();
       }
    }
    final loginButon = Material(
      color: Colors.transparent,
      child:OutlineButton(
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                widthFactor: 2,
                child: Text(
                  "Intra in cont",
                  style:TextStyle(fontFamily: 'regular', fontSize: 16),
                )
             )
          ],
        ),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(18.0)),
        textColor: Colors.white,
        onPressed: () {

         LoginValidation();
//          Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => Dashboard(StrUserType: UserType.Student)));

        }, //callback when button is clicked
        borderSide: BorderSide(
          color: Colors.white, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 1, //width of the border
        ),
      )
    );
    final ForgotpwdButon = Material(
        color: Colors.transparent,
        child:FlatButton(
          child: Stack(
            children: <Widget>[
              Container(
//                  alignment: Alignment.centerLeft,

                  child: Icon(Icons.lock)
              ),
              Container(
//                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 25.0, top: 5.0),
                  child: Text(
                      " Recupereaza parola",
                      style:TextStyle(fontFamily: 'regular', fontSize: 14, color: Colors.white)
                  )
              )
            ],
          ),
          textColor: Colors.white,
          onPressed: () {


          }, //callback when button is clicked
        )
    );
    final googleButon = Material(
        color: Colors.transparent,
        child:OutlineButton(

          child: Stack(
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 15.0,
                    width: 15.0,
                    margin: EdgeInsets.only(left: 10.0),
                    child: new Image.asset('Assets/Images/Vectorgoogle.png'),
                  )
              ),
              Container(
                  margin: EdgeInsets.only(left: 40.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Google",
                    style:TextStyle(fontFamily: 'regular', fontSize: 16),
                  )
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.white,
          onPressed: () {
            _handleSignIn();
//            Navigator.push(
//                context,
//                MaterialPageRoute(builder: (context) => Dashboard(StrUserType: _character)));
         //   Loginpage.of(context).signInWithGoogle();
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.white, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border

          ),
        )
    );
    final facebookButon = Material(
//      elevation: 18.0,
        color: Colors.transparent,
        child:OutlineButton(
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
                  )
              ),
              Container(
                  margin: EdgeInsets.only(left: 40.0),
//                alignment: Alignment.center,
                  child: Text(
                    "Facebook",
                    style:TextStyle(fontFamily: 'regular', fontSize: 16),
                  )
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.white,
          onPressed: () {
            initiateFacebookLogin();
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.white, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )
    );

    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
              _Passwordhide != Icons.visibility_off
          ? _Passwordhide = Icons.visibility_off
          : _Passwordhide = Icons.visibility;
      });
    };
    var Seperator = Container(color: Colors.grey.withOpacity(1), width: 1,height: 50,);
    final PwdField = Container(
      child: Row(
        children: <Widget>[
      new IconButton(
    //
        //onPressed: _toggle,
        icon: new Image(image: AssetImage("Assets/Images/Vectorpassword.png")),
        color:Appcolor.redHeader,
        iconSize: 20,
      ),
          Seperator,
          SizedBox(width: 5,),
           Expanded(
            child: TextFormField(
              controller: _passwordController,
              textAlign: TextAlign.left,

              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black,fontSize: 16.0),
                border: InputBorder.none,
                hintText: 'Parola',
               // prefixIcon: new Image(image: AssetImage("Assets/Images/Vectorpassword.png")),
                hintStyle: TextStyle(color: Colors.grey),
              ),
              validator: (val) => val.length < 6 ? 'Password too short.' : null,
              onSaved: (val) => _password = val,
              obscureText: _obscureText,
           //   initialValue: '123456',
            ),
          ),
           IconButton(
            onPressed: _toggle,
            icon: Icon(
              _Passwordhide,
              color: Appcolor.redHeader,
            ),
            color:Appcolor.redHeader,
            iconSize: 20,
          )
        ],
      ),
    );
    final UserField = Container(
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
          SizedBox(width: 5,),
          new Expanded(
            child: TextFormField(
              controller: _usernameController,
              obscureText: false,
              textAlign: TextAlign.left,

              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.black,fontSize: 16.0),
                border: InputBorder.none,
                hintText: 'Nume utilizator',
                // prefixIcon: new Image(image: AssetImage("Assets/Images/Vectorpassword.png")),
                hintStyle: TextStyle(color: Colors.grey),
              ),
               // initialValue: 'shiprian@gmail.com',
            ),
          ),
        ],
      ),
    );

    return new Scaffold(
      body:ModalProgressHUD(inAsyncCall: _saving, child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("Assets/Images/bg.png"),
            fit: BoxFit.fill,
          ),
        ),
        child:Center(
            child:SingleChildScrollView(
              child:Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 184.0,
                      height: 80,
                      margin: EdgeInsets.only(top:56.0),
                      alignment: AlignmentDirectional.center,
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage("Assets/Images/logo.png"),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      //  color:Colors.red,
                      height: 140.0,
                      width: 248,
                      margin: EdgeInsets.only(top: 10,left:15.0,right: 15),
                      decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: new AssetImage("Assets/Images/logo-escouniv.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                        margin: EdgeInsets.only(top: 10,left: 35.0,right: 35),

                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.all(const Radius.circular(10.0))),
                        //  margin: EdgeInsets.only(left:10,right: 10,top: 20),
                        child: Column(
                          children: <Widget>[
                            UserField,
                            aGreyHorizonalLine,
                            PwdField
                          ],
                        )
                    ),
                    SizedBox(height: 15),
                    loginButon,
                    SizedBox(height: 20),
                    Container(
                      height: 30.0,
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 35,
                            child: googleButon,
                          ),
                          SizedBox(width: 25),
                          Container(
                            child: facebookButon,
                          ),
                        ],
                      ),
                    ),
                    //SizedBox(height:40),
//                  Column(
//                    mainAxisAlignment: MainAxisAlignment.end,
//                    children: <Widget>[
//                      Container(
//
//                          child:DropdownButtonHideUnderline(
//                            child: DropdownButton(
//                              isDense:  true,
//                              hint: Text("Select User"),
//                              iconEnabledColor: Colors.amber,
//                              iconDisabledColor: Colors.white,
//                              value: _currentUserType,
//                              items: _dropDownUserType,
//                              elevation: 6,
//                              onChanged: changedDropDownItems,
//                            ),
//                          )
//                      )
//                    ],
//                  ),
                    SizedBox(height:20),
                    ForgotpwdButon,
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Nu ai un cont ?', style:TextStyle(fontFamily: 'regular', fontSize: 16, color: Colors.white),),
                          SizedBox(width: 2,),
                          new GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Registration()),
                              );
                            },
                            child: new Text('Inregistreaza-te', style:TextStyle(fontFamily: 'regular', fontSize: 16, color: Colors.yellow),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ) ,
            )
        ),
      ),)
    );
  }
}