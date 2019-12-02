import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:escouniv/Message.dart';

class ComposeMessage extends StatefulWidget {
  UserType StrUserType;
  String strsenderemailid;

  ComposeMessage({Key key, @required this.StrUserType, @required this.strsenderemailid}) : super(key: key);
  @override
  _ComposeMessageState createState() => _ComposeMessageState(StrUserType,strsenderemailid);
}

class _ComposeMessageState extends State<ComposeMessage> {

  final UserType User;
  bool _saving = false;
  String struserid;
  String strsenderemailid;
  final _toController = TextEditingController();
  final _subjectcontroller = TextEditingController();
  final _bodyController = TextEditingController();

  _ComposeMessageState(this.User,this.strsenderemailid);
  @override
  void initState() {
    super.initState();
    GetUserdata();
    _toController.text = strsenderemailid;
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
  Future SendMessage() async
  {
    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.GetComposemessage;
    final client = new http.Client();
    Map body =  {'user_id': struserid,
  'to': _toController.text,
  'subject': _subjectcontroller.text,
  'message': _bodyController.text,
  };
    print("print body = $body");
    final streamedRest = await client.post(
      url,
      body: body,
      //  headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    );
    print("print streamedRest = $streamedRest");
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      setState(() {
        _saving = false;
      });

      _toController.text = "";
      _subjectcontroller.text = "";
      _bodyController.text = "";
      showMyDialog(context, map["romanMsg"].toString());
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Messageview(StrUserType: User)),
      );
      return;

    }
   else if (streamedRest.statusCode == 201) {
      setState(() {
        _saving = false;
      });
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["romanMsg"].toString());
      //showMyDialog(context, "Acest cod de e-mail nu este înregistrat cu aplicația");
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
          title: Text("Mesaj copmose"),
        ),
        body: ModalProgressHUD(inAsyncCall: _saving, child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'To',
                    ),
                    controller: _toController,
                  ),
                  SizedBox(height: 25,),

                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Subject',
                    ),
                    controller: _subjectcontroller,
                  ),
                  SizedBox(height: 45,),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Write here',
                    ),
                    controller: _bodyController,
                  ),
                  SizedBox(height: 25,),
                  RaisedButton(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                                "trimite", style: TextStyle(fontFamily: 'regular')
                            )
                        )
                      ],
                    ),
                    onPressed: (){
               SendMessage();
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
