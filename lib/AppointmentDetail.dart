import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/webrtc/call_sample/call_sample.dart';
import 'package:escouniv/EVROChat.dart';
import 'package:escouniv/VideoChat.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/webrtc/call_sample/signaling.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:escouniv/Psychological Counselor/PCounsellorAppointmentHistory.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';


class AppointmentDetail extends StatefulWidget {
  @override
  UserType StrUserType;
  Map AppointmentDetailmap;

  AppointmentDetail({Key key, @required this.AppointmentDetailmap,@required this.StrUserType}) : super(key: key);
  _AppointmentDetailState createState() => _AppointmentDetailState(AppointmentDetailmap,StrUserType);
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  UserType StrUserType;
  Map userdata;
  Map AppointmentDetailmap;
String status;
  String struserid;
  bool _saving = false;
_AppointmentDetailState(this.AppointmentDetailmap, this.StrUserType);

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
  @override

  GetUserdata() async
  {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
       userdata    = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();
    });
    print("Print userdata in Side menu");
    print(userdata);

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
      setState(() {
        _saving = false;
      });
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PCAppointmentHistory(User: StrUserType)));
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
        showMyDialog(context, map["message"].toString());
      //  showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
      }
    }

  }
    Widget _CommunicationMode(String _mode)
    {
      if (_mode == "3")
        {
          return  FlatButton(onPressed: (){
         //   showMyDialog(context, "In dezvoltare");

            if (StrUserType == UserType.Pupil || StrUserType == UserType.Student)
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        CallSample(ip: API.WebrtcServerAddress, displayName: userdata["fullname"].toString(),
                            selfId: AppointmentDetailmap["initiator"], signaling: Signaling.getSignalingContext(),
                            peerId: AppointmentDetailmap["destinatar"], isFromDashboard: false)));

              }
            else
              {


                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CallSample(ip: API.WebrtcServerAddress,
                        displayName: userdata["fullname"].toString(), selfId: AppointmentDetailmap["destinatar"],
                        signaling: Signaling.getSignalingContext(), peerId: AppointmentDetailmap["initiator"], isFromDashboard: false)));

              }

          print(AppointmentDetailmap["destinatar"]);

          }, child: Container(
              height: 55,
              width: 120,
              decoration: new BoxDecoration(borderRadius:
              BorderRadius.circular(10.0),border: Border.all(color: Appcolor.AppGreen,width: 1)
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    Text(
                      "Incepe",
                      maxLines: 1,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 20.0, fontFamily: 'demi' ),
                    ),
                    SizedBox(width: 5,),
                    Icon(AppointmentDetailmap['mod_desfasurare'].toString() == "3"?Icons.videocam:Icons.chat,color: Appcolor.AppGreen,)
                  ]
              )
          ),);
        }
      else
        {
          return Container();
        }

    }

  void initState() {
    super.initState();
    GetUserdata();



   setState(() {
     print("Selected object detail");
     print(AppointmentDetailmap);
     if (AppointmentDetailmap["status_destinatar"].toString() == "0")
       {
         status = "Așteptând acceptarea";
       }
    else if (AppointmentDetailmap["status_destinatar"].toString() == "4")
     {
       status = "Expirat";
     }
     else if (AppointmentDetailmap["status_destinatar"].toString() == "3" || AppointmentDetailmap["status_destinatar"].toString() == "3")
     {
       status = "respins";
     }
     else if (AppointmentDetailmap["status_destinatar"].toString() == "1")
     {
       status = "Continua";
     }

   });

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Detalii despre program"),
        centerTitle: true,
      ),
      body: ModalProgressHUD(inAsyncCall: _saving, child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
            //  alignment: Alignment.center,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 40,
                  ),
                  Text("Destinatar:",
                      style: TextStyle(
                          fontFamily: 'demi',
                          color: Colors.black,
                          fontSize: 20)),
                  Text(AppointmentDetailmap["firstname"]+AppointmentDetailmap["lastname"],
                      style: TextStyle(
                          fontFamily: 'regular',
                          color: Colors.black87,
                          fontSize: 18)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Subiect Discutie:",
                      style: TextStyle(
                          fontFamily: 'demi',
                          color: Colors.black,
                          fontSize: 20)),
                  Text(AppointmentDetailmap["titlu"],
                      style: TextStyle(
                          fontFamily: 'regular',
                          color: Colors.black87,
                          fontSize: 18)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Data:",
                      style: TextStyle(
                          fontFamily: 'demi',
                          color: Colors.black,
                          fontSize: 20)),
                  Text(AppointmentDetailmap["data"],
                      style: TextStyle(
                          fontFamily: 'regular',
                          color: Colors.black87,
                          fontSize: 18)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Interval:",
                      style: TextStyle(
                          fontFamily: 'demi',
                          color: Colors.black,
                          fontSize: 20)),
                  Text(
                    AppointmentDetailmap['data_inceput_programare']
                        .toString()
                        .split(' ')[1] +
                        "-" +
                        AppointmentDetailmap['data_adaugarii']
                            .toString()
                            .split(' ')[1],
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16.0,
                        fontFamily: 'regular'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Explicatii Detaliate:",
                      style: TextStyle(
                          fontFamily: 'demi',
                          color: Colors.black,
                          fontSize: 20)),
                  Text(AppointmentDetailmap['descriere'],
                      style: TextStyle(
                          fontFamily: 'regular',
                          color: Colors.black87,
                          fontSize: 18)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Mod desfasurare:",
                      style: TextStyle(
                          fontFamily: 'demi',
                          color: Colors.black,
                          fontSize: 20)),
                  Text(AppointmentDetailmap['mod_desfasurare'].toString() == "3"? "Consiliere Video":"Intalnire Directa",
                      style: TextStyle(
                          fontFamily: 'regular',
                          color: Colors.black87,
                          fontSize: 18)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Stare:",
                      style: TextStyle(
                          fontFamily: 'demi',
                          color: Colors.black,
                          fontSize: 20)),
                  Text(status,
                      style: TextStyle(
                          fontFamily: 'regular',
                          color: Colors.black87,
                          fontSize: 18)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Observatii:",
                      style: TextStyle(
                          fontFamily: 'demi',
                          color: Colors.black,
                          fontSize: 20)),
                  Text(AppointmentDetailmap['observatii_initiator'] == null ? "-" : AppointmentDetailmap['observatii_initiator'],
                      style: TextStyle(
                          fontFamily: 'regular',
                          color: Colors.black87,
                          fontSize: 18)),
                  SizedBox(
                    height: 30,
                  ),
                  aGreyHorizonalLine,
                  SizedBox(
                    height: 20,
                  ),
                  status == "Continua"? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[


                      FlatButton(onPressed: (){

                        if (AppointmentDetailmap['mod_desfasurare'].toString() == "3")
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CallSample(ip: null, displayName: null, selfId: null, signaling: null, peerId: null, isFromDashboard: null)));
                        }
                        else
                        {

                          if (StrUserType == UserType.Pupil || StrUserType == UserType.Student)
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChatMessage(User: StrUserType, Senderid: AppointmentDetailmap['destinatar'].toString())));
//

                          }
                          else
                          {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChatMessage(User: StrUserType, Senderid: AppointmentDetailmap['initiator'].toString())));

                          }

                        }

                      }, child:Container(
                          height: 55,
                          width: 120,
                          decoration: new BoxDecoration(borderRadius:
                          BorderRadius.circular(10.0),border: Border.all(color: Appcolor.AppGreen,width: 1)
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: <Widget>[
                                Text(AppointmentDetailmap['mod_desfasurare'].toString() == "3"?AppointmentDetailmap['video_duration']
                                    .toString() +
                                    ".00":"Incepe",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Appcolor.AppGreen,
                                      fontSize: 20.0, fontFamily: 'demi' ),
                                ),
                                SizedBox(width: 5,),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(AppointmentDetailmap['mod_desfasurare'].toString() == "3"?Icons.videocam:Icons.chat,color: Colors.green,),
                                )
                              ]
                          )
                      ),),

                      FlatButton(onPressed: (){
                        _rejectAppointment(AppointmentDetailmap);
                      }, child: Container(
                          height: 55,
                          width: 120,

                          decoration: new BoxDecoration(borderRadius:
                          BorderRadius.circular(10.0),color: Appcolor.redHeader
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: <Widget>[
                                Text(
                                  "Anulare",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0, fontFamily: 'demi' ),
                                ),
                              ]
                          )
                      ),),
                    ],
                  ):Container(),
                  SizedBox(
                    height: 20,
                  ),

                  status == "Continua" ? _CommunicationMode(AppointmentDetailmap['mod_desfasurare'].toString()):Container()


                ]),
          ))));
  }
}

//Mode == "1"?Icons.videocam:Icons.chat