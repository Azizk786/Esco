import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:escouniv/AppointmentDetail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class PCAppointmentHistory extends StatefulWidget {
  @override
  final UserType User;
  PCAppointmentHistory({Key key, @required this.User}) : super(key: key);
  _PCAppointmentHistoryState createState() => _PCAppointmentHistoryState(User);
}


class _PCAppointmentHistoryState extends State<PCAppointmentHistory> {
  UserType User;

  List _Historys = new List();
  String struserid;
  int counter = 0;
  bool _saving = false;
  _PCAppointmentHistoryState(this.User);
  @override


  //API Call (Get history list)----------------------
  Future<List> getHistory() async {
    setState(() {
      _saving = true;
      });
    final String url = API.Base_url + API.GetUserHistory;
    final client = new http.Client();
    String type;
    if (User == UserType.Student)
      {
        type = "student";
      }else
        {
          type = "counsler";
        }
    final streamedRest = await client.post(url,
        body: {'user_id': struserid,'type': type},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
      {
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        setState(() {
          _saving = false;
        });
        return map["programHistory"];
      }
    else if(streamedRest.statusCode == 201)
      {
        setState(() {
          _saving = false;
        });
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        dynamic Status = map["status"];
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
          Map<dynamic, dynamic> map = json.decode(streamedRest.body);
          showMyDialog(context, map["romanMsg"].toString());
        }
      }

  }
  Future _acceptAppointment(Map _data) async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.AcceptBooking;
    final client = new http.Client();

    final streamedRest = await client.post(url,
        body: {'user_id': struserid,'programe_id': _data["id"]},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      dynamic Status = map["status"];
      getHistory().then((res) {
        _Historys = [];
        setState(() {
          _Historys.addAll(res);
          _saving = false;
        });
      });
      showMyDialog(context, map["message"].toString());
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
  Future _rejectAppointment(Map _data) async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.CancelBooking;
    final client = new http.Client();

    final streamedRest = await client.post(url,
        body: {'user_id': struserid,'programe_id': _data["id"]},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      dynamic Status = map["status"];
      getHistory().then((res) {
        _Historys = [];
        setState(() {
          _Historys.addAll(res);
          _saving = false;
        });
      });
      showMyDialog(context, map["message"].toString());
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
  void fetchData() {
    getHistory().then((res) {
      _Historys = [];
      setState(() {
        _Historys.addAll(res);
        _saving = false;
      });
    });
  }

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

  Widget _forAcceptReject(Map _data)
  {
    return Container(child: Row(
      children: <Widget>[
        OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Accept",
                  )
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.green,
          onPressed: () {
             _acceptAppointment(_data);

          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.green, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        ),
        SizedBox(width: 10,),
        OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Ignora",
                  )
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.red,
          onPressed: () {
            _rejectAppointment(_data);
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )
      ],
    ),);
  }

  Widget AccordingToCurrentStatus(String Status, int Indexx, String Mode, Map _data)
  {
    if (_data["status_destinatar"].toString() == "0")// check date)
        {
      return GestureDetector(
        onTap: (){
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => AppointmentDetail(
//                    StrUserType: User,AppointmentDetailmap: _Historys[Indexx],)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _Historys[Indexx]['titlu'].toString(),
              textAlign: TextAlign.left,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontFamily: 'Demi'),
            ),

            SizedBox(
              height: 10,
            ),
            Text(
              _Historys[Indexx]['descriere'].toString(),
              textAlign: TextAlign.left,
//  maxLines: 1,
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 16.0,
                  fontFamily: 'regular'),
            ),


            SizedBox(
              height: 10,
            ),
            Container(
              height: 45,
// color: Colors.black,
              margin: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _Historys[Indexx]['data']
                        .toString()
                        .split(" ")[0].toString(),
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontFamily: 'regular'),
                  ),
                  Text(
                    _Historys[Indexx]['oraInceput']
                        .toString()
                        .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraInceput']
                        .toString()
                        .split(" ")[1].toString().split(":")[1]+" - "+_Historys[Indexx]['oraSfarsit']
                        .toString()
                        .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraSfarsit']
                        .toString()
                        .split(" ")[1].toString().split(":")[1],
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.0,
                        fontFamily: 'regular'),
                  ),
                  Container(
                      width: 120,
                      child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: <Widget>[
                            Text(Mode == "3"?"Video":"Mesagerie",
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 16.0,
                                  fontFamily: 'regular'),
                            ),


                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Icon(Mode == "3"?Icons.videocam:Icons.chat,
                                color: Colors.brown,
                              ),
                            )
                          ]))
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            _forAcceptReject(_Historys[Indexx])
          ],
        ),
      );
    }
    else if (_data["status_destinatar"].toString() == "4")// check date)
  {
    return GestureDetector(
      onTap: (){
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => AppointmentDetail(
//                    StrUserType: User,AppointmentDetailmap: _Historys[Indexx],)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _Historys[Indexx]['titlu'].toString(),
            textAlign: TextAlign.left,
            maxLines: 1,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: 'Demi'),
          ),

          SizedBox(
            height: 10,
          ),
          Text(
            _Historys[Indexx]['descriere'].toString(),
            textAlign: TextAlign.left,
//  maxLines: 1,
            style: TextStyle(
                color: Colors.black38,
                fontSize: 16.0,
                fontFamily: 'regular'),
          ),


          SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
// color: Colors.black,
            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _Historys[Indexx]['data']
                      .toString()
                      .split(" ")[0].toString(),
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                      fontFamily: 'regular'),
                ),
                Text(
                  _Historys[Indexx]['oraInceput']
                      .toString()
                      .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraInceput']
                      .toString()
                      .split(" ")[1].toString().split(":")[1]+" - "+_Historys[Indexx]['oraSfarsit']
                      .toString()
                      .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraSfarsit']
                      .toString()
                      .split(" ")[1].toString().split(":")[1],
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                      fontFamily: 'regular'),
                ),
                Container(
                    width: 120,
                    child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Text(Mode == "3"?"Video":"Mesagerie",
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16.0,
                                fontFamily: 'regular'),
                          ),


                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Icon(Mode == "3"?Icons.videocam:Icons.chat,
                              color: Colors.brown,
                            ),
                          )
                        ]))
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          new GestureDetector(
            //Message selection from side drawer-------------------------------
            onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AppointmentDetail(
//                            StrUserType: UserType.Pupil)));
            },
            child: new Text(
              "Expired",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 16.0,
                  fontFamily: 'Demi'),
            ),
          )
        ],
      ),
    );
  }
else if (_data["status_destinatar"].toString() == "1")// check date)
    {
  return GestureDetector(
    onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AppointmentDetail(
                StrUserType: User,AppointmentDetailmap: _Historys[Indexx],)));
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _Historys[Indexx]['titlu'].toString(),
          textAlign: TextAlign.left,
          maxLines: 1,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: 'Demi'),
        ),

        SizedBox(
          height: 10,
        ),
        Text(
          _Historys[Indexx]['descriere'].toString(),
          textAlign: TextAlign.left,
//  maxLines: 1,
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16.0,
              fontFamily: 'regular'),
        ),


        SizedBox(
          height: 10,
        ),
        Container(
          height: 45,
// color: Colors.black,
          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _Historys[Indexx]['data']
                    .toString()
                    .split(" ")[0].toString(),
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15.0,
                    fontFamily: 'regular'),
              ),
              Text(
                _Historys[Indexx]['oraInceput']
                    .toString()
                    .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraInceput']
                    .toString()
                    .split(" ")[1].toString().split(":")[1]+" - "+_Historys[Indexx]['oraSfarsit']
                    .toString()
                    .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraSfarsit']
                    .toString()
                    .split(" ")[1].toString().split(":")[1],
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15.0,
                    fontFamily: 'regular'),
              ),
              Container(
                  width: 120,
                  child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        Text(Mode == "3"?"Video":"Mesagerie",
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                        ),


                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Icon(Mode == "3"?Icons.videocam:Icons.chat,
                            color: Colors.green,
                          ),
                        )
                      ]))
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        new GestureDetector(
          //Message selection from side drawer-------------------------------
          onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AppointmentDetail(
//                            StrUserType: UserType.Pupil)));
          },
          child: new Text(
            "Continua",
            maxLines: 1,
            style: TextStyle(
                color: Colors.green,
                fontSize: 16.0,
                fontFamily: 'Demi'),
          ),
        )
      ],
    ),
  );
}
else if (_data["status_destinatar"].toString() == "3" || _data["status_destinatar"].toString() == "2")
  {
    return GestureDetector(
      onTap: (){
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => AppointmentDetail(
//                    StrUserType: User,AppointmentDetailmap: _Historys[Indexx],)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _Historys[Indexx]['titlu'].toString(),
            textAlign: TextAlign.left,
            maxLines: 1,
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontFamily: 'Demi'),
          ),

          SizedBox(
            height: 10,
          ),
          Text(
            _Historys[Indexx]['descriere'].toString(),
            textAlign: TextAlign.left,
//  maxLines: 1,
            style: TextStyle(
                color: Colors.black38,
                fontSize: 16.0,
                fontFamily: 'regular'),
          ),


          SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
// color: Colors.black,
            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _Historys[Indexx]['data']
                      .toString()
                      .split(" ")[0].toString(),
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                      fontFamily: 'regular'),
                ),
                Text(
                  _Historys[Indexx]['oraInceput']
                      .toString()
                      .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraInceput']
                      .toString()
                      .split(" ")[1].toString().split(":")[1]+" - "+_Historys[Indexx]['oraSfarsit']
                      .toString()
                      .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraSfarsit']
                      .toString()
                      .split(" ")[1].toString().split(":")[1],
                  maxLines: 1,
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15.0,
                      fontFamily: 'regular'),
                ),
                Container(
                    width: 120,
                    child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Text(Mode == "3"?"Video":"Mesagerie",
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: 16.0,
                                fontFamily: 'regular'),
                          ),


                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Icon(Mode == "3"?Icons.videocam:Icons.chat,
                              color: Colors.red,
                            ),
                          )
                        ]))
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          new GestureDetector(
            //Message selection from side drawer-------------------------------
            onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AppointmentDetail(
//                            StrUserType: UserType.Pupil)));
            },
            child: new Text(
              "Ignorat",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 16.0,
                  fontFamily: 'Demi'),
            ),
          )
        ],
      ),
    );
  }
else {
  return GestureDetector(
    onTap: (){
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => AppointmentDetail(
//                    StrUserType: User,AppointmentDetailmap: _Historys[Indexx],)));
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          _Historys[Indexx]['titlu'].toString(),
          textAlign: TextAlign.left,
          maxLines: 1,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: 'Demi'),
        ),

        SizedBox(
          height: 10,
        ),
        Text(
          _Historys[Indexx]['descriere'].toString(),
          textAlign: TextAlign.left,
//  maxLines: 1,
          style: TextStyle(
              color: Colors.black38,
              fontSize: 16.0,
              fontFamily: 'regular'),
        ),


        SizedBox(
          height: 10,
        ),
        Container(
          height: 45,
// color: Colors.black,
          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _Historys[Indexx]['data']
                    .toString()
                    .split(" ")[0].toString(),
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15.0,
                    fontFamily: 'regular'),
              ),
              Text(
                _Historys[Indexx]['oraInceput']
                    .toString()
                    .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraInceput']
                    .toString()
                    .split(" ")[1].toString().split(":")[1]+" - "+_Historys[Indexx]['oraSfarsit']
                    .toString()
                    .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraSfarsit']
                    .toString()
                    .split(" ")[1].toString().split(":")[1],
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 15.0,
                    fontFamily: 'regular'),
              ),
              Container(
                  width: 120,
                  child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: <Widget>[
                        Text(Mode == "1"?"Video":"Mesagerie",
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                        ),


                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Icon(Mode == "3"?Icons.videocam:Icons.chat,
                            color: Colors.brown,
                          ),
                        )
                      ]))
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        new GestureDetector(
          //Message selection from side drawer-------------------------------
          onTap: () {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => AppointmentDetail(
//                            StrUserType: UserType.Pupil)));
          },
          child: new Text(
            "Expired",
            maxLines: 1,
            style: TextStyle(
                color: Colors.brown,
                fontSize: 16.0,
                fontFamily: 'Demi'),
          ),
        )
      ],
    ),
  );
}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Istoric Programari",
          style: TextStyle(fontFamily: 'Demi'),
        ),
          centerTitle: true,
        elevation: 0,
          actions: <Widget>[
            new Stack(
              children: <Widget>[
                new IconButton(icon: Icon(Icons.notifications), onPressed: () {
                  setState(() {
                    counter = 0;
                  });
                }),
                counter != 0 ? new Positioned(
                  right: 11,
                  top: 11,
                  child: new Container(

                    padding: EdgeInsets.all(2),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '$counter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ) : new Container()
              ],
            ),
            SizedBox(width: 20),
      ]),
      body: ModalProgressHUD(inAsyncCall: _saving, child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _Historys.length,
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(color: Colors.black38,),
                itemBuilder: (context, index) {
                  return AccordingToCurrentStatus(_Historys[index]['status_destinatar'].toString(),index,_Historys[index]['mod_desfasurare'].toString(),_Historys[index]);
                },
              ),
            ),
          ],
        ),
      ),),
      drawer: Drawer(
        child: SideMenu(StrUserType: User),
      ),
    );
  }
}
