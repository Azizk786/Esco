import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/Career Plan/CareerPlan_3.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class CareerPlan_2 extends StatefulWidget {
  @override
  UserType  StrUserType;
  Map cp1;
  CareerPlan_2({Key key, @required this.StrUserType, @required this.cp1}) : super(key: key);
  _CareerPlan_2State createState() => _CareerPlan_2State(StrUserType,cp1);
}

class _CareerPlan_2State extends State<CareerPlan_2> {
  double _value = 0.7;
  UserType  StrUserType;
  int rowCount = 1;
 // Map _payload;
  Map cp1;
  String struserid;
  bool _saving = false;

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

  List<TextEditingController> _controllers = new List();
  _CareerPlan_2State(this.StrUserType,this.cp1);
  final _q1 = TextEditingController();
  final _q2 = TextEditingController();
  final _q3 = TextEditingController();
  final _q4 = TextEditingController();


  SaveCreerPlan_puncte_tari() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CP2", json.encode(_cp2));
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

  Future<bool> _apiTo_addCareerPlan10() async {

    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.saveCareerPlan;
    final client = new http.Client();

    Map<String,String> _finalPayload = {"plan_actiune":json.encode(_c10),
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
    print("finalPayload");
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

  Future<Null> FetchCVPlanAllData() async
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

  bool createPayload()
  {

      if(_q1.text.length <1) {

        showMyDialog(context,"introduce  Ce calităţi şi talente ai?");
        return false;
      }

    if(_q2.text.length <1) {

      showMyDialog(context,"introduce  Care sunt valorile și interesele tale?");
      return false;
    }
    if(_q3.text.length <1) {

      showMyDialog(context,"introduce  Ce competențe ai dobândit?");
      return false;
    }
    if(_q3.text.length <1) {

      showMyDialog(context,"introduce  Ce trăsături de personalitate te definesc?");
      return false;
    }
      if(_controllers == null) {

        showMyDialog(context,"introduce  Adaugă alte puncte tari");
        return false;
      }

      List arr = [];
      for (var i = 0; i < rowCount; i++) {

        TextEditingController cou =  _controllers[i];
        arr.add(cou.text.toString());
      }
      /*
      {"1520190802076":
      {"calitati":"Perseverent si Devotat",
      "valori_interese":"",
      "competente":"",
      "trasaturi_personalitate":"",
      "altePuncte":[]}}
      * */

      Map Sem_Payload =  {
        "calitati":_q1.text.toString(),
        "valori_interese":_q2.text.toString(),
        "competente":_q3.text.toString(),
        "trasaturi_personalitate":_q4.text.toString(),
        "altePuncte":arr,
      };

    _cp2 = {
      "1520190802076":Sem_Payload,
    };


    print("print payload ====================================================");
    print(_cp2);

      SaveCreerPlan_puncte_tari();
    return true;
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

  Future<Null> GetCVPlandata1() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVPlanData') ?? '';
    Map sem_data = json.decode(myString);
  //  String _puncte_tariData = plandata["puncte_tari"];
  Map  plandata = json.decode(
        sem_data["puncte_tari"].replaceAll(new RegExp(r"(\s\n)"), ""));

        setState(() {
          _q1.text = plandata["1520190802076"]["calitati"];
          _q2.text = plandata["1520190802076"]["valori_interese"];
          _q3.text = plandata["1520190802076"]["competente"];
          _q4.text = plandata["1520190802076"]["trasaturi_personalitate"];
         // List alte = plandata["1520190802076"]["altePuncte"].split(",");

          List telefon = plandata["1520190802076"]["altePuncte"];
          print("ppppp = $telefon");
          String stelefon = telefon.join(', ');
          List tele = stelefon.split(", ");
          _controllers = [];
          rowCount = tele.length;
          for (var i = 0; i < tele.length; i++) {
            final _cont = TextEditingController();
            _cont.text = tele[i];
            _controllers.add(_cont);
          }

        });
  }

  Widget _forLastRow(int _inx)
  {
    if(rowCount-1 == _inx)
      {
        return TextFormField(
          controller: _controllers[_inx],
          decoration: InputDecoration(
              labelText: 'Adaugă alte puncte tari',
              suffixIcon: IconButton(icon: Icon(Icons.add_circle,color: Appcolor.redHeader,),  onPressed: () {
                this.setState(() {
                  TextEditingController ctrl = _controllers[rowCount-1];
                                if (ctrl.text.length>0)
                               {
                          rowCount = rowCount+1;
                                }else{

                                }
                });
              },)
          ),
        );
      }
    else
      {
        return TextFormField(
          decoration: InputDecoration(
              hintText: '',
              labelText: 'Adaugă alte puncte tari',
              suffixIcon: IconButton(icon: Icon(Icons.remove_circle,color: Appcolor.redHeader,),  onPressed: () {
                this.setState(() {
                  if (rowCount>1)
                    rowCount = rowCount-1;
                });
              },)
          ),
          controller: _controllers[_inx],
        );
      }
  }

  void initState() {
    super.initState();
    GetUserdata();
    FetchCVPlanAllData();
    GetCVPlandata1();
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Plan Cariera"),
          centerTitle: true,
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.notifications),
              onTap: () {
                _ackAlert(context);
              },
            ),
            SizedBox(width: 20),
          ],
        ),
        body: ModalProgressHUD(inAsyncCall: _saving, child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
              alignment: Alignment.center,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                        "Pasul 2 din 10",
                        style:
                        TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
                    ),
                    SizedBox(height: 10,),
                    Text(
                        "SWOT - Puncte Tari",
                        style:
                        TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'demi')
                    ),
                    SizedBox(height: 30,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Ce calităţi şi talente ai?",
                            style:
                            TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')),
                        TextFormField(
                          maxLines: 5,
                          controller: _q1,
                        ),
                        SizedBox(height: 20,),
                        Text("Care sunt valorile și interesele tale?",
                            style:
                            TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')),
                        TextFormField(
                          maxLines: 5,
                          controller: _q2,
                        ),
                        SizedBox(height: 20,),
                        Text("Ce competențe ai dobândit?",
                            style:
                            TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')),
                        TextFormField(
                          maxLines: 5,
                          controller: _q3,
                        ),
                        SizedBox(height: 20,),
                        Text("Ce trăsături de personalitate te definesc?",
                            style:
                            TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')),
                        TextFormField(
                          maxLines: 5,
                          controller: _q4,
                        ),
                        SizedBox(height: 20,),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: rowCount,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            _controllers.add(new TextEditingController());
                            return _forLastRow(index);
                          },
                        ),

                      ],
                    ),
                    SizedBox(height: 15,),
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
                    RaisedButton(
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(StrUserType == UserType.Student || StrUserType == UserType.Pupil?
                              "Salveaza si mergi la pasul 3":"Corect si mergi la pasul 3", style: TextStyle(fontFamily: 'regular')
                              )
                          )
                        ],
                      ),
                      onPressed: (){


                        if(StrUserType == UserType.Student || StrUserType == UserType.Pupil)
                        {
                          if (createPayload() == true)
                          {
//                            _apiTo_addCareerPlan2().then((res) {
//                              if (res == true)
//                              {
                                setState(() {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => CareerPlan_3(StrUserType: StrUserType,cp2: _cp2,)));
                                });
//                              }
//                            });
                          }
                        }
                        else
                        {
                          if (createPayload() == true)
                          {
//                            _apiTo_CorrectCareerPlan1().then((res) {
//                              if (res == true)
//                              {
                                setState(() {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => CareerPlan_3(StrUserType: StrUserType,cp2: _cp2,)));
                                });
//                              }
//                            });
                          }
                        }
                      },
                      color: Appcolor.AppGreen,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),

                    ),
                  ]
              )
          ),
        )),
//        drawer: Drawer(
//    child: SideMenu(StrUserType: StrUserType),
//    ),
    );
  }
}
class ContactNumber {
  int id;
  String name;
  ContactNumber(this.id, this.name);
  static List<ContactNumber> getUsers() {
    return <ContactNumber>[
      ContactNumber(1, 'Home'),
      ContactNumber(2, 'Work'),
      ContactNumber(3, 'Other'),
    ];
  }
}