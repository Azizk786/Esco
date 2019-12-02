import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/LetterOFIntent/LetterOFIntent_2.dart';
import 'package:escouniv/LetterOFIntent/LetterOFIntent_3.dart';
import 'package:escouniv/LetterOFIntent/LetterOFIntent_4.dart';
import 'package:escouniv/LetterOFIntent/LetterOFIntent_5.dart';
import 'package:escouniv/LetterOFIntent/LetterOFIntent_6.dart';
import 'package:escouniv/LetterOFIntent/LetterOFIntent_7.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/CustomWidget/Selector.dart';

enum SingingCharacter { radio1, radio2 }

class LetterofIntent_1 extends StatefulWidget {
  @override
  UserType StrUserType;
  LetterofIntent_1({Key key, @required this.StrUserType}) : super(key: key);
  LetterofIntent_1State createState() => LetterofIntent_1State(StrUserType);
}

class LetterofIntent_1State extends State<LetterofIntent_1> {


  //*> Contact Selector
  Selector contactSelectorWidget = new Selector(selectorTypes: ["Domiciliu", "Loc de Munca", "Mobil", "Telefon(Oane)"], placeHolder:"Telefon(Oane)", keyboardType: KeyBoardType.phone);

  //*> Social Selector
  Selector socialSelectorWidget = new Selector(selectorTypes: ["Skype", "Linkedin", "Facebook"], placeHolder:"Id", keyboardType: KeyBoardType.email);




  double _value = 0;
  UserType StrUserType;
  String struserid;
  int rowCount = 1;
  String _sex;
  String _strDob;
  bool _saving = true;
  LetterofIntent_1State(this.StrUserType);
  Map userdata;
  String Strname = "";
  int _groupValuenew = -1;
  Map _loi1;
  Map _loi2;
  Map _loi3;
  Map _loi4;
  Map _loi5;
  Map _loi6;
  Map _loi7;
  int rowCount1 = 1;

  List StepList = [
    "Informatii personale",
    "Destinatar",
    "Subiect",
    "Formula salut",
    "Continut",
    "Formula_incheiere",
    "Anexe"
  ];

  String strSelectedStep = "informatii personale";

  List<Furnizer> _funers = Furnizer.getUsers();
  List<DropdownMenuItem<Furnizer>> _dropdownMenuItems1;

  String _selectedContactType;
  Furnizer _selectedid;

  final List<String> _users = ["eeee", "rrrrrr", "uuuu"];
  List<String> _ContactSelected = ["select"];
  final dateFormat = DateFormat("dd/MM/yyyy");
  List<TextEditingController> _controllers = new List();
  List<TextEditingController> _controllers1 = new List();
  List<TextEditingController> _controllersfurni = new List();

  List<DropdownMenuItem<ContactNumber>> _dropdownMenuItems;

  //Textfield controller-----------------------------------
  final _preName = TextEditingController();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _postalcode = TextEditingController();
  final _orasol = TextEditingController();
  final _tara = TextEditingController();
  final _nationality = TextEditingController();
  final _email = TextEditingController();

  //API----------------------------
  Future<bool> _apiTo_addLetterofIntent() async {
    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.saveLetterofIntent;
    final client = new http.Client();
    Map<String, String> _dd = {
      "anexe": json.encode(_loi7),
      "informatii_personale": json.encode(_loi1),
      "destinatar": json.encode(_loi2),
      "subiect": json.encode(_loi3),
      "formula_salut": json.encode(_loi4),
      "continut": json.encode(_loi5),
      "formula_incheiere": json.encode(_loi6),
      "user_id": struserid
    };
    Map<String, String> _finalPayload = _dd;
    final streamedRest = await client.post(url,
        body: _finalPayload,
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    setState(() {
      _saving = false;
    });
    if (streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String status = map["status"].toString();
      showMyDialog(context, map["message"].toString());
      return true;
    } else if (streamedRest.statusCode == 201) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
    } else {
      if (streamedRest.statusCode == 400) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
        return false;
      } else if (streamedRest.statusCode == 401) {
        showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
        return false;
      } else if (streamedRest.statusCode == 500) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
        return false;
      } else if (streamedRest.statusCode == 1001) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
        return false;
      } else if (streamedRest.statusCode == 1005) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
        return false;
      } else if (streamedRest.statusCode == 999) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
        return false;
      } else {
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
    print("final LOI id = $_finalPayload");

    print("final LOI data = $_finalPayload");
    final streamedRest = await client.post(url,
        body: _finalPayload,
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    setState(() {
      _saving = false;
    });
    if (streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String status = map["status"].toString();
      showMyDialog(context, map["message"].toString());

      return true;
    } else if (streamedRest.statusCode == 201) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
    } else {
      setState(() {
        _saving = false;
      });
      if (streamedRest.statusCode == 400) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
        return false;
      } else if (streamedRest.statusCode == 401) {
        showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
        return false;
      } else if (streamedRest.statusCode == 500) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
        return false;
      } else if (streamedRest.statusCode == 1001) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
        return false;
      } else if (streamedRest.statusCode == 1005) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
        return false;
      } else if (streamedRest.statusCode == 999) {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
        return false;
      } else {
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
        return false;
      }
    }
  }

  //-------------------------------------
  GetLOIData() async {
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
  //-------------------------------------

  onChangeDropdownItem(String SelectedUser) {
    setState(() {
      _selectedContactType = SelectedUser;
      if (_ContactSelected.contains(_selectedContactType)) {
      } else {
        _ContactSelected.add(SelectedUser);
      }
    });
  }

  onChangeDropdownItem1(Furnizer SelectedUser) {
    setState(() {
      _selectedid = SelectedUser;
    });
  }

  List<DropdownMenuItem<Furnizer>> buildDropdownMenuItems1(List companies) {
    List<DropdownMenuItem<Furnizer>> items = List();
    for (Furnizer user in _funers) {
      items.add(
        DropdownMenuItem(
          value: user,
          child: Text(user.name),
        ),
      );
    }
    return items;
  }

  SaveLetterofIntent_PersonalInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("LOI1", json.encode(_loi1));
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

  bool createPayload() {
    if (_name.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți prenumele");
      return false;
    }
    if (_preName.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți Nume");
      return false;
    }
    if (_address.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți adresa");
      return false;
    }
    if (_postalcode.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți codul poștal");
      return false;
    }
    if (_tara.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți țara");
      return false;
    }
    if (_email.text.length < 1) {
      showMyDialog(context, "Introduceți codul de e-mail");
      return false;
    }
    if (_nationality.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți naționalitatea");
      return false;
    }

    if (_controllers == null) {
      showMyDialog(
          context, "Vă rugăm să selectați cel puțin un număr de telefon");
      return false;
    }

    //*> get selected contact
    List<Map> contactList = contactSelectorWidget.getSelectedSelector(["phone_lbl", "phone_number"]);

    //*> get selected contact
    List<Map> socialList = socialSelectorWidget.getSelectedSelector(["social_lbl", "social_number"]);


    _loi1 = {
      "prenume": _preName.text.toString(),
      "nume": _name.text.toString(),
      "adresa": _address.text.toString(),
      "codPostal": _postalcode.text.toString(),
      "oras": _orasol.text.toString(),
      "tara": _tara.text.toString(),
      "email": _email.text.toString(),
      "nationalitate": _nationality.text.toString(),
      "sex": _sex,
      "data_nasterii": _nationality.text.toString(),
      "contact":contactList.length == 0?[]:contactList, //*> pass selected contact
      "Socail_Media":socialList.length == 0?[]:socialList, //*> pass selected media
    };
    print(_loi1);
    SaveLetterofIntent_PersonalInfo();
    return true;
  }

  GetUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();

      GetLOIData();
    });
    print("Print userdata in Side menu");
    print(userdata);
  }

  Future<Null> GetCVPlandata() async {
    Map plandata;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _saving = false;
      final myString = prefs.getString('CVLOIData') ?? '';
      Map sem_data = json.decode(myString);
      plandata = json.decode(sem_data["informatii_personale"]
          .replaceAll(new RegExp(r"(\s\n)"), ""));
      _preName.text = plandata["prenume"];
      _name.text = plandata["nume"];
      _address.text = plandata["adresa"];
      _orasol.text = plandata["oras"];
      _tara.text = plandata["tara"];
      _postalcode.text = plandata["codPostal"];
      _nationality.text = plandata["nationalitate"];
      _email.text = plandata["email"];

      if (plandata["sex"] == "Masculin") {
        _groupValuenew = 0;
      } else if (plandata["sex"] == "Feminin") {
        _groupValuenew = 1;
      } else {
        _groupValuenew = 2;
      }


      List telefon = plandata["contact"];
      //*> Initialize selector
      contactSelectorWidget.setSelectedSelector(telefon, ["phone_lbl", "phone_number"]);

      List social = plandata["Socail_Media"];
      //*> Initialize selector
      socialSelectorWidget.setSelectedSelector(social, ["social_lbl", "social_number"]);

    });
  }

//  List<DropdownMenuItem<ContactNumber>> buildDropdownMenuItems(List companies) {
//    List<DropdownMenuItem<ContactNumber>> items = List();
//    for (ContactNumber user in _users) {
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
    // _ContactSelected.add("select");
    // _dropdownMenuItems = buildDropdownMenuItems(_users);
    _dropdownMenuItems1 = buildDropdownMenuItems1(_funers);

    BackButtonInterceptor.add(myInterceptor);
    GetUserdata();
    GetCVPlandata();
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

  Widget _forLastinde(int _inx) {
    print("Print index = $_inx");
    print("print contscted selecte = $_ContactSelected");
    // print("print hhhhh = $")
    if (_inx == rowCount - 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // new Flexible(
          Container(
            margin: EdgeInsets.only(top: 25),
            //width: double.infinity,
            child: DropdownButton(
              value: _ContactSelected[_inx],
              isDense: true,
              onChanged: (String SelectedUser) {
                setState(() {
                  _selectedContactType = SelectedUser;

                  if (_ContactSelected.contains(_selectedContactType)) {
                  } else {
                    // _ContactSelected.removeAt(_inx);
                    _ContactSelected.insert(_inx, SelectedUser);
                    // _ContactSelected.add(SelectedUser);

                  }
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
          //),
          SizedBox(width: 20),
          new Flexible(
            child: new TextFormField(
              controller: _controllers[_inx],
              decoration: InputDecoration(
                  hintText: 'Telefon(Oane)',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.add_circle,
                      color: Appcolor.redHeader,
                    ),
                    onPressed: () {
                      this.setState(() {
                        TextEditingController ctrl = _controllers[rowCount - 1];
                        if (ctrl.text.length > 0 && _users.length > rowCount) {
                          rowCount = rowCount + 1;
                          _ContactSelected.add("Select");
                        }
                      });
                    },
                  )),
              keyboardType: TextInputType.number,
              maxLength: 12,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            //width: double.infinity,
            child: DropdownButton(
              value: _ContactSelected[_inx],
              isDense: true,
              onChanged: (String SelectedUser) {
                setState(() {
                  _selectedContactType = SelectedUser;
                  if (_ContactSelected.contains(_selectedContactType)) {
                  } else {
                    _ContactSelected.insert(_inx, SelectedUser);
                  }
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
          SizedBox(width: 20),
          new Flexible(
            child: new TextFormField(
              controller: _controllers[_inx],
              decoration: InputDecoration(
                  // labelText: 'Telefon(Oane)',
                  hintText: 'Telefon(Oane)',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Appcolor.redHeader,
                    ),
                    onPressed: () {
                      this.setState(() {
                        if (rowCount > 1) rowCount = rowCount - 1;
                        _ContactSelected.removeAt(_inx);
                      });
                    },
                  )),
              keyboardType: TextInputType.number,
              maxLength: 12,
            ),
          ),
        ],
      );
    }
  }

  Widget _forFurnozorLastIndex(int _inx) {
    if (_inx == rowCount1 - 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // new Flexible(
          Container(
            margin: EdgeInsets.only(top: 25),
            //width: double.infinity,
            child: DropdownButton(
                items: _dropdownMenuItems1,
                onChanged: onChangeDropdownItem1,
                icon:
                    Icon(Icons.keyboard_arrow_down, color: Appcolor.redHeader),
                value: _funers[_inx],
                hint: Text(
                  'Furnizer',
                )),
          ),
          //),
          SizedBox(width: 20),
          new Flexible(
            child: new TextFormField(
              controller: _controllers1[_inx],
              decoration: InputDecoration(
                hintText: 'Id',
//                  suffixIcon: IconButton(icon: Icon(Icons.add_circle,color: Appcolor.redHeader,),  onPressed: () {
//                    this.setState(() {
//                      TextEditingController ctrl = _controllers1[rowCount-1];
//                      if (ctrl.text.length>0 && _funers.length>rowCount1)
//                      {
//                        rowCount1 = rowCount1+1;
//                      }
//                    });
//                  },)
              ),
              //  keyboardType: TextInputType.phone,
              maxLength: 12,
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            //width: double.infinity,
            child: DropdownButton(
                items: _dropdownMenuItems1,
                elevation: 1,
                isDense: false,
                onChanged: onChangeDropdownItem1,
                icon:
                    Icon(Icons.keyboard_arrow_down, color: Appcolor.redHeader),
                value: _funers[_inx],
                hint: Text(
                  'Funizer',
                )),
          ),
          SizedBox(width: 20),
          new Flexible(
            child: new TextFormField(
              controller: _controllers1[_inx],
              decoration: InputDecoration(
                  hintText: 'Id',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_circle,
                      color: Appcolor.redHeader,
                    ),
                    onPressed: () {
                      this.setState(() {
                        if (rowCount1 > 1) rowCount1 = rowCount1 - 1;
                      });
                    },
                  )),
              keyboardType: TextInputType.phone,
              maxLength: 12,
            ),
          ),
        ],
      );
    }
  }

  _AddNewPlatform() {
    this.setState(() {
      TextEditingController ctrl = _controllers1[rowCount1 - 1];
      TextEditingController ctrlfurni = _controllersfurni[rowCount1 - 1];

      if (ctrl.text.length > 0 && ctrl.text.length > 0) {
        rowCount1 = rowCount1 + 1;
      }
    });
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
    Widget _myRadioButton({String title, int value, Function onChanged}) {
      return RadioListTile(
        value: value,
        groupValue: _groupValuenew,
        onChanged: onChanged,
        title: Text(title),
        activeColor: Appcolor.redHeader,
      );
    }

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
      body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text("Pasul 1 din 7",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontFamily: 'regular')),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Informatii personale",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: 'demi')),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Prenume'),
                    controller: _preName,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nume'),
                    controller: _name,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Adresa'),
                    controller: _address,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      new Flexible(
                        child: new TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Codul Postal',
                          ),
                          controller: _postalcode,
                          maxLength: 7,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(width: 20),
                      new Flexible(
                        child: new TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Orasul',
                          ),
                          controller: _orasol,
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Tara'),
                    controller: _tara,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nationalitate'),
                    controller: _nationality,
                  ),
                  contactSelectorWidget,
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: _email,
                  ),
                  socialSelectorWidget,
                  SizedBox(
                    height: 15,
                  ),
//                  OutlineButton(
//                    child: Stack(
//                      children: <Widget>[
//                        Align(
//                            alignment: Alignment.center,
//                            child: Text(
//                              "Adauga ala platforma",
//                            ))
//                      ],
//                    ),
//                    shape: new RoundedRectangleBorder(
//                        borderRadius: new BorderRadius.circular(20.0)),
//                    textColor: Colors.green,
//                    onPressed: () {
//                      _AddNewPlatform();
//                    }, //callback when button is clicked
//                    borderSide: BorderSide(
//                      color: Colors.green, //Color of the border
//                      style: BorderStyle.solid, //Style of the border
//                      width: 1, //width of the border
//                    ),
//                  ),
                  SizedBox(
                    height: 15,
                  ),
                  OutlineButton(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Text(
                              StrUserType == UserType.Student ||
                                      StrUserType == UserType.Pupil
                                  ? "Salveaza si inchide"
                                  : "Corect si inchide",
                            ))
                      ],
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    textColor: Colors.green,
                    onPressed: () {
                      if (StrUserType == UserType.Student ||
                          StrUserType == UserType.Pupil) {
                        if (createPayload() == true) {
                          _apiTo_addLetterofIntent().then((res) {
                            if (res == true) {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard(
                                            StrUserType: StrUserType)));
                              });
                            }
                          });
                        }




                      } else {
                        if (createPayload() == true) {
                          _apiTo_CorrectCareerPlan1().then((res) {
                            if (res == true) {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Dashboard(
                                            StrUserType: StrUserType)));
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
                            child: Text(
                                StrUserType == UserType.Student ||
                                        StrUserType == UserType.Pupil
                                    ? "Salveaza si mergi la pasul 2"
                                    : "Corect si mergi la pasul 2",
                                style: TextStyle(fontFamily: 'regular')))
                      ],
                    ),
                    onPressed: () {
                      if (StrUserType == UserType.Student ||
                          StrUserType == UserType.Pupil) {
                        if (createPayload() == true) {
//                      _apiTo_addLetterofIntent().then((res) {
//                        if (res == true)
//                        {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LetterofIntent_2(
                                        StrUserType: StrUserType)));
                          });
                          //  }
                          // });
                        }
                      } else {
                        if (createPayload() == true) {
                          // _apiTo_CorrectCareerPlan1().then((res) {
                          //  if (res == true)
                          //  {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LetterofIntent_2(
                                        StrUserType: StrUserType)));
                          });
                          // }
                          // });
                        }
                      }
                    },
                    color: Appcolor.AppGreen,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(height: 40),
                  Slider(
                    value: _value,
                    activeColor: Appcolor.AppGreen,
                    label: (_value+1).round().toString(),
                    inactiveColor: Colors.grey,
                    max: 6,
                    min: 0,
                    divisions: 6,
                    onChanged: (double newLowerValue) {
                      setState(() {
                        _value = newLowerValue;
                        strSelectedStep = StepList[_value.round()];
                      });
                    },
                  ),
                  Text("Pasul " + (_value+1).round().toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: 'demi')),
                  SizedBox(height: 20),
                  Text(strSelectedStep,
                      style: TextStyle(
                          color: Appcolor.redHeader,
                          fontSize: 16.0,
                          fontFamily: 'demi')),
                  SizedBox(height: 20),
                  new IconButton(
                    onPressed: () {
                      print("value = $_value");
                      if (_value == 0.0) {
                      } else if (_value == 1.0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LetterofIntent_2(
                                    StrUserType: StrUserType)));
                      } else if (_value == 2.0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LetterofIntent_3(
                                    StrUserType: StrUserType)));
                      } else if (_value == 3.0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LetterofIntent_4(
                                    StrUserType: StrUserType)));
                      } else if (_value == 4.0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LetterofIntent_5(
                                    StrUserType: StrUserType)));
                      } else if (_value == 5.0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LetterofIntent_6(
                                    StrUserType: StrUserType)));
                      } else if (_value == 6.0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LetterofIntent_7(
                                    StrUserType: StrUserType)));
                      }
                    },
                    //
                    //onPressed: _toggle,
                    icon: new Image(
                        image: AssetImage("Assets/Images/CareerplanEdit.png")),
                    color: Appcolor.redHeader,
                    iconSize: 20,
                  ),
                  // Image(image: new AssetImage("Assets/Images/DefaultUser.png"),width: 40,height: 40,),
                  SizedBox(height: 20),
                  Text("Editeaza pasul",
                      style: TextStyle(
                          color: Appcolor.redHeader,
                          fontSize: 14.0,
                          fontFamily: 'demi')),
                ],
              ),
            ),
          )),
//      drawer: Drawer(
//        child: SideMenu(StrUserType: StrUserType),
//      ),
    );
  }
}

class ContactNumber {
  int id;
  String name;
  ContactNumber(this.id, this.name);
  static List<ContactNumber> getUsers() {
    return <ContactNumber>[
      ContactNumber(1, 'Domiciliu'),
      ContactNumber(2, 'Loc de Munca'),
      ContactNumber(3, 'Mobil'),
    ];
  }
}

class Furnizer {
  int id;
  String name;
  Furnizer(this.id, this.name);
  static List<Furnizer> getUsers() {
    return <Furnizer>[
      Furnizer(1, 'Skype'),
      Furnizer(2, 'Linkdin'),
      Furnizer(3, 'Facebook'),
    ];
  }
}
