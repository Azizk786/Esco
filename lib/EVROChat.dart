import 'package:flutter/material.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:back_button_interceptor/back_button_interceptor.dart';

class ChatMessage extends StatefulWidget {
  final UserType User;
  final String Senderid;
  ChatMessage({Key key, @required this.User, @required this.Senderid})
      : super(key: key);
  @override
  _ChatMessageState createState() => _ChatMessageState(User, Senderid);
}

class _ChatMessageState extends State<ChatMessage> {
  final UserType User;
  final String Senderid;
  _ChatMessageState(this.User, this.Senderid);
  Timer timer;
  bool _saving = true;
  String struserid;
  List _messages = new List();
  final _textController = TextEditingController();
  @override
  _handleSubmitted() {
    SendMessage();

    //new
  }

  void initState() {
    super.initState();
    GetUserdata();
    BackButtonInterceptor.add(myInterceptor);

  }

  @override
  void dispose() {
    timer?.cancel();
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  void fetchData() {
    getAllMessage().then((res) {

      setState(() {
        _messages = [];
        _messages.addAll(res);
      });
    });
  }

  GetUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    Map userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();
      setState(() {
        _saving = true;
      });
      fetchData();
      timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fetchData());
    });
    print("Print userdata in Side menu");
    print(userdata);

  }

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

  Future SendMessage() async {
    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.SendChat;
    final client = new http.Client();
    Map body = {
      'sender_id': struserid,
      'participant_id': Senderid,
      'message': _textController.text.toString(),
    };
    print("print body = $body");
    final streamedRest = await client.post(
      url,
      body: body,
      //  headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    );
    print("print streamedRest = $streamedRest");
    _textController.clear();
    if (streamedRest.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
     // fetchData();
      return;
    } else if (streamedRest.statusCode == 201) {
      setState(() {
        _saving = false;
      });
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["romanMsg"].toString());
      //showMyDialog(context, "Acest cod de e-mail nu este înregistrat cu aplicația");
      return;
    } else {
      setState(() {
        _saving = false;
      });
      if (streamedRest.statusCode == 400) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
      } else if (streamedRest.statusCode == 401) {
        showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
      } else if (streamedRest.statusCode == 500) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
      } else if (streamedRest.statusCode == 1001) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
      } else if (streamedRest.statusCode == 1005) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
      } else if (streamedRest.statusCode == 999) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
      } else {
        showMyDialog(
            context, "Acest cod de e-mail nu este înregistrat cu aplicația");
        return;
      }
    }
  }

  Future<List> getAllMessage() async {
//sender_id:struserid participant_id:Senderid

    const String developmentBase_url11 = 'http://192.168.1.111/eeesv/api/';
    final String url = API.Base_url + API.GetAllChathistory;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'sender_id': struserid, 'participant_id': Senderid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if (streamedRest.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      int status = map["status"] as int;
      setState(() {
        _saving = false;
      });
      if (status == 200) {
      } else {
        showMyDialog(context, map["message"].toString());
      }

      return map["chatData"];
    } else {
      setState(() {
        _saving = false;
      });
      if (streamedRest.statusCode == 400) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
      } else if (streamedRest.statusCode == 401) {
        showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
      } else if (streamedRest.statusCode == 500) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
      } else if (streamedRest.statusCode == 1001) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
      } else if (streamedRest.statusCode == 1005) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
      } else if (streamedRest.statusCode == 999) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
      } else {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
      }
    }
  }

  Widget build(BuildContext context) {
    Widget _buildTextComposer() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                controller: _textController,
              //  onEditingComplete: _handleSubmitted(),
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              //new
              margin: new EdgeInsets.symmetric(horizontal: 4.0), //new
              child: new IconButton(
                  //new
                  icon: new Icon(
                    Icons.send,
                    color: Colors.red,
                  ), //new
                  onPressed: () =>
                      _handleSubmitted()), //new
            ), //new
          ],
        ),
      );
    }

    Widget BuildChatrow(int _inx) {
      final receivedradius = BorderRadius.only(
          topLeft: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(10.0));

      final isMeRadius = BorderRadius.only(
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(5.0));

      if (_messages[_inx]["sender_id"] == struserid) {
        return Container(
          padding: EdgeInsets.all(5),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(3.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: .5,
                          spreadRadius: 1.0,
                          color: Colors.black.withOpacity(.12))
                    ],
                    color: Colors.amber,
                    borderRadius: receivedradius,
                  ),
                  // color: Colors.black12,

                  child: Stack(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 48.0),
                      child: Text(_messages[_inx]["message"]),
                    ),
                    Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: Row(children: <Widget>[
                          Text(
                              _messages[_inx]["created"]
                                  .toString()
                                  .split(" ")[1],
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 10.0,
                              )),
                          SizedBox(width: 3.0),
                        ]))
                  ])),
              SizedBox(
                height: 12,
              )
            ],
          ),
        );
      } else {
        return Container(
          padding: EdgeInsets.all(5),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(_messages[_inx]["username"]),
              SizedBox(height: 10,),
              Container(
                  margin: const EdgeInsets.all(3.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: .5,
                          spreadRadius: 1.0,
                          color: Colors.black.withOpacity(.12))
                    ],
                    color: Colors.blue,
                    borderRadius: isMeRadius,
                  ),
                  // color: Colors.black12,

                  child: Stack(children: <Widget>[

                    Padding(
                      padding: EdgeInsets.only(right: 48.0),
                      child: Text(_messages[_inx]["message"]),
                    ),
                    Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: Row(children: <Widget>[
                          Text(
                              _messages[_inx]["created"]
                                  .toString()
                                  .split(" ")[1],
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 10.0,
                              )),
                          SizedBox(width: 3.0),
                        ]))
                  ])),
              SizedBox(
                height: 12,
              )
            ],
          ),
        );
      }
    };

    return new Scaffold(
        appBar: new AppBar(title: new Text("Message")),
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: Column(children: <Widget>[
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: _messages.length,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return BuildChatrow(index);
              },
            )), //new
            new Divider(height: 1.0),
            new Container(
              //new
              decoration:
                  new BoxDecoration(color: Theme.of(context).cardColor), //new
              child: _buildTextComposer(), //modified
            ),

            SizedBox(
              height: 50,
            ),
          ]),
        )
        //new
        );
  }
}
