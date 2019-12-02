import 'package:flutter/material.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/EVROChat.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/ComposeMessgae.dart';
import 'package:escouniv/MessageDetail.dart';


class Messageview extends StatelessWidget {
  UserType StrUserType;
  Messageview({Key key, @required this.StrUserType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MessageList(User: StrUserType);
  }
}

class MessageList extends StatefulWidget {
  final UserType User;
  MessageList({Key key, @required this.User}) : super(key: key);
  @override
  _MessageListState createState() => _MessageListState(User);
}

class _MessageListState extends State<MessageList> {
  UserType User;
  bool _saving = false;
  _MessageListState(this.User);
  String struserid;
  String MessageType = "1";
  List _Receivedmessages = new List();
  List _Sentdmessages = new List();
  List _Deletedmessage = new List();
  List _UnreadMessage = new List();

  //API Call (Get history list)----------------------
  Future<List> getReceived() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetReceivedList;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': "120"},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if (streamedRest.statusCode == 200)
      {
        setState(() {
        _saving = false;
      });
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        return map["sendMsg"];
      }
  else if (streamedRest.statusCode == 201) {
      setState(() {
        _saving = false;
      });
  Map<dynamic, dynamic> map = json.decode(streamedRest.body);
  showMyDialog(context, map["romanMsg"].toString());
  }
    else
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
    showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
    }

      }

  }
  Future<List> getSent() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetSentList;
    final client = new http.Client();
    final streamedRest = await client.post(url,

        body: {'sender_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if (streamedRest.statusCode == 200)
    {setState(() {
      _saving = false;
    });
    Map<dynamic, dynamic> map = json.decode(streamedRest.body);
    return map["sendMsg"];
  }
  else if (streamedRest.statusCode == 201) {
      setState(() {
        _saving = false;
      });
  Map<dynamic, dynamic> map = json.decode(streamedRest.body);
  showMyDialog(context, map["romanMsg"].toString());
  }
    else
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
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
      }

    }

  }
  Future<List> getDeleted() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetDeletedList;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'participant_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if (streamedRest.statusCode == 200)
    {setState(() {
      _saving = false;
    });
    Map<dynamic, dynamic> map = json.decode(streamedRest.body);
    dynamic Status = map["status"];

    return map["sendMsg"];
    }

  else if (streamedRest.statusCode == 201) {
      setState(() {
        _saving = false;
      });
  Map<dynamic, dynamic> map = json.decode(streamedRest.body);
  showMyDialog(context, map["romanMsg"].toString());
  }
    else
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
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
      }

    }

  }
  Future<List> getUnread() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetUnreadmessage;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'participant_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if (streamedRest.statusCode == 200)
    {
      setState(() {
      _saving = false;
    });
    Map<dynamic, dynamic> map = json.decode(streamedRest.body);
    return map["sendMsg"];
    }
    else if (streamedRest.statusCode == 201) {
      setState(() {
        _saving = false;
      });
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["romanMsg"].toString());
    }

    else
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
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
      }

    }

  }
  //Private method to get History list
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

  void fetchData() {
    if (MessageType == "1")
      {
        getReceived().then((res) {
          _Receivedmessages = [];
          setState(() {
            _Receivedmessages.addAll(res);
          });
        });
      }
    if (MessageType == "2")
    {
      getSent().then((res) {
        _Sentdmessages = [];
        setState(() {
          _Sentdmessages.addAll(res);
        });
      });
    }
    if (MessageType == "3")
    {
      getDeleted().then((res) {
        _Deletedmessage = [];
        setState(() {

          _Deletedmessage.addAll(res);
        });
      });
    }
    if (MessageType == "4")
    {
      getUnread().then((res) {
        _UnreadMessage = [];
        setState(() {
          _UnreadMessage.addAll(res);
        });
      });
    }

  }

//  GetUserid() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//      struserid = prefs.getString('userid') ?? '';
//      fetchData();
//    });
//    print(struserid);
//  }
  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    Map userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();
      fetchData();
    });
    print("Print userdata in Side menu");
    print(userdata);

  }
  //Life cycle ------------------View initiate here
  void initState() {
    super.initState();
    GetUserdata();
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
  @override
  Widget build(BuildContext context) {




    Widget _MessageWidget()
    {
      if (MessageType == "1") {
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          itemCount: _Receivedmessages.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                print("click search");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => messaageDetail(StrUserType: User, Messagedetail: _Receivedmessages[index])));
              },
              title: Text(
                _Receivedmessages[index]['username'].toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Demi',
                    fontSize: 18),
              ),
              subtitle: Text(_Receivedmessages[index]['body'].toString(),
                  style: TextStyle(fontFamily: 'regular')),
              leading: CircleAvatar(
                radius: 24,
                child: ClipOval(
                  child: Image.asset("Assets/Images/userimage.png"),
                ),
              ),
              trailing: Container(
                  margin: EdgeInsets.only(top: 15.0),
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _Receivedmessages[index]['is_read'].toString() == "0"?
                      new Image.asset("Assets/Images/reddot.png"):Container(),
                      SizedBox(height: 5.0),
                      new Text(_Receivedmessages[index]['created_at'].toString().split(" ")[1],
                          style: TextStyle(fontFamily: 'regular')),
                    ],
                  )),
            );
          },
        );
      }
      if (MessageType == "2") {
   return ListView.separated(
     separatorBuilder: (context, index) => Divider(
       color: Colors.black,
     ),
     itemCount: _Sentdmessages.length,
     itemBuilder: (context, index) {
       return ListTile(
         onTap: () {
           print("click search");
           Navigator.push(context,
               MaterialPageRoute(builder: (context) => messaageDetail(StrUserType: User, Messagedetail: _Sentdmessages[index])));
         },
         title: Text(
           _Sentdmessages[index]['username'].toString(),
           style: TextStyle(
               color: Colors.black,
               fontFamily: 'Demi',
               fontSize: 18),
         ),
         subtitle: Text(_Sentdmessages[index]['body'].toString(),
             style: TextStyle(fontFamily: 'regular')),
         leading: CircleAvatar(
           radius: 24,
           child: ClipOval(
             child: Image.asset("Assets/Images/userimage.png"),
           ),
         ),
         trailing: Container(
             margin: EdgeInsets.only(top: 15.0),
             child: new Column(
               mainAxisSize: MainAxisSize.max,
               crossAxisAlignment: CrossAxisAlignment.end,
               children: <Widget>[
                 _Sentdmessages[index]['is_read'].toString() == "0"?
                 new Image.asset("Assets/Images/reddot.png"):Container(),
                 SizedBox(height: 5.0),
                 new Text(_Sentdmessages[index]['created_at'].toString().split(" ")[1],
                     style: TextStyle(fontFamily: 'regular')),
               ],
             )),
       );
     },
   );
      }
      if (MessageType == "3") {
return ListView.separated(
  separatorBuilder: (context, index) => Divider(
    color: Colors.black,
  ),
  itemCount: _Deletedmessage.length,
  itemBuilder: (context, index) {
    return ListTile(
      onTap: () {
        print("click search");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => messaageDetail(StrUserType: User, Messagedetail: _Deletedmessage[index])));
      },
      title: Text(
        _Deletedmessage[index]['username'].toString(),
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Demi',
            fontSize: 18),
      ),
      subtitle: Text(_Deletedmessage[index]['body'].toString(),
          style: TextStyle(fontFamily: 'regular')),
      leading: CircleAvatar(
        radius: 24,
        child: ClipOval(
          child: Image.asset("Assets/Images/userimage.png"),
        ),
      ),
      trailing: Container(
          margin: EdgeInsets.only(top: 15.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _Deletedmessage[index]['is_read'].toString() == "0"?
              new Image.asset("Assets/Images/reddot.png"):Container(),
              SizedBox(height: 5.0),
              new Text(_Deletedmessage[index]['created_at'].toString().split(" ")[1],
                  style: TextStyle(fontFamily: 'regular')),
            ],
          )),
    );
  },
);
      }
       if (MessageType == "4")
      {
return   ListView.separated(
  separatorBuilder: (context, index) => Divider(
    color: Colors.black,
  ),
  itemCount: _UnreadMessage.length,
  itemBuilder: (context, index) {
    return ListTile(
      onTap: () {
        print("click search");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => messaageDetail(StrUserType: User, Messagedetail: _UnreadMessage[index])));
      },
      title: Text(
        _UnreadMessage[index]['username'].toString(),
        style: TextStyle(
            color: Colors.black,
            fontFamily: 'Demi',
            fontSize: 18),
      ),
      subtitle: Text(_UnreadMessage[index]['body'].toString(),
          style: TextStyle(fontFamily: 'regular')),
      leading: CircleAvatar(
        radius: 24,
        child: ClipOval(
          child: Image.asset("Assets/Images/userimage.png"),
        ),
      ),
      trailing: Container(
          margin: EdgeInsets.only(top: 15.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _UnreadMessage[index]['is_read'].toString() == "0"?
              new Image.asset("Assets/Images/reddot.png"):Container(),
              SizedBox(height: 5.0),
              new Text(_UnreadMessage[index]['created_at'].toString().split(" ")[1],
                  style: TextStyle(fontFamily: 'regular')),
            ],
          )),
    );
  },
);
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("Mesaje", style: TextStyle(fontFamily: 'Demi'),textAlign: TextAlign.center),
        centerTitle: true,
        elevation: 0,

        actions: <Widget>[
          InkWell(
            child: new Image.asset('Assets/Images/EditMode.png'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ComposeMessage(StrUserType: User,strsenderemailid: "",)));

//
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => ChatMessage())
//              );
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      drawer: Drawer(
        child: SideMenu(StrUserType: User),
      ),
      body: ModalProgressHUD(inAsyncCall: _saving, child: DefaultTabController(
        length: 4,
        child: Column(
          children: <Widget>[
            Container(
// color: Appcolor.redHeader,
                alignment: Alignment.center,
                height: 80.0,
                decoration: new BoxDecoration(
                    color: Appcolor.redHeader,
                    border:
                    new Border.all(color: Appcolor.redHeader, width: 4.0),
                    borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(14),
                        bottomLeft: Radius.circular(14))),
                padding: EdgeInsets.all(15.0),
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      new BorderRadius.all(const Radius.circular(10.0))),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Cauta mesaj",
                        hintStyle: TextStyle(fontFamily: 'Demi'),
                        //  border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.white),
                  ),
                )),
            Container(
              constraints: BoxConstraints.expand(height: 45),
              child: TabBar(
                  onTap: (int inx){
                    print("selected index $inx");
                    if(inx == 0)
                    {
                      MessageType = "1";
                      fetchData();
                    }
                    else if (inx == 1)
                    {
                      MessageType = "2";
                      fetchData();
                    }
                    else if (inx == 1)
                    {
                      MessageType = "3";
                      fetchData();
                    }
                    else
                      {
                        MessageType = "4";
                        fetchData();
                      }
                  },

                  tabs: [
                Tab(
                    child: Text("Primite", //Inbox
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11.0,
                            fontFamily: 'Demi'))),
                Tab(
                    child: Text("Trimise",//Sent
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11.0,
                            fontFamily: 'Demi'))),
                Tab(
                    child: Text("Sterse",//deleted
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 11.0,
                            fontFamily: 'Demi'))),
                Tab(
                    child: Text("Necitite",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10.0,
                            fontFamily: 'Demi'))),


              ]),
            ),
            Expanded(
              child: _MessageWidget(),
            )
          ],
        ),
      ),),

    );
  }
}
