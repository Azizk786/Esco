import 'package:flutter/material.dart';
import 'package:escouniv/CVCompletion/CVCompletion_3.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:escouniv/HelperClass/DataCollected.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class CVCompletion_2 extends StatefulWidget {
  @override
  UserType  StrUserType;
  CVCompletion_2({Key key, @required this.StrUserType}) : super(key: key);
  _CVCompletion_2State createState() => _CVCompletion_2State(StrUserType);
}

class _CVCompletion_2State extends State<CVCompletion_2> {

  UserType  StrUserType;
  String struserid;
  bool _saving = false;
  Map userdata;
  Map _cv13;
  Map _cv12;
  Map _cv11;
  Map _cv10;
  Map _cv1;
  Map _cv2;
  Map _cv3;
  Map _cv4;
  Map _cv5;
  Map _cv6;
  Map _cv7;
  Map _cv8;
  Map _cv9;

  //Textfield controller-----------------------------------
  final _Tipul_aplicatiei = TextEditingController();
  final _Descriere = TextEditingController();
  _CVCompletion_2State(this.StrUserType);

  List<String> _users = ["Locul de munca pentru care se candideaza","Pozitia","Locul de munca dorit","Studiile pentru care se candideaza","Profilul personal"];

  String strselected;

  //API Call-----------------------------------------

  Future<bool> _apiToAddCV() async {

    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.saveCV;
    final client = new http.Client();
    Map<String,String> _finalPayload = {
      "informatii_personale":json.encode(_cv1),
      "tip_aplicatie":json.encode(_cv2),
      "experienta_profesionala":json.encode(_cv3),
      "educatie_formare":json.encode(_cv4),
      "limba_materna":json.encode(_cv5),
      "limbi_straine":json.encode(_cv6),
      "competente_comunicare":json.encode(_cv7),
      "competente_manageriale":json.encode(_cv8),
      "competente_loc_de_munca":json.encode(_cv9),
      "competente_digitale":json.encode(_cv10),
      "alte_competente":json.encode(_cv11),
      "permis_conducere":json.encode(_cv12),
      "informatii_suplimentare":json.encode(_cv13),
      "user_id":struserid};

    final streamedRest = await client.post(url,
        body: _finalPayload,
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    setState(() {
      _saving = false;
    });
    if(streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
      return true;
    } else if(streamedRest.statusCode == 201) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
    }
    else {
      setState(() {
        _saving = false;
      });
      if (streamedRest.statusCode == 400)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
        return false;
      }
      else if (streamedRest.statusCode == 401)
      {
        showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
        return false;
      }
      else if (streamedRest.statusCode == 500)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
        return false;
      }
      else if (streamedRest.statusCode == 1001)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
        return false;
      }
      else if (streamedRest.statusCode == 1005)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
        return false;
      }
      else if (streamedRest.statusCode == 999)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
        return false;
      }
      else
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
        return false;
      }
    }
  }
  Future<bool> __apiToCorrectCV() async {

    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.CorrectCVRquest;
    final client = new http.Client();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVData') ?? '';
    Map _Correctiondata = json.decode(myString);

    Map<String,dynamic> dd = {
      "informatii_personale":_cv1,
      "tip_aplicatie":_cv2,
      "experienta_profesionala":_cv3,
      "educatie_formare":_cv4,
      "limba_materna":_cv5,
      "limbi_straine":_cv6,
      "competente_comunicare":_cv7,
      "competente_manageriale":_cv8,
      "competente_loc_de_munca":_cv9,
      "competente_digitale":_cv10,
      "alte_competente":_cv11,
      "permis_conducere":_cv12,
      "informatii_suplimentare":_cv13,
    };

    Map<String,dynamic> _finalPayload = {"new_data":json.encode(dd),"user_id":struserid,"onlinecv_id":_Correctiondata["cv_online_id"] };

    final streamedRest = await client.post(url,
        body: _finalPayload,
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.statusCode);
    setState(() {
      _saving = false;
    });
    if(streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
      return true;
    }
    else if(streamedRest.statusCode == 201) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
      return false;
    }
    else {
      setState(() {
        _saving = false;
      });
      if (streamedRest.statusCode == 400)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
        return false;
      }
      else if (streamedRest.statusCode == 401)
      {
        showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
        return false;
      }
      else if (streamedRest.statusCode == 500)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
        return false;
      }
      else if (streamedRest.statusCode == 1001)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
        return false;
      }
      else if (streamedRest.statusCode == 1005)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
        return false;
      }
      else if (streamedRest.statusCode == 999)
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
        return false;
      }
      else
      {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
        return false;
      }
    }
  }

  SaveCreerPlan_PersonalInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CV2", json.encode(_cv2));
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



  Future<Null> FetchCVData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final str_personelInfo = prefs.getString('CV1') ?? '';
      _cv1 = json.decode(str_personelInfo);
      //2---------
      final str_puncte_tari = prefs.getString('CV2') ?? '';
      _cv2 = json.decode(str_puncte_tari);
      //3------------------
      final str_CPPuncteSlabe = prefs.getString('CV3') ?? '';
      _cv3 = json.decode(str_CPPuncteSlabe);
      //4--------------------
      final str_CPoportunitati = prefs.getString('CV4') ?? '';
      _cv4 = json.decode(str_CPoportunitati);
      //5--------------------
      final str_CPCPAmenintari = prefs.getString('CV5') ?? '';
      _cv5 = json.decode(str_CPCPAmenintari);
      //6--------------------
      final str_CPAutocunoastere = prefs.getString('CV6') ?? '';
      _cv6 = json.decode(str_CPAutocunoastere);
      //7--------------------
      final str_CPviziune_dezvoltare_personala = prefs.getString('CV7') ?? '';
      _cv7 = json.decode(str_CPviziune_dezvoltare_personala);
      //8--------------------
      final str_CPpost_vizat = prefs.getString('CV8') ?? '';
      _cv8 = json.decode(str_CPpost_vizat);
      //9--------------------
      final str_CPobiective_dezvoltare_personala = prefs.getString('CV9') ?? '';
      _cv9 = json.decode(str_CPobiective_dezvoltare_personala);
      //10-----------
      final str_CPobiective_dezvoltare_personala1 = prefs.getString('CV10') ?? '';
      _cv10 = json.decode(str_CPobiective_dezvoltare_personala1);
      //11-----------
      final str_CPobiective_dezvoltare_personala2 = prefs.getString('CV11') ?? '';
      _cv11 = json.decode(str_CPobiective_dezvoltare_personala2);
      //11-----------
      final str_CPobiective_dezvoltare_personala3 = prefs.getString('CV12') ?? '';
      _cv12 = json.decode(str_CPobiective_dezvoltare_personala3);
      //12-----------
      final str_CPobiective_dezvoltare_personala4 = prefs.getString('CV13') ?? '';
      _cv13 = json.decode(str_CPobiective_dezvoltare_personala4);
    });

  }

  bool createPayload()
  {
    if(strselected.length <1) {

      showMyDialog(context,"Selectați tipul");
      return false;
    }
    if(_Descriere.text.length <1) {

      showMyDialog(context,"Introduceți descrierea");
      return false;
    }

    _cv2 = {
      "tip":strselected,
      "pozitieText":_Descriere.text.toString(),
    };

    SaveCreerPlan_PersonalInfo();
    return true;
  }

  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();

    });
    print("Print userdata in Side menu");
    print(userdata);
  }

  Future<Null> GetCVPlandata() async
  {
    Map plandata;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVData') ?? '';
    Map sem_data = json.decode(myString);
    plandata = json.decode(
        sem_data["tip_aplicatie"].replaceAll(new RegExp(r"(\s\n)"), ""));
    setState(() {
      strselected = plandata["tip"];
      _Descriere.text = plandata["pozitieText"];
    });

  }

  @override
  void initState() {
    super.initState();
    GetUserdata();
    GetCVPlandata();
    FetchCVData();
    super.initState();

    strselected = _users[0];
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

  @override
  Widget build(BuildContext context) {
    Future<void> _ackAlert(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return  Container(
            margin: EdgeInsets.all(20),
            color: Colors.transparent,
            child: questionWidget.Dialogview(),
          );
        },
      );
    };

    return Scaffold(
      appBar: AppBar(
        title: Text("Completare CV"),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.help_outline),
            onTap: () {
              _ackAlert(context);
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 40),
        //padding: EdgeInsets.all(20.0),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Text(
                  "Pasul 2 din 13",
                  style:
                  TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
              ),
              SizedBox(height: 10,),
              Text(
                  "Tipul aplicatiei",
                  style:
                  TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'demi')
              ),
              SizedBox(height: 50,),
              Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Tipul aplicatiei",
                      style:
                      TextStyle(color: Colors.black38, fontSize: 18.0, fontFamily: 'demi'),textAlign: TextAlign.left,
                    ),
                    Container(
                      height: 60,
                      child: DropdownButton(
                        value: strselected,
                        isDense: true,
                        onChanged: (String SelectedUser) {
                          setState(() {
                            strselected = SelectedUser;
                          });
                        },
                        items: _users.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Text(
                      "Descriere",
                      style:
                      TextStyle(color: Colors.black38, fontSize: 18.0, fontFamily: 'demi'),textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                        style: TextStyle(color: Colors.black54, fontSize: 18.0, fontFamily: 'demi'),maxLines: 6,controller: _Descriere,textAlign: TextAlign.left),

                  ],
                ),
              ),
              SizedBox(height: 30,),
              OutlineButton(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Text(StrUserType == UserType.Student || StrUserType == UserType.Pupil?
                        "Salveaza si inchide":"Corect si inchide",
                        )
                    )
                  ],
                ),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                textColor: Colors.green,
                onPressed: () {
                  if(StrUserType == UserType.Student || StrUserType == UserType.Pupil)
                  {
                    if (createPayload() == true)
                    {
                      _apiToAddCV().then((res) {
                        if (res == true)
                        {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard(StrUserType: StrUserType)));
                          });
                        }
                      });
                    }
                  }
                  else
                  {
                    if (createPayload() == true)
                    {
                      __apiToCorrectCV().then((res) {
                        if (res == true)
                        {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard(StrUserType: StrUserType)));
                          });
                        }
                      });
                    }
                  }
                },
                borderSide: BorderSide(
                  color: Colors.green, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 1, //width of the border
                ),
              ),
              SizedBox(height: 10),
              RaisedButton(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,

                        child: Text(
                            "Salvați și mergeți la pasul 3", style: TextStyle(fontFamily: 'regular')
                        )
                    )
                  ],
                ),
                onPressed: (){
    if (createPayload() == true) {
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => CVCompletion_3(StrUserType: StrUserType)));
    }
                },
                color: Appcolor.AppGreen,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
