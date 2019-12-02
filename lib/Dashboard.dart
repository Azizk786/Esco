import 'package:flutter/material.dart';
import 'package:escouniv/EVROMenu.dart';
import 'Constant/Constant.dart';
import 'package:escouniv/EVRORightMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:escouniv/Constant/Constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/Student/informationDetail.dart';
import 'package:escouniv/DashboardeventDetail.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/webrtc/call_sample/videoCallView.dart';
import 'package:escouniv/webrtc/call_sample/signaling.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:escouniv/webrtc/call_sample/call_sample.dart';

class Dashboard extends StatelessWidget {
  @override
  UserType  StrUserType;
  Dashboard({Key key, @required this.StrUserType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserDashboard(StrUserType: StrUserType);
  }
}


class UserDashboard extends StatefulWidget {

  UserType  StrUserType;
  UserDashboard({Key key, @required this.StrUserType}) : super(key: key);
  @override
  _UserDashboardState createState() => _UserDashboardState(StrUserType);

}

class _UserDashboardState extends State<UserDashboard> {

  List<dynamic> _peers;
  UserType StrUserType;
  Map userdata;
  _UserDashboardState(this.StrUserType);
  bool _saving = true;
  double _animatedHeight = 60.0;
  String StrArrow = 'Assets/Images/Compressarrow.png';
  double _animatedHeight1 = 60.0;
  String StrArrow1 = 'Assets/Images/Compressarrow.png';
  var overlayContext;

  @override
  //Life cycle ------------------View initiate here
  GetUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    struserid = userdata["userid"].toString();
    fetchData();
    print(userdata);

    //*> Intialize web socket connection
    initConnectionWithWebrtc(userdata);

  }

  initConnectionWithWebrtc(Map userdata) {

    Signaling signaling = new Signaling(API.WebrtcServerAddress, userdata["fullname"].toString(), userdata["userid"])
      ..connect();

    VideoCall videoCall= new VideoCall();

    signaling.onStateChange = (SignalingState state) {
      videoCall.onStateChanged(state);

      switch (state) {

        case SignalingState.CallStateNew:
        case SignalingState.CallStateBye:
          try {
            if(overlayContext != null)
            OverlaySupportEntry.of(overlayContext).dismiss();
          } catch (e) {
            print(e.toString());
          }
          break;
        case SignalingState.CallStateInvite:
        case SignalingState.CallStateConnected:
        case SignalingState.CallStateRinging:
          if(CallSample.cs == null || CallSample.cs.currentContext == null) {
            showVideoCallNotificaion();
          }
          break;
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
          try {
            if(overlayContext != null)
              OverlaySupportEntry.of(overlayContext).dismiss();
          } catch (e) {
            print(e.toString());
          }
        break;
        case SignalingState.ConnectionOpen:
          break;
      }


    };

    signaling.onPeersUpdate = ((event) {
      _peers = event['peers'];
      videoCall.onPeersUpdated(event);
    });

    signaling.onLocalStream = ((stream) {
      videoCall.onLocalStreamChanged(stream);
    });

    signaling.onAddRemoteStream = ((stream) {
      videoCall.onAddRemoteStreamChanged(stream);

    });

    signaling.onRemoveRemoteStream = ((stream) {
      videoCall.onRemoveRemoteStreamChanged(stream);
    });

  }

  showVideoCallNotificaion() {
    //get caller data

    String peerId = Signaling.peerId;


    String callerName = "";
    for(int i = 0; i< _peers.length; i++) {
      if(_peers[i]["id"] == peerId) {
        callerName = _peers[i]["name"];
      }
    }

    if(callerName == "") {
      return;
    }

    showOverlayNotification((context) {
      overlayContext =  context;
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: SafeArea(
          child: ListTile(
            leading: SizedBox.fromSize(
                size: const Size(40, 40),
                child: ClipOval(
                    child: Container(
                      color: Colors.black,
                    ))),
            title: Text('Escouniv'),
            subtitle: Text('$callerName is calling....'),
            trailing: IconButton(
                icon: Icon(Icons.call),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CallSample(ip: API.WebrtcServerAddress, displayName: userdata["fullname"].toString(), selfId: userdata["userid"], signaling: Signaling.getSignalingContext(), peerId: callerName != "" ? peerId : 0, isFromDashboard: true)));

                  OverlaySupportEntry.of(context).dismiss();

                }),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 15000));
  }

  SaveProfileData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Profiledata", json.encode(map));
  }
  Future getProfile() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetUserProfile;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print("-----------"+streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      SaveProfileData(map);
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

  void initState() {
    super.initState();
    GetUserdata();
    BackButtonInterceptor.add(myInterceptor);
  }

//
  @override
  deactivate() {
    super.deactivate();
    //if (Signaling.getSignalingContext() != null) Signaling.getSignalingContext().close();
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
        }
    );
  }

  List _EventList = new List();
  List _Notice = new List();

  String struserid;

  //API Call (Get history list)----------------------
  Future<Map> getdashboardData() async {
    final String url = API.Base_url + API.Dashboard;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});

    if(streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String status = map["status"].toString();
      return map;
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
//      else
//      {
//        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
//      }

    }
  }

  void fetchData() {

    getdashboardData().then((res) {
      setState(() {
        _EventList = res["eventList"];
        if(_EventList.length>0)
          {
            _animatedHeight = 200.0;
            StrArrow = 'Assets/Images/expandarrow.png';
          }
        _Notice = res["notices"];
        if(_Notice.length>0)
        {
          _animatedHeight1 = 280.0;
          StrArrow1 = 'Assets/Images/expandarrow.png';
        }
        print("Print event list");
        print(_EventList);
        _saving = false;
print(res);
      });
    });
    getProfile().then((res) {
      setState(() {
        print("response profile here = $res");
        _saving = false;
      });
    });
  }

  Widget forEventData()
  {
    if (_EventList.length<1) {
      return new Container(
        height: 40,
        alignment: Alignment.center,
        child: Text("Fără înregistrare disponibilă")
      );
    }else
      {
        return Container(
          height: _animatedHeight,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _EventList.length,
            separatorBuilder: (BuildContext context, int index) =>
                Divider(color: Colors.black38,),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => dashboardEventDetails(User: StrUserType, map: _EventList[index])));
                },
                child: Container(
                  height: 100.0,
                  child: new Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(right: 18.0,
                            top: 10.0,
                            left: 10.0,
                            bottom: 10.0),
                        child: Image.asset(
                            "Assets/Images/thumbnail_image.png"),
                      ),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(_EventList[index]["titlu"].toString(),
                            style: TextStyle(fontFamily: 'Demi'),),
                          new Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Image.asset(
                                      "Assets/Images/calender_black.png"),
                                  SizedBox(width: 10.0),
                                  new Text(_EventList[index]["data_inceput"].toString(), style:
                                  TextStyle(fontFamily: 'regular')),

                                ],
                              )
                          ),
                          new Container(
                              margin: const EdgeInsets.only(top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Image.asset(
                                      "Assets/Images/Watch_black.png"),
                                  SizedBox(width: 10.0),
                                  new Text(_EventList[index]["ora_inceput"].toString(), style:
                                  TextStyle(fontFamily: 'regular')),

                                ],
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
  }
  Widget forInformationData()
  {
    if (_Notice.length<1) {
      return new Container(
         // color: Appcolor.redHeader.withOpacity(0.95),
          height: 40,
          alignment: Alignment.center,
          child: Text("Fără înregistrare disponibilă")
      );
    }else
    {
      return  Container(
        height: _animatedHeight1,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _Notice.length,
          separatorBuilder: (BuildContext context, int index) =>
              Divider(),
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => informationDetails(StrUserType: StrUserType, map: _Notice[index])));
                },
              child: Container(
                margin: EdgeInsets.only(
                    left: 10, right: 10, bottom: 5, top: 5),
                //color: Colors.black54,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_Notice[index]["titlu"].toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontFamily: 'Demi')),
                          SizedBox(height: 5,),
                          Text(_Notice[index]["data_ultimei_modificari"].toString().split(" ")[0],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontFamily: 'regular')),
                          SizedBox(height: 10,),
                          Text(_Notice[index]["descriere"].toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontFamily: 'regular'), maxLines: 3,)
                        ],
                      ),
                    ),
                    //  Ink.image(image: ""),
                  ],
                ),
              )
            );
          },
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          primarySwatch: createMaterialColor(Appcolor.redHeader)
      ),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Panou Control', style:
          TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Demi')),
          elevation: 0,
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.notifications),
              onTap: () {
                print("click search");
                _scaffoldKey.currentState.openEndDrawer();
              },
            ),
            SizedBox(width: 20),

          ],
        ),

        body: ModalProgressHUD(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15),
                  // margin: EdgeInsets.only(top: 15,left: 15,right: 15),
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () =>
                            setState(() {
                              if (_EventList.length<1)
                              {
                                _animatedHeight = 40.0;
                                StrArrow = 'Assets/Images/Compressarrow.png';
                              }
                              else
                              {
                                _animatedHeight != 0.0
                                    ? _animatedHeight = 0.0
                                    : _animatedHeight = 200.0;
                                StrArrow != 'Assets/Images/Compressarrow.png'
                                    ? StrArrow = 'Assets/Images/Compressarrow.png'
                                    : StrArrow = 'Assets/Images/expandarrow.png';
                              }

                            }),
                        child: new Container(
                          color: Appcolor.redHeader.withOpacity(0.95),
                          height: 40,
                          child: Row(
                            //  crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  height: 24.0,
                                  width: 24.0,
                                  margin: EdgeInsets.only(left: 12),
                                  child:
                                  new Image.asset('Assets/Images/Vector.png')),
                              SizedBox(width: 10,),
                              Expanded(
                                //  margin: EdgeInsets.only(
                                    //  left: 0, top: 5),
                                  child: Text("Evenimente",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontFamily: 'dami'))),
                              Container(
                                  height: 24.0,
                                  width: 24.0,
                                  margin: EdgeInsets.only(right: 12),
                                  child: new Image.asset(StrArrow)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      forEventData(),
                    ],),),
                Container(
                  //margin: EdgeInsets.all(15),
                  margin: EdgeInsets.only(bottom: 15,left: 15,right: 15),
                  child: Column(
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () =>
                            setState(() {
                              if (_Notice.length<1)
                              {
                                _animatedHeight1 = 40.0;
                                StrArrow1 = 'Assets/Images/Compressarrow.png';
                              }
                              else
                              {
                                _animatedHeight1 != 0.0
                                    ? _animatedHeight1 = 0.0
                                    : _animatedHeight1 = 200.0;
                                StrArrow1 != 'Assets/Images/Compressarrow.png'
                                    ? StrArrow1 = 'Assets/Images/Compressarrow.png'
                                    : StrArrow1 = 'Assets/Images/expandarrow.png';
                              }
                            }),
                        child: new Container(
                          color: Appcolor.redHeader.withOpacity(0.95),
                          height: 40,
                          child: Row(
                            //  crossAxisAlignment: CrossAxisAlignment.baseline,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  height: 24.0,
                                  width: 24.0,
                                  margin: EdgeInsets.only(left: 12),
                                  child:
                                  new Image.asset(
                                      'Assets/Images/MenuBriefing.png')),
                              SizedBox(width: 10,),
                              Expanded(
                                 // margin: EdgeInsets.only(
                                      //left: 0, top: 5, right: 200),
                                  child: Text("Informari",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontFamily: 'dami'))),
                              Container(
                                  height: 24.0,
                                  width: 24.0,
                                  margin: EdgeInsets.only(right: 12),
                                  child: new Image.asset(StrArrow1)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      forInformationData()
                    ],
                  ),
                ),
              ],
            ),
          ),
            inAsyncCall: _saving
        ),
        drawer: new Drawer(
            child: SideMenu(StrUserType: StrUserType)
        ),
        endDrawer: new Drawer(
          child: RightDrawer(),
        ),
      ),
    );
  }



}

class _Section extends StatelessWidget {
  final String title;

  final List<Widget> children;

  const _Section({Key key, @required this.title, @required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 16),
          _Title(title: title),
          Wrap(spacing: 8, children: children),
        ],
      ),
    );
  }
}


class _Title extends StatelessWidget {
  final String title;

  const _Title({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, top: 10, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    );
  }
}

