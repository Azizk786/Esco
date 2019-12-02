import 'package:flutter/material.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/Student/StudentCCAppointmentDetail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class CCAppointmentList extends StatelessWidget {
  String counsellorType;
  CCAppointmentList({Key key, @required this.counsellorType}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Booking(
      counsellorType: counsellorType,
    );
  }
}

class Booking extends StatefulWidget {
  String counsellorType;
  Booking({Key key, @required this.counsellorType}) : super(key: key);
  @override
  _BookingState createState() => _BookingState(counsellorType);
}

class _BookingState extends State<Booking> {
  String counsellorType;
  _BookingState(this.counsellorType);
  bool _saving = false;
  String struserid;
  // final UserType StrUserType;
  //CCAppointmentList({Key key, @required this.StrUserType}) : super(key: key);
  List _AppointmentList = new List();
  //API Call (Get history list)----------------------
  Future<List> getappointment() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetBookingList;
    final client = new http.Client();
    //,'user_id' : '120',
    final streamedRest = await client.post(url,
        body: {'type': counsellorType, 'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});

    print(streamedRest.body);
    if (streamedRest.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      int status = map["status"] as int;
      setState(() {
        _saving = false;
      });
      if (status != 200) {
        showMyDialog(context, map["message"].toString());
      }

      print("-----");
      print(map["listProgram"][0]["available_appointments"]);

      return map["listProgram"];
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
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
      } else if (streamedRest.statusCode == 999) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
      } else {
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        showMyDialog(context, map["romanMsg"].toString());
      }
    }
  }

  //Private method to get History list
  void fetchData() {
    getappointment().then((res) {
      setState(() {
        _AppointmentList.addAll(res);
      });
    });
  }

  GetUserdata() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Programare Consiliere"),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.notifications),
            onTap: () {
              print("click search");
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ModalProgressHUD(inAsyncCall: _saving, child: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Pentru a stabili o întâlnire cu "
                "unul dintre consilierii CCOC ai opțiunea de"
                " a ne contacta telefonic la unul din numerele"
                " 0264 401393; 0264 401394 (luni-vineri de la "
                "8:00 la 15:00) sau poți să îți faci mai jos o programare,"
                " fie pentru o întâlnire față în față, fie pentru o întâlnire"
                " video prin intermediul platformei. De asemenea, prin intermediul "
                "programărilor de mai jos poți solicita unui consilier la o dată și "
                "oră anume o discuție online, ce se va derula folosind funcția de Mesaje "
                "a platformei ESCOUNIV.", style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0 ,fontFamily: "Demi")),
            SizedBox(height: 15,),
            Text(
              "Lista disponibilitati",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22.0 ,fontFamily: "Demi"),
            ),
            SizedBox(height: 20,),
            appointmentsListRenderer(),
          ],
        ),
      ),),
      drawer: Drawer(
        child:SideMenu(StrUserType:UserType.Student),
      ),
    );

  }

  appointmentsListRenderer() {

    List<Column> list = new List<Column>();


    for(var index = 0; index < _AppointmentList.length; index++){
      list.add(new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            Text(
              counsellorType == "phy"?"Counsiliere psihologica"+ _AppointmentList[index]['username'].toString():"Consilier cariera"+" - "+_AppointmentList[index]['username'].toString(),
              textAlign: TextAlign.left,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0 ,fontFamily: "Demi" ),
            ),

            SizedBox(height:10),
            appointmentsGroupListRenderer(index)
          ]),);
    }

    return new Column(children: list);

  }

  appointmentsGroupListRenderer(int index) {

    List<Column> list = new List<Column>();


    for(var row = 0; row < _AppointmentList[index]["available_appointments"].length; row++) {
      list.add(new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Data:" +
                        _AppointmentList[index]["available_appointments"][row]['data']
                            .toString()
                            .split(' ')[0],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Ore disponibile:" +
                        _AppointmentList[index]["available_appointments"][row]['numarOre']
                            .toString(),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0),
                  ),

                  SizedBox(height: 5),
                ],
              ),
            ),
            Container(
              width: 85,
              child: OutlineButton(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          _AppointmentList[index]["available_appointments"][row]['book']
                              .toString() == "true" ? "Admis" :
                          "Rezerva",
                        )
                    )
                  ],
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
                textColor: Colors.green,
                onPressed: () {
                  if (_AppointmentList[index]["available_appointments"][row]['book']
                      .toString() == "false") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            studentAppointmentDetail(
                                AppointmentDetailmap: _AppointmentList[index]["available_appointments"][row])));
                  } else {
                    showMyDialog(context,
                        "ai rezervat deja un consilier pentru ziua respectivă");
                  }
                },
                //callback when button is clicked
                borderSide: BorderSide(
                  color: Colors.green, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 1, //width of the border
                ),
              ),
            ),
          ]
      ),
            SizedBox(height: 5),
            _AppointmentList[index]["available_appointments"].length - 1 > row ? Container(
          color: Colors.green,
          height: 1.0) : SizedBox(height: 1)]));
//

    }
    return new Column(children: list);

  }
  }
