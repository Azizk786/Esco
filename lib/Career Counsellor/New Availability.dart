import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/Career Counsellor/CCAvailability.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
enum SingingCharacter { lafayette, jefferson }

class AddAvailability extends StatefulWidget {
  final UserType User;
  final Map forEdit;
  AddAvailability({Key key, @required this.User, @required this.forEdit}) : super(key: key);
  @override
  _AddAvailabilityState createState() => _AddAvailabilityState(User,forEdit);
}
class _AddAvailabilityState extends State<AddAvailability> {
  UserType User;
  final Map forEdit;
  _AddAvailabilityState(this. User,this.forEdit);
  SingingCharacter _character = SingingCharacter.lafayette;

  final _DateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final dateFormat = DateFormat("yyyy-MM-dd");
  final HourFormat = DateFormat("HH:mm");
  DateTime _Date;
  bool isChecked = false;
  bool isSaving = false;
  DateTime _StartTime;
  DateTime _EndTime;
  String struserid;
  @override
//  GetUserid() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    setState(() {
//      struserid = prefs.getString('userid') ?? '';
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
    });
    print("Print userdata in Side menu");
    print(userdata);

  }

  showMyDialog(BuildContext context, String strmsg)
  {
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
  //Life cycle ------------------View initiate here
  void initState() {
    super.initState();
    GetUserdata();
    BackButtonInterceptor.add(myInterceptor);
    if(forEdit != null)
      {
        setState(() {
          _StartTime = DateTime.parse(forEdit["oraInceput"].toString());
          _EndTime = DateTime.parse(forEdit["oraSfarsit"].toString());
          _DateController.text = forEdit["data"].toString().split(" ")[0];
          _startTimeController.text = forEdit["oraInceput"].toString().split(" ")[1].toString().split(":")[0]+":"+forEdit["oraInceput"].toString().split(" ")[1].toString().split(":")[1];
          _endTimeController.text = forEdit["oraSfarsit"].toString().split(" ")[1].toString().split(":")[0]+":"+forEdit["oraSfarsit"].toString().split(" ")[1].toString().split(":")[1];
          //Set values here
          isChecked =forEdit["recurent"].toString()=="1"?true:false;
        });
      }

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

  Future<bool> _addAvailability() async {


    final difference = _EndTime.difference(_StartTime).inHours;
    if (_Date == null) {
      showMyDialog(context, 'Selectați data');
      return false;
    }
    else if (_StartTime == null) {
      showMyDialog(context, 'Selectați ora de început');
      return false;
    }
    else  if (_EndTime == null) {
      showMyDialog(context, 'Selectați ora de încheiere');
      return false;
    }
//    else  if (difference <= 0) {
//      showMyDialog(context, 'Timpul de sfârșit este mai mare decât timpul de început');
//      return false;
//    }
    else {
      setState(() {
        isSaving = true;
      });
      String _usertype = "cariera";
      if (User == UserType.CCounsellor) {
        _usertype = "cariera";
      } else {
        _usertype = "phy";
      }
      String url;
      Map _payload;
      if(forEdit == null)
        {
          url = API.Base_url + API.AddAvailability;
          _payload = {'user_id': struserid,
            'eventdate': _Date.toString().split(".")[0],
            'start_date': _DateController.text +" " +_startTimeController.text,
            'end_date':_DateController.text +" " +_endTimeController.text,
            'duration': difference.toString(),
            'type': _usertype,
            'rec_event': isChecked == false?"0":"1",
          };
        }else
          {
            url = API.Base_url + API.EditAvailability;
            _payload = {'user_id': struserid,
              'eventdate': _Date.toString().split(".")[0],
              'start_date': _DateController.text +" " +_startTimeController.text,
              'end_date':_DateController.text +" " +_endTimeController.text,
              'duration': difference.toString(),
              'type': _usertype,
              'rec_event': isChecked == false?"0":"1",
              'id': forEdit["id"].toString()
            };
          }

      final client = new http.Client();


      print(_payload);
      final streamedRest = await client.post(url,
          body: _payload,
          headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});

      print(streamedRest.body);
      if (streamedRest.statusCode == 200) {
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        int Status = map["status"] as int;
        if (Status == 200) {
          setState(() {
            isSaving = false;
          });
          return true;
        } else {
          showMyDialog(context, map["message"].toString());
          return false;
        }
      } else {
        setState(() {
          isSaving = false;
        });
        if (streamedRest.statusCode == 400) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
        }
        else if (streamedRest.statusCode == 401) {
          showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
        }
        else if (streamedRest.statusCode == 500) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
        }
        else if (streamedRest.statusCode == 1001) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
        }
        else if (streamedRest.statusCode == 1005) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
        }
        else if (streamedRest.statusCode == 999) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
        }
        else {
          Map<dynamic, dynamic> map = json.decode(streamedRest.body);
          showMyDialog(context, map["romanMsg"].toString());
        }
        }
      }
  }

  Widget build(BuildContext context) {
    return ModalProgressHUD(inAsyncCall: isSaving, child: Scaffold(
        appBar: AppBar(
          title: Text("Adauga disponiobilitate"),
          elevation: 0,
          centerTitle: true,
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.notifications),
              onTap: () {
              },
            ),
            SizedBox(width: 20,)
          ],
        ),
        body:SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment:  MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Data"),
                  DateTimePickerFormField(format: dateFormat,firstDate:new DateTime.now() ,initialDate:new DateTime.now() ,controller:_DateController ,editable: false,dateOnly:true, onChanged: (date) {
                    setState(() {
                      _Date = date;
                    });
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text('$date'),));
                  }),
                ],
              ),
              SizedBox(height: 15,),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[
                    new Flexible(

                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Ora inceput"),
                            DateTimePickerFormField(format: HourFormat,controller: _startTimeController ,editable: false,inputType: InputType.time,firstDate:new DateTime.now() ,initialDate:new DateTime.now(), onChanged: (date) {
                              setState(() {
                              _StartTime = date;
                              });
                              Scaffold
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text('$date'),));


                            }),

                          ],
                        )
                    ),
                  ]
              ),
              SizedBox(height: 10,),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Flexible(
                        child: Column(

                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Ora sfarsit"),
                            DateTimePickerFormField(format: HourFormat,editable: false,inputType: InputType.time,
                                firstDate:new DateTime.now(),controller: _endTimeController ,initialTime: TimeOfDay(hour: 5, minute: 5), onChanged: (date) {
                              setState(() {
                               _EndTime = date;
                              });
                              Scaffold
                                  .of(context)
                                  .showSnackBar(SnackBar(content: Text('$date'),));


                            }),
                          ],
                        )
                    ),
//                    new Flexible(
//                      child: new TextFormField(
//                        decoration: InputDecoration(
//                          hintText: 'Ora sfarsit',
//                          labelText: '16',
//                          suffixIcon: const Icon(
//                            Icons.keyboard_arrow_down,
//                            color: Colors.red,
//                          ),
//                        ),
//                      ),
//                    ),

                  ]
              ),
              CheckboxListTile(
                title: Text("Disponibilitate recurenta"),
                value: isChecked,
                onChanged: (newValue) {  setState(()
                {
                  isChecked = newValue;
                }); },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
              SizedBox(height: 250,),
              Container(
                child:OutlineButton(
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          widthFactor: 4,
                          child: Text(forEdit != null? "Editați":"Salveaza"
                            //"Salveaza",
                          )
                      )
                    ],
                  ),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                  textColor: Colors.green,
                  onPressed: () {
                    _addAvailability().then((res) {
                      setState(() {
                       if (res == true)
                       {
                         Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => CCAvailability(User:User)));
                         showMyDialog(context, "Disponibilitatea a fost adăugată cu succes");
                       }
                      });
                    });
                  }, //callback when button is clicked
                  borderSide: BorderSide(
                    color: Colors.green, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 1, //width of the border
                  ),
                ),
              )
            ],
          ),
        )
    ));
  }
}


