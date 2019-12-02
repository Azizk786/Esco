import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:escouniv/ComposeMessgae.dart';

class messaageDetail extends StatefulWidget {
  UserType StrUserType;
  Map Messagedetail;

  messaageDetail({Key key, @required this.StrUserType, @required this.Messagedetail}) : super(key: key);
  @override
  _messaageDetailState createState() => _messaageDetailState(StrUserType,Messagedetail);
}

class _messaageDetailState extends State<messaageDetail> {

  final UserType User;
  bool _saving = false;
  String struserid;
  Map Messagedetail;
  final _toController = TextEditingController();
  final _subjectcontroller = TextEditingController();
  final _bodyController = TextEditingController();

  _messaageDetailState(this.User,this.Messagedetail);
  @override
  void initState() {
    super.initState();
    GetUserdata();
    _readMessage();
    BackButtonInterceptor.add(myInterceptor);
  }

  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }
  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    Map userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();
    });
    print("Print userdata in Side menu");
    print(userdata);
  }
  showMyDialog(BuildContext context, String strmsg) {
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
  Future _readMessage() async
  {
    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.isreadMessage;
    final client = new http.Client();
    Map body =  {'message_id': Messagedetail["message_id"].toString()
    };
    print("print body = $body");
    final streamedRest = await client.post(
      url,
      body: body,
    );
    print("print body = $streamedRest");
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      setState(() {
        _saving = false;
      });
      _toController.text = "";
      _subjectcontroller.text = "";
      _bodyController.text = "";
     // showMyDialog(context, map["message"].toString());
      return;

    }
    else if (streamedRest.statusCode == 201) {
      setState(() {
        _saving = false;
      });
      showMyDialog(context, "Acest cod de e-mail nu este înregistrat cu aplicația");
      return;
    }
    else{
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
        showMyDialog(context, "Acest cod de e-mail nu este înregistrat cu aplicația");
        return;

      }
    }


  }

  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Detaliu mesaj"),
        ),
        body: ModalProgressHUD(inAsyncCall: _saving, child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Text('From', style: TextStyle(
                        fontFamily: 'Demi',
                        fontSize: 16,
                        color: Colors.black),
                  ),
                  Text(Messagedetail["username"].toString(), style: TextStyle(
                      fontFamily: 'Demi',
                      fontSize: 16,
                      color: Colors.black54),
                  ),
                  SizedBox(height: 25,),
                  Text('Date', style: TextStyle(
                      fontFamily: 'Demi',
                      fontSize: 16,
                      color: Colors.black),
                  ),
                  Text(Messagedetail["created_at"].toString(), style: TextStyle(
                      fontFamily: 'Demi',
                      fontSize: 16,
                      color: Colors.black54),
                  ),
                  SizedBox(height: 35,),
                  Text('Message', style: TextStyle(
                      fontFamily: 'Demi',
                      fontSize: 16,
                      color: Colors.black),
                  ),
                  Text(Messagedetail["body"].toString(), style: TextStyle(
                      fontFamily: 'Demi',
                      fontSize: 16,
                      color: Colors.black54),
                  ),

                  SizedBox(height: 25,),
                  RaisedButton(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                                "răspuns", style: TextStyle(fontFamily: 'regular')
                            )
                        )
                      ],
                    ),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ComposeMessage(StrUserType: User,strsenderemailid: Messagedetail["email"].toString(),)));
                    },
                    color: Appcolor.AppGreen,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  )

                ]
            )))
    );
  }
}
