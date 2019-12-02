import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/LetterOFIntent/LetterOFIntent_7.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:escouniv/Dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class LetterofIntent_6 extends StatefulWidget {
  @override
  UserType  StrUserType;
  LetterofIntent_6({Key key, @required this.StrUserType}) : super(key: key);
  _LetterofIntent_6State createState() => _LetterofIntent_6State(StrUserType);
}

class _LetterofIntent_6State extends State<LetterofIntent_6> {
  UserType  StrUserType;
  String _selectedTitleType ;
  Map _loi1;
  Map _loi2;
  Map _loi3;
  Map _loi4;
  Map _loi5;
  Map _loi6;
  Map _loi7;
  bool _saving = false;
  String struserid;
  File _image;
  Map userdata;
  List<String> _users = ["Cu Stima", "Cu Respect" ,"Cu Consideratie" ,"Cu deosebit respect" , "Cu deosebita consideratie" ,"Va Multumesc"];

  _LetterofIntent_6State(this.StrUserType);
  final _Nume = TextEditingController();

  //API----------------------------
  Future<bool> _apiTo_addLetterofIntent() async {

    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.saveLetterofIntent;
    final client = new http.Client();
    Map<String,String> _dd = {"anexe":json.encode(_loi7),
      "informatii_personale":json.encode(_loi1),
      "destinatar":json.encode(_loi2),
      "subiect":json.encode(_loi3),
      "formula_salut":json.encode(_loi4),
      "continut":json.encode(_loi5),
      "formula_incheiere":json.encode(_loi6),
      "user_id":struserid
    };
    Map<String,String> _finalPayload = _dd;
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
    //Fetch cv paln data here for id
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVLOIData') ?? '';
    Map _Correctiondata = json.decode(myString);

    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.CorrectLoIRquest;
    final client = new http.Client();
    Map<String, dynamic> _dd = {
      "informatii_personale": _loi1,
      "destinatar": _loi2,
      "subiect": _loi3,
      "formula_salut": _loi4,
      "continut": _loi5,
      "formula_incheiere": _loi6,
      "anexe": _loi7,
    };


    Map<String, dynamic> _finalPayload = {
      "new_data": json.encode(_dd),
      "user_id": struserid,
      "later_id": _Correctiondata["scrisoare_intentie_id"]
    };

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
      String status = map["status"].toString();
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
  //-------------------------------------
  Future<Null>  GetLOIData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      final str_personelInfo = prefs.getString('LOI1') ?? '';
      _loi1 = json.decode(str_personelInfo);
      //2---------
      final str_puncte_tari = prefs.getString('LOI2') ?? '';
      _loi2 = json.decode(str_puncte_tari);
      //3------------------
      final str_CPPuncteSlabe = prefs.getString('LOI3') ?? '';
      _loi3 = json.decode(str_CPPuncteSlabe);
      //4--------------------
      final str_CPoportunitati = prefs.getString('LOI4') ?? '';
      _loi4 = json.decode(str_CPoportunitati);
      //5--------------------
      final str_CPCPAmenintari = prefs.getString('LOI5') ?? '';
      _loi5 = json.decode(str_CPCPAmenintari);
      //6--------------------
      final str_CPAutocunoastere = prefs.getString('LOI6') ?? '';
      _loi6 = json.decode(str_CPAutocunoastere);
      //7--------------------
      final str_CPAutocunoastere1 = prefs.getString('LOI7') ?? '';
      _loi7 = json.decode(str_CPAutocunoastere1);

    });

  }
  openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 240, maxWidth: 320);
    setState(() {
   //   Navigator.of(context).pop(true);
      _image = image;
    });
  }
  openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 240, maxWidth: 320);
    setState(() {
     // Navigator.of(context).pop(true);
      _image = image;
    });
  }

  _selectimagefrom(BuildContext context, String strmsg) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return new AlertDialog(
            content: Text(
              strmsg,
            ),
            actions: <Widget>[
              OutlineButton(
                child: const Text('aparat foto'),
                onPressed: () {
                   Navigator.of(context).pop(true);
                  openCamera();
                },
              ),
              OutlineButton(
                child: const Text('Galerie'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  openGallery();

                },
              ),
              FlatButton(
                child: const Text('Anulare'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        }
    );
  }
//  onChangeDropdownItem(_FormulaType SelectedUser) {
//    setState(() {
//      _selectedTitleType = SelectedUser;
//
//    });
//  }

  SaveLetterofIntent_PersonalInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("LOI6", json.encode(_loi6));
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

  bool createPayload()
  {
    if(_selectedTitleType.length <1) {

      showMyDialog(context,"introduce Formula de incheiere");
      return false;
    }
  Map  Sem_Payload = {
      "formulaIncheiere":_selectedTitleType,
  "nume":_Nume.text.toString(),
    };

  _loi6 = {
  "1566911912043":Sem_Payload,
  };
    SaveLetterofIntent_PersonalInfo();
    return true;
  }
  Future<Null> GetCVPlandata() async
  {
    //"formula_incheiere": "{\"1566911912043\":{\"formulaIncheiere\":\"Cu Respect\",\"nume\":\"jkhjljhlhllj\"}}",
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVLOIData') ?? '';
    Map sem_data = json.decode(myString);
    Map  plandata = json.decode(
        sem_data["formula_incheiere"].replaceAll(new RegExp(r"(\s\n)"), ""));
    setState(() {
     // _selectedTitleType =
      _Nume.text = plandata["1566911912043"]["nume"];
      _selectedTitleType = plandata["1566911912043"]["formulaIncheiere"];


    });

  }
  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    struserid = userdata["userid"].toString();
    GetCVPlandata();
    GetLOIData();
    print("Print userdata in Side menu");
    print(userdata);
  }
//  List<DropdownMenuItem<_FormulaType>> buildDropdownMenuItems(List companies) {
//    List<DropdownMenuItem<_FormulaType>> items = List();
//    for (_FormulaType user in _users) {
//      items.add(
//        DropdownMenuItem(
//          value: user,
//          child: Text(user.name),
//        ),
//      );
//    }
//    return items;
//  }

  @override

  void initState() {
    super.initState();
   // _dropdownMenuItems = buildDropdownMenuItems(_users);
    _selectedTitleType = _users[0];
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



  Widget _ifimageSelected()
  {
    if (_image == null)
      {
        return Container(
          height: 10,
        );
      }else
        {
          return Container(
color: Colors.grey,
            height: 30,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
               //SizedBox(width: 1,),
                Text("Signature.png"),
                FlatButton.icon(onPressed: (){
                  setState(() {
                    _image = null;
                  });
                }, icon: Icon(Icons.clear,color: Appcolor.redHeader,),label: Text(""),)
              ],
            ),
          );
        }
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
        title: Text("Scrisoare de Intentie"),
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
//      drawer: Drawer(
//        child: SideMenu(StrUserType: StrUserType),
//      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Text(
                  "Pasul 6 din 7",
                  style:
                  TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
              ),
              SizedBox(height: 10,),
              Text(
                  "Formula de incheiere",
                  style:
                  TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'demi')
              ),
              SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    width: double.infinity,
                    height: 65,
                    child:  DropdownButton(
                      value: _selectedTitleType,
                      isDense: true,
                      icon:Icon(Icons.keyboard_arrow_down,
                          color: Appcolor.redHeader),
                      onChanged: (String SelectedUser) {
                        setState(() {
                          _selectedTitleType = SelectedUser;
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
                  SizedBox(height: 10),
                  Text(
                      "Semnatura",
                      style:
                      TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'demi')
                  ),
                  SizedBox(height: 10),
                  Text(
                      "Dimensiunea optima:",
                      style:
                      TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'demi')
                  ),
                  Text(
                      "250x100px",
                      style:
                      TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'demi')
                  ),
                  SizedBox(height: 10),
                  Text(
                      "Fisiere acceptate:",
                      style:
                      TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'demi')
                  ),
                  Text(
                      "PNG, JPG",
                      style:
                      TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'demi')
                  ),
                  SizedBox(height: 10),
                  Text(
                      "Marimea maxima:",
                      style:
                      TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'demi')
                  ),
                  Text(
                      "1MB",
                      style:
                      TextStyle(color: Colors.black, fontSize: 18.0, fontFamily: 'demi')
                  ),
                  SizedBox(height: 15,),
                  _ifimageSelected(),
                  OutlineButton(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Incarca semnatura",
                            )
                        )
                      ],
                    ),
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    textColor: Colors.green,
                    onPressed: () {
                      _selectimagefrom(context, "selectați semnătura");
                    }, //callback when button is clicked
                    borderSide: BorderSide(
                      color: Colors.green, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 1, //width of the border
                    ),
                  ),
                  SizedBox(height: 15,),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Numele dvs.'
                    ),
controller: _Nume,
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
                          _apiTo_addLetterofIntent().then((res) {
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

                      // _selectimagefrom(context, "selectați semnătura");
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
                            "Salveaza si mergi la pasul 7":"Corect si mergi la pasul 7", style: TextStyle(fontFamily: 'regular')
                            )
                        )
                      ],
                    ),
                    onPressed: (){
                      if(StrUserType == UserType.Student || StrUserType == UserType.Pupil)
                      {
                        if (createPayload() == true)
                        {
//                          _apiTo_addLetterofIntent().then((res) {
//                            if (res == true)
//                            {
                              setState(() {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => LetterofIntent_7(StrUserType: StrUserType)));
                              });
//                            }
//                          });
                        }
                      }
                      else
                      {
                        if (createPayload() == true)
                        {
                          // _apiTo_CorrectCareerPlan1().then((res) {
                          //  if (res == true)
                          //  {
                          setState(() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => LetterofIntent_7(StrUserType: StrUserType)));
                          });
                          // }
                          // });
                        }
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

            ]
        ),
      ),
    );
  }
}
class _FormulaType {
  int id;
  String name;
  _FormulaType(this.id, this.name);
  static List<_FormulaType> getTitle() {
    return <_FormulaType>[
      _FormulaType(1, 'Cu Stima'),
      _FormulaType(2, 'Cu Respect'),
      _FormulaType(3, 'Cu Consideratie'),
      _FormulaType(4, 'Cu deosebit respect'),
      _FormulaType(5, 'Cu deosebita consideratie'),
      _FormulaType(6, 'Va Multumesc'),
    ];
  }
}