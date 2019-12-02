import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/Dashboard.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class CareerPlan_10 extends StatefulWidget {
  @override
  UserType  StrUserType;
  CareerPlan_10({Key key, @required this.StrUserType}) : super(key: key);
  _CareerPlan_10State createState() => _CareerPlan_10State(StrUserType);
}

class _CareerPlan_10State extends State<CareerPlan_10> {
  double _value = 0.7;
  UserType  StrUserType;
  _CareerPlan_10State(this.StrUserType);
  Map _c10;
  Map _cp1;
  Map _cp2;
  Map _cp3;
  Map _cp4;
  Map _cp5;
  Map _cp6;
  Map _cp7;
  Map _cp8;
  Map _cp9;
  String struserid;
  bool _saving = false;
  bool _isSendingForReview = false;
  final _actiune = TextEditingController();
  final _objectivec = TextEditingController();
  final _termen = TextEditingController();
  final _resurse = TextEditingController();
  @override

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

  Future<bool> _apiTo_addCareerPlan10() async {

    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.saveCareerPlan;
    final client = new http.Client();

    Map<String,String> _finalPayload = {
      "plan_actiune":json.encode(_c10),
      "informatii_personale":json.encode(_cp1),
      "puncte_tari":json.encode(_cp2),
      "puncte_slabe":json.encode(_cp3),
      "oportunitati":json.encode(_cp4),
      "amenintari":json.encode(_cp5),
      "descriere":json.encode(_cp6),
      "viziune_dezvoltare_personala":json.encode(_cp7),
      "obiective_dezvoltare_personala":json.encode(_cp9),
      "post_vizat":json.encode(_cp8),
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
      String _strcvid =  map["insert_id"].toString();
      if(_isSendingForReview == true)
        {
          SendcvplanDocumentReviewRequest(_strcvid).then((res) {
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
          return false;
        }
      else
        {
          showMyDialog(context, map["message"].toString());
          return true;
        }



    } else if(streamedRest.statusCode == 201) {
      setState(() {
        _saving = false;
      });
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
  Future<bool> _apiTo_CorrectCareerPlan1() async {

    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.UpdateCVPlan;
    final client = new http.Client();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVPlanData') ?? '';
    Map _Correctiondata = json.decode(myString);
    Map<String,dynamic> _dd = {
      "informatii_personale":_cp1,
      "puncte_tari":_cp2,
      "puncte_slabe":_cp3,
      "oportunitati":_cp4,
      "amenintari":_cp5,
      "descriere":_cp6,
      "viziune_dezvoltare_personala":_cp7,
      "post_vizat":_cp8,
      "obiective_dezvoltare_personala":_cp9,
      "plan_actiune":_c10,
    };

    Map<String,dynamic> _finalPayload = {"new_data":json.encode(_dd),"user_id":struserid,"cv_id":_Correctiondata["plan_cariera_id"] };
    print(dynamic);
    print(_finalPayload);
    final streamedRest = await client.post(url,
        body: _finalPayload,
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      print(streamedRest.body);
      setState(() {
        _saving = false;
      });
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
      return true;
    }
    else if(streamedRest.statusCode == 201) {
      setState(() {
        _saving = false;
      });
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
  Future<bool> SendcvplanDocumentReviewRequest(String strcvplanid) async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.SendCareerplanCorrectRquest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid,'cv_id': strcvplanid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200)
    {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();
      if (Status == "200") {
        showMyDialog(context, map["message"].toString());
      }
      return true;
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
  bool createPayload()
  {

    if(_objectivec.text.length <1) {

      showMyDialog(context,"Introduceți Obiectiv");
      return false;
    }
    if(_actiune.text.length <1) {

      showMyDialog(context,"Introduceți Actiune");
      return false;
    }
    if(_termen.text.length <1) {

      showMyDialog(context,"Introduceți Termen");
      return false;
    }
    if(_resurse.text.length <1) {

      showMyDialog(context,"Introduceți Resurse");
      return false;
    }


    Map Sem_Payload =  {
      "obiectiv":_objectivec.text.toString(),
      "actiunea":_actiune.text.toString(),
      "termen":_termen.text.toString(),
      "resurse":_resurse.text.toString(),

    };
    _c10 = {
      "1531296511112":Sem_Payload,
    };

    print("print payload ====================================================");
    print(_c10);

    return true;
  }
  Future<Null> GetCVPlanData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final str_personelInfo = prefs.getString('CP1') ?? '';
      _cp1 = json.decode(str_personelInfo);
      //2---------
      final str_puncte_tari = prefs.getString('CP2') ?? '';
      _cp2 = json.decode(str_puncte_tari);
      //3------------------
      final str_CPPuncteSlabe = prefs.getString('CP3') ?? '';
      _cp3 = json.decode(str_CPPuncteSlabe);
      //4--------------------
      final str_CPoportunitati = prefs.getString('CP4') ?? '';
      _cp4 = json.decode(str_CPoportunitati);
      //5--------------------
      final str_CPCPAmenintari = prefs.getString('CP5') ?? '';
      _cp5 = json.decode(str_CPCPAmenintari);
      //6--------------------
      final str_CPAutocunoastere = prefs.getString('CP6') ?? '';
      _cp6 = json.decode(str_CPAutocunoastere);
      //7--------------------
      final str_CPviziune_dezvoltare_personala = prefs.getString('CP7') ?? '';
      _cp7 = json.decode(str_CPviziune_dezvoltare_personala);
      //8--------------------
      final str_CPpost_vizat = prefs.getString('CP8') ?? '';
      _cp8 = json.decode(str_CPpost_vizat);
      //9--------------------
      final str_CPobiective_dezvoltare_personala = prefs.getString('CP9') ?? '';
      _cp9 = json.decode(str_CPobiective_dezvoltare_personala);
    });

  }
  Future<Null> SetCVPlandata1() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVPlanData') ?? '';
    Map sem_data = json.decode(myString);
    Map plandata = json.decode(
        sem_data["plan_actiune"].replaceAll(new RegExp(r"(\s\n)"), ""));


    setState(() {
      _objectivec.text = plandata["1531296511112"]["obiectiv"];
      _actiune.text = plandata["1531296511112"]["actiunea"];
      _termen.text = plandata["1531296511112"]["termen"];
      _resurse.text = plandata["1531296511112"]["resurse"];

    });
  }
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
  void initState() {
    super.initState();
    GetUserdata();
    GetCVPlanData();
    SetCVPlandata1();
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

    var family = [["A1", "Utilizator elementar", "- Pot sa inteleg expresii "
        "cunoscute si propozitii foarte simple referitoare la mine, la familie "
        "si la imprejurari concrete, cand se vorbeste rar si cu claritate."],
      ["A2", "Utilizator elementar", " - Pot sa inteleg expresii si cuvinte uzuale frecvent intalnite pe teme ce au relevanta imediata pentru mine personal (de ex., informatii simple despre mine is familia mea, cumparaturi, zona unde locuiesc, activitatea profesionala). Pot sa inteleg punctele esentiale din anunturi si mesaje scurte, simple si clare "],
      ["B1", "Utilizator independent", " - Pot să înţeleg punctele esenţiale în vorbirea standard clară pe teme familiare referitoare la activitatea profesională, scoală, petrecerea timpului liber etc. Pot să înţeleg ideea principală din multe programe radio sau TV pe teme de actualitate sau de interes personal sau profesional, dacă sunt prezentate într-o manieră relativ clară şi lentă."],
      ["B2", "Utilizator independent", " - Pot să înţeleg conferinţe şi discursuri destul de lungi şi să urmăresc chiar şi o argumentare complexă, dacă subiectul îmi este relativ cunoscut. Pot să înţeleg majoritatea emisiunilor TV de ştiri şi a programelor de actualităţi. Pot să înţeleg majoritatea filmelor în limbaj standard. "],
      ["C1", "Utilizator independent", " - Pot să înţeleg conferinţe şi discursuri destul de lungi şi să urmăresc chiar şi o argumentare complexă, dacă subiectul îmi este relativ cunoscut. Pot să înţeleg majoritatea emisiunilor TV de ştiri şi a programelor de actualităţi. Pot să înţeleg majoritatea filmelor în limbaj standard. "],
      ["C2", "Utilizator independent", " - Nu am nici o dificultate în a înţelege limba vorbită, indiferent dacă este vorba despre comunicarea directă sau în transmisiuni radio, sau TV, chiar dacă ritmul este cel rapid al vorbitorilor nativi, cu condiţia de a avea timp să mă familiarizez cu un anumit accent."]];


    Widget Dialogview()
    {
      return  Container
        (color: Colors.white,
        padding: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 10),
        alignment: Alignment.center,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: family.length,
          separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black38,),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){
                print("dismiss");
                setState(() {

                });
                Navigator.of(context).pop(true);

              },
              child:  FlatButton(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 10,),
                    Text(
                        family[index][0],
                        style:
                        TextStyle(color: Appcolor.redHeader, fontSize: 16.0, fontFamily: 'regular')
                    ),
                    SizedBox(width: 10,),
                    aVerticalLine,
                    SizedBox(width: 4,),
                    Flexible(
                      child:  RichText(
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text:  family[index][1], style:
                            TextStyle(color: Appcolor.redHeader, fontSize: 16.0, fontFamily: 'dami')),
                            TextSpan(text:  family[index][2],style:
                            TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'regular')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

          },
        ),
      );
    }

    Widget NoSendforCorrectionforCousellor()
    {
      if(StrUserType == UserType.Student || StrUserType == UserType.Pupil)
      {
       return RaisedButton(
          child: Stack(
            children: <Widget>[

              Align(
                  alignment: Alignment.center,
                  child: Text("Salveaza si trimite la corectat", style: TextStyle(fontFamily: 'regular')
                  )
              ),
            ],
          ),
          onPressed: (){
            _isSendingForReview = true;
            if(StrUserType == UserType.Student || StrUserType == UserType.Pupil)
            {
              if (createPayload() == true)
              {
                _apiTo_addCareerPlan10().then((res) {
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
                _apiTo_CorrectCareerPlan1().then((res) {
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
          color: Appcolor.AppGreen,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),

        );
      }

      else
        {
          return Container();
        }
    };
    Future<void> _ackAlert(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return  Container(
            margin: EdgeInsets.all(20),
            color: Colors.transparent,
            child: Dialogview(),
          );
        },
      );
    };
    return ModalProgressHUD(inAsyncCall: _saving, child: Scaffold(
        appBar: AppBar(
          title: Text("Plan Cariera"),
          centerTitle: true,
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.help_outline,),
              onTap: () {
                _ackAlert(context);
              },
            ),
            SizedBox(width: 20),
          ],
        ),
//        drawer: Drawer(
//      child: SideMenu(StrUserType: StrUserType),
//    ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "Pasul 10 din 10",
                        style:
                        TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
                    ),
                    SizedBox(height: 10,),
                    Text(
                        "Plan de actiune",
                        style:
                        TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'demi')
                    ),
                    SizedBox(height: 30,),

                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Obiectiv',
                        labelText: 'Obiectiv',

                      ),
                      controller: _objectivec,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Actiune',
                        labelText: 'Actiune',

                      ),
                      controller: _actiune,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Termen',
                        labelText: 'Termen',

                      ),
                      controller: _termen,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Resurse',
                        labelText: 'Resurse',

                      ),
                      controller: _resurse,
                    ),

                    SizedBox(height: 15,),
                    SizedBox(height: 35,),
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
                        _isSendingForReview = false;
                        if(StrUserType == UserType.Student || StrUserType == UserType.Pupil)
                        {
                          if (createPayload() == true)
                          {
                            _apiTo_addCareerPlan10().then((res) {
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
                            _apiTo_CorrectCareerPlan1().then((res) {
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

                      }, //callback when button is clicked
                      borderSide: BorderSide(
                        color: Colors.green, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 1, //width of the border
                      ),
                    ),
                    SizedBox(height: 10),
                  NoSendforCorrectionforCousellor()
                  ]
              )
          ),
        )
    ));
  }
}




