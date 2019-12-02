import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:escouniv/AppointmentDetail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class studentAppointmentHistory extends StatefulWidget {
  @override
  final UserType User;
  studentAppointmentHistory({Key key, @required this.User}) : super(key: key);
  _studentAppointmentHistoryState createState() => _studentAppointmentHistoryState(User);
}


class _studentAppointmentHistoryState extends State<studentAppointmentHistory> {
  UserType User;

  List _Historys = new List();
  String struserid;
  bool _saving = false;
int counter = 0;
  _studentAppointmentHistoryState(this.User);
  @override
  //API Call (Get history list)----------------------
  Future<List> getHistory() async {
    final String url = API.Base_url + API.GetUserHistory;
    final client = new http.Client();
    String type;
    if (User == UserType.Student)
    {
      type = "student";
    }
    else
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
      dynamic Status = map["status"];
      if (Status != "200")
      {
        //
      }else
      {
        showMyDialog(context, map["message"].toString());
      }
      return map["programHistory"];
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
      setState(() {
        _Historys.addAll(res);
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
/*
if (statusDestinatar == 0 and dataInceputProgramare < date()){
	Expirata
}
elseif (statusInitiator ==  != 3 ){

	Accepted
}
else{
	Anulata de catre initiator

}
* */

  Widget AccordingToCurrentStatus(String Status, int Indexx, String Mode)
  {
    if (Status == "0") {
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
                                color: Colors.orange,
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

              },
              child: new Text(
                "Waiting",
                maxLines: 1,
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 16.0,
                    fontFamily: 'Demi'),
              ),
            )
          ],
        ),
      );
    }
  else  if (Status == "4")
    {
      return GestureDetector(
        onTap: (){

          print("Selectde detail = $_Historys[Indexx]");
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
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Appcolor.AppGreen, width: 1)),
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
                                color: Appcolor.AppGreen,
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
                    color: Colors.green,
                    fontSize: 16.0,
                    fontFamily: 'Demi'),
              ),
            )
          ],
        ),
      );
    }
    else  if (Status == "1")
    {
      return GestureDetector(
        onTap: (){

          print("Selectde detail = $_Historys[Indexx]");
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
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Appcolor.AppGreen, width: 1)),
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
                                color: Appcolor.AppGreen,
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
    else if (Status == "3")
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentDetail(
                            StrUserType: User)));
              },
              child: new Text(
                "Rejected",
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
//    else
//    {
//      return GestureDetector(
//        onTap: (){
////          Navigator.push(
////              context,
////              MaterialPageRoute(
////                  builder: (context) => AppointmentDetail(
////                    StrUserType: User,AppointmentDetailmap: _Historys[Indexx],)));
//        },
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Text(
//              _Historys[Indexx]['titlu'].toString(),
//              textAlign: TextAlign.left,
//              maxLines: 1,
//              style: TextStyle(
//                  color: Colors.black,
//                  fontSize: 16.0,
//                  fontFamily: 'Demi'),
//            ),
//
//            SizedBox(
//              height: 10,
//            ),
//            Text(
//              _Historys[Indexx]['descriere'].toString(),
//              textAlign: TextAlign.left,
////  maxLines: 1,
//              style: TextStyle(
//                  color: Colors.black38,
//                  fontSize: 16.0,
//                  fontFamily: 'regular'),
//            ),
//
//
//            SizedBox(
//              height: 10,
//            ),
//            Container(
//              height: 45,
//// color: Colors.black,
//              margin: EdgeInsets.only(left: 5, right: 5, top: 5),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text(
//                    _Historys[Indexx]['data']
//                        .toString()
//                        .split(" ")[0].toString(),
//                    maxLines: 1,
//                    style: TextStyle(
//                        color: Colors.black54,
//                        fontSize: 15.0,
//                        fontFamily: 'regular'),
//                  ),
//                  Text(
//                    _Historys[Indexx]['oraInceput']
//                        .toString()
//                        .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraInceput']
//                        .toString()
//                        .split(" ")[1].toString().split(":")[1]+" - "+_Historys[Indexx]['oraSfarsit']
//                        .toString()
//                        .split(" ")[1].toString().split(":")[0]+":"+_Historys[Indexx]['oraSfarsit']
//                        .toString()
//                        .split(" ")[1].toString().split(":")[1],
//                    maxLines: 1,
//                    style: TextStyle(
//                        color: Colors.black54,
//                        fontSize: 15.0,
//                        fontFamily: 'regular'),
//                  ),
//                  Container(
//                      width: 120,
//                      child: Row(
//                          mainAxisAlignment:
//                          MainAxisAlignment.center,
//                          children: <Widget>[
//                            Text(Mode == "1"?"Video":"Mesagerie",
//                              maxLines: 1,
//                              style: TextStyle(
//                                  color: Colors.black38,
//                                  fontSize: 16.0,
//                                  fontFamily: 'regular'),
//                            ),
//
//
//                            SizedBox(
//                              width: 5,
//                            ),
//                            Container(
//                              alignment: Alignment.centerRight,
//                              child: Icon(Mode == "1"?Icons.videocam:Icons.chat,
//                                color: Colors.brown,
//                              ),
//                            )
//                          ]))
//                ],
//              ),
//            ),
//            SizedBox(
//              height: 5,
//            ),
//            new GestureDetector(
//              //Message selection from side drawer-------------------------------
//              onTap: () {
////                Navigator.push(
////                    context,
////                    MaterialPageRoute(
////                        builder: (context) => AppointmentDetail(
////                            StrUserType: UserType.Pupil)));
//              },
//              child: new Text(
//                "Expirat",
//                maxLines: 1,
//                style: TextStyle(
//                    color: Colors.brown,
//                    fontSize: 16.0,
//                    fontFamily: 'Demi'),
//              ),
//            )
//          ],
//        ),
//      );
//    }
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
      body: Container(
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
                  return AccordingToCurrentStatus(_Historys[index]['status_destinatar'].toString(),index,_Historys[index]['mod_desfasurare'].toString());
                },
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: SideMenu(StrUserType: User),
      ),
    );
  }
}
