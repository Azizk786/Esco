import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:escouniv/Dashboard.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/Student/CCAppointmentList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

enum SingingCharacter { lafayette, jefferson }

class studentAppointmentDetail extends StatefulWidget {
  Map AppointmentDetailmap;
  String counsellorType;
  //User Type dropdown -------------------------------------
  studentAppointmentDetail(
      {Key key,
      @required this.AppointmentDetailmap,
      @required this.counsellorType})
      : super(key: key);
  @override
  _studentAppointmentDetailState createState() =>
      _studentAppointmentDetailState(AppointmentDetailmap, counsellorType);
}

class _studentAppointmentDetailState extends State<studentAppointmentDetail> {
  Map AppointmentDetailmap;
  String struserid;
  bool _saving = false;
  Map userdata;
  int counter = 0;
  String counsellorType;
  List<String> _fTimeslot = List();
  List<String> _lTimeslot = List();
  SingingCharacter _character = SingingCharacter.lafayette;
  final topicDiscController = TextEditingController();
  final topicDetailController = TextEditingController();
  final notificationController = TextEditingController();
  final DeploymentController = TextEditingController();
  _studentAppointmentDetailState(
      this.AppointmentDetailmap, this.counsellorType);
  List<bool> _isSlotSelected = List();
  String currentvalue = "No";
  List<mediaType> _medias = mediaType.getUsers();
  List<DropdownMenuItem<mediaType>> _dropdownMenuItems;
  mediaType _selectedMedia;
  List<DropdownMenuItem<mediaType>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<mediaType>> items = List();
    for (mediaType user in _medias) {
      items.add(
        DropdownMenuItem(
          value: user,
          child: Text(user.name),
        ),
      );
    }
    return items;
  }

  GetUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();
    });
    print("Print userdata in Side menu");
    print(userdata);
  }

  void initState() {
    super.initState();
    GetUserdata();
    _dropdownMenuItems = buildDropdownMenuItems(_medias);
    _selectedMedia = _dropdownMenuItems[1].value;
    BackButtonInterceptor.add(myInterceptor);
    splitime(AppointmentDetailmap["oraInceput"].toString(),
        AppointmentDetailmap["oraSfarsit"].toString());
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

  splitime(String starttime, String EndTime) {
    var firstDate = DateTime.parse(starttime);
    var lastDate = DateTime.parse(EndTime);

    _fTimeslot = [];
    _lTimeslot = [];
    final difference = lastDate.difference(firstDate).inHours;
    String splittedtime = starttime;
    print("hour difference= $difference");
    for (int v = 0; v < difference; v++) {
      DateTime dfirst = firstDate.add(Duration(hours: v));
      DateTime dsecond = firstDate.add(Duration(hours: v + 1));
      _fTimeslot.add(dfirst.toString());
      _lTimeslot.add(dsecond.toString());
      // _isSlotSelected.add(true);
      print("fffffff=$_isSlotSelected");
    }
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

  onChangeDropdownItem(mediaType SelectedUser) {
    setState(() {
      _selectedMedia = SelectedUser;
    });
  }

  void bookAppointment() async {
    if (topicDiscController.text.length < 1) {
      showMyDialog(context, 'Introduceți subiectul');
      return null;
    } else if (topicDetailController.text.length < 1) {
      showMyDialog(context, 'Introduceți explicatii');
      return null;
    } else if (currentvalue == "No") {
      showMyDialog(context, 'Selectați intervalul orar');
      return null;
    } else {
      setState(() {
        _saving = true;
      });

      int indexx = _fTimeslot.indexOf(currentvalue);
      final String url = API.Base_url + API.BookAppointement;
      final client = new http.Client();
      Map _payload = {
        'user_id': struserid,
        'title': topicDiscController.text,
        'counsler_id': AppointmentDetailmap['user'],
        'meeting_type': _selectedMedia.id.toString(),
        'programId': AppointmentDetailmap['id'],
        'start_slot': _fTimeslot[indexx],
        'end_slot': _lTimeslot[indexx],
        'notesDetailed': topicDetailController.text
      };
      print("print paykoad with book pregram");
      final streamedRest = await client.post(url, body: _payload, headers: {
        'End-Client': 'escon',
        'Auth-Key': 'escon@2019'
      });

      print(streamedRest.body);

      if (streamedRest.statusCode == 200) {
        setState(() {
          _saving = false;
        });
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        int Status = map["status"] as int;

        print("----------response= $map");


        //>CCAppointmentList(counsellorType: 'carrier')

        if (Status == 200) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CCAppointmentList(counsellorType: counsellorType)));
//          Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) =>
//                      Dashboard(StrUserType: UserType.Student)));
          showMyDialog(context, map["message"].toString());
        } else {
          showMyDialog(context, map["message"].toString());
        }

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
        } else if (streamedRest.statusCode == 999) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
        } else {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _alreadyBooked() {
      if (AppointmentDetailmap['book'].toString() == "false") {
        return Container(
          child: OutlineButton(
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Rezerva",
                    ))
              ],
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            textColor: Colors.green,
            onPressed: () {
              bookAppointment();
            }, //callback when button is clicked
            borderSide: BorderSide(
              color: Colors.green, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 1, //width of the border
            ),
          ),
        );
      } else {
        return Container();
      }
    }
    Widget _RadiobuttonforTimeslots(int _inx) {
      return RadioListTile<String>(
        title: Text(_fTimeslot[_inx].split(' ')[1].toString().split(":")[0] +
            ":" +
            _fTimeslot[_inx].split(' ')[1].split(":")[1] +
            ' - ' +
            _lTimeslot[_inx].split(' ')[1].toString().split(":")[0] +
            ":" +
            _lTimeslot[_inx].split(' ')[1].split(":")[1]),
        value: _fTimeslot[_inx],
        groupValue: currentvalue,
        onChanged: (String value) {
          setState(() {
            currentvalue = value;
          });
        },
      );
//       child:  Radio(value: null, groupValue: null, onChanged: null)<bool>(
//
//
//
//         title: Text(_fTimeslot[_inx].split(' ')[1].toString().split(":")[0]+":"+_fTimeslot[_inx].split(' ')[1].split(":")[1] +' - '+ _lTimeslot[_inx].split(' ')[1].toString().split(":")[0] + ":" + _lTimeslot[_inx].split(' ')[1].split(":")[1]),
//          //value: currentvalue,
//         groupValue: _isSlotSelected[_inx],
//         onChanged: (bool value) {
//           setState(() {
//             _isSlotSelected.forEach((element) => element = false);
//             _isSlotSelected[_inx] = value;
//             currentvalue = value;
//             print("seleceted object va;lue = $_isSlotSelected");
//
//
//           });
//         },
//       ),
//     );
    }
    print("Selected object detail");
    print(AppointmentDetailmap);
    return Scaffold(
        appBar: AppBar(
          title: Text("Programare Consiliere"),
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
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20, left: 25, right: 25, bottom: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Data: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: 'Dami')),
//                Text(AppointmentDetailmap['data'].toString().split(' ')[0], style: TextStyle(
////                    color: Colors.black54,
////                    fontSize: 18.0 ,fontFamily: 'Dami')),
                    Text(AppointmentDetailmap['data'].toString().split(" ")[0],
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontFamily: 'Dami')),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Text("Consilier: ",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: 'Dami')),
                    Text(
                        AppointmentDetailmap['username'] +
                            ' - ' +
                            AppointmentDetailmap['tip'],
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontFamily: 'Dami')),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Text("Alegeti intervalul dorit.",
                    style: TextStyle(color: Colors.black54, fontSize: 16.0)),
                SizedBox(
                  height: 5,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _fTimeslot.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      child: _RadiobuttonforTimeslots(index),
                    );
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Subiect Discutie',
                    //   hintText: 'Discussion Subject'
                  ),
                  controller: topicDiscController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Explicatii Detaliate',
                      //hintText: 'Detailed Explanations ',
                      hintMaxLines: 5),
                  maxLines: 5,
                  controller: topicDetailController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Observatii',
                      //  hintText: 'Observations',
                      hintMaxLines: 5),
                  maxLines: 5,
                  controller: notificationController,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 55,
                  width: double.infinity,
                  child: DropdownButton(
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: Appcolor.redHeader),
                    value: _selectedMedia,
                    hint: Text('Selecteaza un tip '),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _alreadyBooked()
              ],
            ),
          ),
        ));
  }
}

class mediaType {
  int id;
  String name;
  mediaType(this.id, this.name);

  static List<mediaType> getUsers() {
    return <mediaType>[
      mediaType(3, 'Consiliere Video'),
      mediaType(1, 'Intalnire Directa'),
    ];
  }
}
