import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/CVCompletion/CVCompletion_4.dart';
import 'package:escouniv/EVROMenu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/HelperClass/DataCollected.dart';
class CVCompletion_3 extends StatefulWidget {
  @override
  UserType StrUserType;
  CVCompletion_3({Key key, @required this.StrUserType}) : super(key: key);
  _CVCompletion_3State createState() => _CVCompletion_3State(StrUserType);
}

class _CVCompletion_3State extends State<CVCompletion_3> {
  UserType StrUserType;
  String struserid;
  String strToDate;
  String strFromDate;
  final dateFormat = DateFormat("dd/MM/yyyy");
  bool _saving = false;
  Map userdata;
  Map _cv13;
  Map _cv12;
  Map _cv11;
  Map _cv10;
  Map _cv1;
  Map _cv2;
  Map _cv3=new Map();
  Map _cv4;
  Map _cv5;
  Map _cv6;
  Map _cv7;
  Map _cv8;
  Map _cv9;
  int rowCount = 1;
  List<Map> Payloaddata = new List();

  //Textfield controller-----------------------------------

  List<TextEditingController> _Numele_angajatorului = new List();
  List<TextEditingController> _todate = new List();
  List<TextEditingController> _fromDate = new List();
  List<TextEditingController> _Orasul = new List();
  List<TextEditingController> _Tara = new List();
  List<TextEditingController> _Adresa = new List();
  List<TextEditingController> _Codul_postal = new List();
  List<TextEditingController> _Site_web = new List();
  List<bool> _prezent = new List();
  List<TextEditingController> _Tipul_sau_sectorul_de_activitate = new List();
  List<TextEditingController> _Activitati_si_responsabilitati_principale = new List();

  _CVCompletion_3State(@required this.StrUserType);

  //API CALL-------------------------------
  Future<bool> _apiToAddCV() async {
    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.saveCV;
    final client = new http.Client();
    Map<String, String> _finalPayload = {
      "informatii_personale": json.encode(_cv1),
      "tip_aplicatie": json.encode(_cv2),
      "experienta_profesionala": json.encode(_cv3),
      "educatie_formare": json.encode(_cv4),
      "limba_materna": json.encode(_cv5),
      "limbi_straine": json.encode(_cv6),
      "competente_comunicare": json.encode(_cv7),
      "competente_manageriale": json.encode(_cv8),
      "competente_loc_de_munca": json.encode(_cv9),
      "competente_digitale": json.encode(_cv10),
      "alte_competente": json.encode(_cv11),
      "permis_conducere": json.encode(_cv12),
      "informatii_suplimentare": json.encode(_cv13),
      "user_id": struserid
    };

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

  Future<bool> __apiToCorrectCV() async {
    setState(() {
      _saving = true;
    });

    final String url = API.Base_url + API.CorrectCVRquest;
    final client = new http.Client();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVData') ?? '';
    Map _Correctiondata = json.decode(myString);

    Map<String, dynamic> dd = {
      "informatii_personale": _cv1,
      "tip_aplicatie": _cv2,
      "experienta_profesionala": _cv3,
      "educatie_formare": _cv4,
      "limba_materna": _cv5,
      "limbi_straine": _cv6,
      "competente_comunicare": _cv7,
      "competente_manageriale": _cv8,
      "competente_loc_de_munca": _cv9,
      "competente_digitale": _cv10,
      "alte_competente": _cv11,
      "permis_conducere": _cv12,
      "informatii_suplimentare": _cv13,
    };

    Map<String, dynamic> _finalPayload = {
      "new_data": json.encode(dd),
      "user_id": struserid,
      "onlinecv_id": _Correctiondata["cv_online_id"]
    };

    final streamedRest = await client.post(url,
        body: _finalPayload,
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.statusCode);
    setState(() {
      _saving = false;
    });
    if (streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
      return true;
    } else if (streamedRest.statusCode == 201) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["message"].toString());
      return false;
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

  SaveCreerPlan_PersonalInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CV3", json.encode(_cv3));
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

  Future<Null> FetchCVData() async {
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
      final str_CPobiective_dezvoltare_personala1 =
          prefs.getString('CV10') ?? '';
      _cv10 = json.decode(str_CPobiective_dezvoltare_personala1);
      //11-----------
      final str_CPobiective_dezvoltare_personala2 =
          prefs.getString('CV11') ?? '';
      _cv11 = json.decode(str_CPobiective_dezvoltare_personala2);
      //11-----------
      final str_CPobiective_dezvoltare_personala3 =
          prefs.getString('CV12') ?? '';
      _cv12 = json.decode(str_CPobiective_dezvoltare_personala3);
      //12-----------
      final str_CPobiective_dezvoltare_personala4 =
          prefs.getString('CV13') ?? '';
      _cv13 = json.decode(str_CPobiective_dezvoltare_personala4);
    });
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

  Future<bool> GetCVPlandata() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVData') ?? '';
    Map sem_data = json.decode(myString);

    String rrr = sem_data["experienta_profesionala"];

    // Payloaddata = [];
    if(rrr != null && rrr != "null") {
      Map sem_data1 = json.decode(rrr);
      List receiveddata = sem_data1["1567062840103"];
      List<TextEditingController> _tempNumele_angajatorului = new List();
      List<TextEditingController> _temptodate = new List();
      List<TextEditingController> _temofromDate = new List();
      List<TextEditingController> _tempOrasul = new List();
      List<TextEditingController> _tempTara = new List();
      List<TextEditingController> _tempAdresa = new List();
      List<TextEditingController> _tempCodul_postal = new List();
      List<TextEditingController> _tempSite_web = new List();
      List<bool> _tempprezent = new List();
      List<TextEditingController> _tempTipul_sau_sectorul_de_activitate = new List();
      List<TextEditingController> _tempActivitati_si_responsabilitati_principale = new List();
      //for Fetch value and set on textfield--
      int gg = receiveddata.length;
      print("number of count = $gg");
      for (int v = 0; v < receiveddata.length; v++) {
        Map plandata = receiveddata[v];

        TextEditingController t1 = TextEditingController();
        t1.text = plandata["durataDin"].toString();
        _temptodate.add(t1);

        TextEditingController t2 = TextEditingController();
        t2.text = plandata["durataPana"].toString();
        _temofromDate.add(t2);

        TextEditingController t3 = TextEditingController();
        t3.text = plandata["responsabilitati"].toString();
        _tempActivitati_si_responsabilitati_principale.add(t3);

        TextEditingController t4 = TextEditingController();
        t4.text = plandata["angajatorSectorActivitate"].toString();
        _tempTipul_sau_sectorul_de_activitate.add(t4);

        TextEditingController t5 = TextEditingController();
        t5.text = plandata["angajatorSite"].toString();
        _tempSite_web.add(t5);

        TextEditingController t6 = TextEditingController();
        t6.text = plandata["angajatorCodPostal"].toString();
        _tempCodul_postal.add(t6);

        TextEditingController t7 = TextEditingController();
        t7.text = plandata["angajatorTara"].toString();
        _tempTara.add(t7);

        TextEditingController t8 = TextEditingController();
        t8.text = plandata["angajatorAdresa"].toString();
        _tempAdresa.add(t8);

        TextEditingController t9 = TextEditingController();
        t9.text = plandata["angajatorOras"].toString();
        _tempOrasul.add(t9);

//        TextEditingController t10 = TextEditingController();
//        t10.text = plandata["functia"].toString();
//        _tempOrasul.add(t10);

        TextEditingController t11 = TextEditingController();
        t11.text = plandata["angajatorDenumire"].toString();
        _tempNumele_angajatorului.add(t11);
       // _prezent.add(false);
       // Payloaddata.add(plandata);
      }

      // Reload here
      setState(() {
        rowCount = 0;
        _todate = _temptodate;
        _fromDate = _temofromDate;
        _Activitati_si_responsabilitati_principale =
            _tempActivitati_si_responsabilitati_principale;
        _Tipul_sau_sectorul_de_activitate =
            _tempTipul_sau_sectorul_de_activitate;
        _Site_web = _tempSite_web;
        _Codul_postal = _tempCodul_postal;
        _Tara = _tempTara;
        _Adresa = _tempAdresa;
        _Orasul = _tempAdresa;
        _Numele_angajatorului = _tempNumele_angajatorului;
        rowCount = _Activitati_si_responsabilitati_principale.length;
      });
    }else
    {
      print("came here llll");
      setState(() {
        rowCount = 1;
        var tt  = TextEditingController();
        tt.text = "";
        var tt1  = TextEditingController();
        tt1.text = "";
        _fromDate.add(tt);
        _todate.add(tt1);
      });
    }

  }

  @override
  void initState() {
    super.initState();
    GetUserdata();
    GetCVPlandata();
    FetchCVData();
    super.initState();
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
  Widget build(BuildContext context) {

    bool createPayload() {
      int _inx = rowCount - 1;
      if (_Numele_angajatorului[_inx].text.length < 1) {
        showMyDialog(context, "Te rog intra angajatorului");
        return false;
      }
      if (_todate[_inx].text.length < 1) {
        showMyDialog(context, "Te rog intra la");
        return false;
      }
      if (_fromDate[_inx].text.length < 1) {
        showMyDialog(context, "Te rog intra  De la");
        return false;
      }
      if (_Orasul[_inx].text.length < 1) {
        showMyDialog(context, "Te rog intra ora");
        return false;
      }
      if (_Tara[_inx].text.length < 1) {
        showMyDialog(context, "Te rog intra tara");
        return false;
      }
      if (_Codul_postal[_inx].text.length < 1) {
        showMyDialog(context, "Te rog intra Codul postal");
        return false;
      }
      if (_Site_web[_inx].text.length < 1) {
        showMyDialog(context, "Te rog intra Site web");
        return false;
      }
      if (_Adresa[_inx].text.length < 1) {
        showMyDialog(context, "Te rog intra Adresa");
        return false;
      }

      Map sem = {
        "durataDin": _todate[_inx].text.toString(),
        "durataPana": _fromDate[_inx].text.toString(),
        "functia": _Numele_angajatorului[_inx].text.toString(),
        "angajatorDenumire": _Numele_angajatorului[_inx].text.toString(),
        "responsabilitati":
        _Activitati_si_responsabilitati_principale[_inx].text.toString(),
        "angajatorSectorActivitate":
        _Tipul_sau_sectorul_de_activitate[_inx].text.toString(),
        "angajatorSite": _Site_web[_inx].text.toString(),
        "angajatorCodPostal": _Codul_postal[_inx].text.toString(),
        "angajatorTara": _Tara[_inx].text.toString(),
        "angajatorAdresa": _Adresa[_inx].text.toString(),
        "angajatorOras": _Orasul[_inx].text.toString(),
      };

      Payloaddata.add(sem);

      _cv3 = {
        "1567062840103": Payloaddata,
      };
      SaveCreerPlan_PersonalInfo();
      return true;
    }

    _AddNewPlatform(int _inx) {
      this.setState(() {
        if (_Numele_angajatorului[_inx].text.length < 1) {
          showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
          return false;
        }
        if (_todate[_inx].text.length < 1) {
          showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
          return false;
        }
        if (_Orasul[_inx].text.length < 1) {
          showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
          return false;
        }
        if (_Tara[_inx].text.length < 1) {
          showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
          return false;
        }
        if (_Codul_postal[_inx].text.length < 1) {
          showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
          return false;
        }
        if (_Site_web[_inx].text.length < 1) {
          showMyDialog(context, "Vă rugăm să introduceți site");
          return false;
        }
        if (_Adresa[_inx].text.length < 1) {
          showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
          return false;
        }

        Map sem = {
          "durataDin": _todate[_inx].text.toString(),
          "durataPana": _fromDate[_inx].text.toString(),
          "functia": _Numele_angajatorului[_inx].text.toString(),
          "angajatorDenumire": _Numele_angajatorului[_inx].text.toString(),
          "responsabilitati":
          _Activitati_si_responsabilitati_principale[_inx].text.toString(),
          "angajatorSectorActivitate":
          _Tipul_sau_sectorul_de_activitate[_inx].text.toString(),
          "angajatorSite": _Site_web[_inx].text.toString(),
          "angajatorCodPostal": _Codul_postal[_inx].text.toString(),
          "angajatorTara": _Tara[_inx].text.toString(),
          "angajatorAdresa": _Adresa[_inx].text.toString(),
          "angajatorOras": _Orasul[_inx].text.toString(),
        };
        rowCount = rowCount + 1;


        var tt  = TextEditingController();
        tt.text = "";
        _todate.add(tt);
        _fromDate.add(tt);
        Payloaddata.add(sem);
        _cv3 = {
          "1567062840103": Payloaddata,
        };

        SaveCreerPlan_PersonalInfo();
      });
    }

    Widget _forLastinde(int _inx) {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Flexible(
                child: DateTimePickerFormField(
                    format: dateFormat,
                    controller: _fromDate[_inx],
                    decoration: InputDecoration(labelText: 'De la'),
                    editable: false,
                    dateOnly: true,
                    onChanged: (date) {
                      setState(() {
                        //
                      });
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text('$date'),));
                    }),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: DateTimePickerFormField(
                    format: dateFormat,
                    controller: _todate[_inx],
                    decoration: InputDecoration(labelText: 'La'),
                    editable: false,
                    dateOnly: true,
                    onChanged: (date) {
                      setState(() {
                        //
                      });
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text('$date'),));
                    }
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                width: 150,
              ),
              Checkbox(
                value: _prezent[_inx],
                onChanged: (bool value) {
                  setState(() {
                    _prezent[_inx] = value;
                    if(value == true)
                    {
                      var now = new DateTime.now();
                      _todate[_inx].text = dateFormat.format(now);
                    }

                  });
                },
              ),
              Text("Prezent")

            ],
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Numele angajatorului'),
            controller: _Numele_angajatorului[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Orasul'),
            controller: _Orasul[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Tara'),
            controller: _Tara[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Adresa'),
            controller: _Adresa[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Codul postal'),
            controller: _Codul_postal[_inx],
          ),
          TextFormField(
              decoration: InputDecoration(labelText: 'Site web'),
              controller: _Site_web[_inx]),
          TextFormField(
            decoration:
            InputDecoration(labelText: 'Tipul sau sectorul de activitate'),
            controller: _Tipul_sau_sectorul_de_activitate[_inx],
          ),
          TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
                labelText: 'Activitati si responsabilitati principale',
                hintMaxLines: 6),
            controller: _Activitati_si_responsabilitati_principale[_inx],
          ),
          SizedBox(
            height: 20,
          ),
          OutlineButton(
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      rowCount - 1 == _inx
                          ? "Adaugati o experiență profesională"
                          : "Eliminați o experienta profesionala",
                    ))
              ],
            ),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)),
            textColor: rowCount - 1 == _inx ? Colors.green : Colors.red,
            onPressed: () {
              setState(() {
                if (rowCount - 1 == _inx) {
                  _AddNewPlatform(_inx);
                } else {
                  if (rowCount > 1) {
                    rowCount = rowCount - 1;
                    _fromDate.removeAt(_inx);
                    _todate.removeAt(_inx);
                    Payloaddata.removeAt(_inx);
                  }
                }
              });
            }, //callback when button is clicked
            borderSide: BorderSide(
              color: rowCount - 1 == _inx ? Colors.green : Colors.red,
              style: BorderStyle.solid, //Style of the border
              width: 1, //width of the border
            ),
          ),

        ],
      );
    }



    Future<void> _ackAlert(BuildContext context) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            margin: EdgeInsets.all(20),
            color: Colors.transparent,
            child: questionWidget.Dialogview(),
          );
        },
      );
    }

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
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(25.0),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text("Pasul 3 din 13",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                          fontFamily: 'regular')),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Experienta profesionala",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: 'demi')),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: rowCount,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      _Numele_angajatorului.add(new TextEditingController());
                      _Orasul.add(new TextEditingController());
                      _Tara.add(new TextEditingController());
                      _Adresa.add(new TextEditingController());
                      _Codul_postal.add(new TextEditingController());
                      _Site_web.add(new TextEditingController());
                      _prezent.add(false);
                      _Tipul_sau_sectorul_de_activitate.add(
                          new TextEditingController());
                      _Activitati_si_responsabilitati_principale.add(
                          new TextEditingController());
                      return Container(
                        height: 800,
                        child: _forLastinde(index),
                      );
                    },
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
                          _apiToAddCV().then((res) {
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
                          __apiToCorrectCV().then((res) {
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
                            child: Text("Salvați și mergeți la pasul 4",
                                style: TextStyle(fontFamily: 'regular')))
                      ],
                    ),
                    onPressed: () {
                      if (createPayload() == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CVCompletion_4(StrUserType: StrUserType)));
                      }
                    },
                    color: Appcolor.AppGreen,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
