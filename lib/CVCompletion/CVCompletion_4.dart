import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/CVCompletion/CVCompletion_5.dart';
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
class CVCompletion_4 extends StatefulWidget {
  @override
  UserType  StrUserType;
  CVCompletion_4({Key key, @required this.StrUserType}) : super(key: key);
  _CVCompletion_4State createState() => _CVCompletion_4State(StrUserType);
}

class _CVCompletion_4State extends State<CVCompletion_4> {
  UserType  StrUserType;
  String struserid;
  bool _saving = false;
  Map userdata;
  String strToDate;
  String strFromDate;
  List<Map> Payloaddata = new List();
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
  int rowCount = 1;
  int _groupValuenew = -1;

  List<TextEditingController> _Titlu = new List();
  // List<TextEditingController> _todate = new List();

  List<TextEditingController> _d1 = new List();
  List<TextEditingController> _d2 = new List();
//  List<TextEditingController> _fromDate = new List();
  List<TextEditingController> _Denumirea = new List();
  List<TextEditingController> _Orasul = new List();
  List<TextEditingController> _Tara = new List();
  List<TextEditingController> _Addres = new List();
  List<TextEditingController> _Postelcode = new List();
  List<TextEditingController> _Site_web = new List();
  List<TextEditingController> _Specificati = new List();
  List<TextEditingController> _Deisciplinere = new List();
  List<TextEditingController> _Domeniul = new List();
  List<bool> _prezent = new List();

  final dateFormat = DateFormat("dd/MM/yyyy");

  _CVCompletion_4State(@required this.StrUserType);


  //MARK= API CALL-------------------------
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

  //MARK:- Private methods-------------------
  SaveCreerPlan_PersonalInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CV4", json.encode(_cv1));
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
    int _inx = rowCount - 1;
    if(_d2[_inx].text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți de la");
      return false;
    }
    if(_d1[_inx].text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți la");
      return false;
    }
    if(_Titlu[_inx].text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți titlu");
      return false;
    }
    if(_Denumirea[_inx].text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți denumirea");
      return false;
    }
    if(_Orasul[_inx].text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți codul poștal");
      return false;
    }
    if(_Tara[_inx].text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți țara");
      return false;
    }
    if(_Addres[_inx].text.length <1) {

      showMyDialog(context,"Introduceți codul de address");
      return false;
    }
    if(_Postelcode[_inx].text.length <1) {

      showMyDialog(context,"Introduceți codul de postel code");
      return false;
    }

    Map  sem = {
      "durataDin":_prezent[_inx] == true?"Present":_d2[_inx].text.toString(),
      "durataPana":_d1[_inx].text.toString(),
      "Title":_Titlu[_inx].text.toString(),
      //  "diploma":_D[_inx].text.toString(),
      "Domain":_Domeniul[_inx].text.toString(),
      "institutieSite":_Site_web[_inx].text.toString(),
      "institutieCodPostal":_Postelcode[_inx].text.toString(),
      "institutieTara":_Tara[_inx].text.toString(),
      "institutieAdresa":_Addres[_inx].text.toString(),
      "institutieOras":_Orasul[_inx].text.toString(),
      "institutieDenumire":_Denumirea[_inx].text.toString(),
      // "nivelCEC":_Deisciplinere[_inx].text.toString(),
      "Specification":_Specificati[_inx].text.toString(),
      "Disciplin":_Deisciplinere[_inx].text.toString(),

    };
    Payloaddata.add(sem);

    _cv4 = {
      "1567062840103": Payloaddata,
    };

    SaveCreerPlan_PersonalInfo();
    return true;

  }
  _AddNewPlatform(int _inx) {
    this.setState(() {
      if(_d2[_inx].text.length <1) {

        showMyDialog(context,"Vă rugăm să introduceți prenumele");
        return false;
      }
      if(_Titlu[_inx].text.length <1) {

        showMyDialog(context,"Vă rugăm să introduceți titlu");
        return false;
      }
      if(_Denumirea[_inx].text.length <1) {

        showMyDialog(context,"Vă rugăm să introduceți adresa");
        return false;
      }
      if(_Orasul[_inx].text.length <1) {

        showMyDialog(context,"Vă rugăm să introduceți codul poștal");
        return false;
      }
      if(_Tara[_inx].text.length <1) {

        showMyDialog(context,"Vă rugăm să introduceți țara");
        return false;
      }

      Map  sem = {
        "durataDin":_d2[_inx].text.toString(),
        "durataPana":_d1[_inx].text.toString(),
        "Title":_Titlu[_inx].text.toString(),
        "Denumirea":_Denumirea[_inx].text.toString(),
        "Domain":_Domeniul[_inx].text.toString(),
        "institutieSite":_Site_web[_inx].text.toString(),
        "institutieCodPostal":_Postelcode[_inx].text.toString(),
        "institutieTara":_Tara[_inx].text.toString(),
        "institutieAdresa":_Addres[_inx].text.toString(),
        "institutieOras":_Orasul[_inx].text.toString(),
        "institutieDenumire":_Denumirea[_inx].text.toString(),
        // "nivelCEC":_Deisciplinere[_inx].text.toString(),
        "Specification":_Specificati[_inx].text.toString(),
        "Disciplin":_Deisciplinere[_inx].text.toString(),

      };

      rowCount = rowCount + 1;
      var tt  = TextEditingController();
      tt.text = "";
      var tt2  = TextEditingController();
      tt2.text = "";
      _d2.add(tt);
      _d1.add(tt2);

      Payloaddata.add(sem);
      _cv4 = {
        "1567062840103": Payloaddata,
      };

      SaveCreerPlan_PersonalInfo();
    });
  }

  Future<Null> GetCVPlandata() async
  {
    Map plandata;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('CVData') ?? '';
    Map sem_data = json.decode(myString);
    String rrr = sem_data["educatie_formare"];
var ss  = rrr.contains("1567062840103");

print(" yes present = $ss");
    if(rrr != null && rrr != "null" && ss == true)
    {
      Map sem_data1 = json.decode(rrr);

      //solve temp value---------------------
      List<TextEditingController> _tempTitlu = new List();
      List<TextEditingController> _temptodate = new List();
      List<TextEditingController> _tempfromDate = new List();
      List<TextEditingController> _tempDenumirea = new List();
      List<TextEditingController> _tempOrasul = new List();
      List<TextEditingController> _tempTara = new List();
      List<TextEditingController> _tempAddres = new List();
      List<TextEditingController> _tempPostelcode = new List();
      List<TextEditingController> _tempSite_web = new List();
      List<TextEditingController> _tempSpecificati = new List();
      List<TextEditingController> _temoDeisciplinere = new List();
      List<TextEditingController> _tempDomeniul = new List();
      List<bool> _prezent = new List();
      //--------------------------------------
      print("rrr va;lue =$sem_data1");
      List receiveddata = sem_data1["1567062840103"];
      for (int v = 0; v < receiveddata.length; v++) {
        Map plandata = receiveddata[v];
        //----------------------------------
        TextEditingController t1 = TextEditingController();
        //Present
        if(plandata["durataDin"].toString() == "Present")
        {
          t1.text = plandata["durataDin"];
          _temptodate.add(t1);
          var now = new DateTime.now();
          t1.text = dateFormat.format(now);
          _temptodate.add(t1);
          _prezent.add(true);
        }
        else
        {
          t1.text = plandata["durataDin"];
          _temptodate.add(t1);
          _prezent.add(false);
        }

        TextEditingController t2 = TextEditingController();
        t2.text = plandata["durataPana"].toString();
        _tempfromDate.add(t2);

        TextEditingController t3 = TextEditingController();
        t3.text = plandata["Title"].toString();
        _tempTitlu.add(t3);

        TextEditingController t4 = TextEditingController();
        t4.text = plandata["Domain"].toString();
        _tempDomeniul.add(t4);

        TextEditingController t5 = TextEditingController();
        t5.text = plandata["institutieSite"].toString();
        _tempSite_web.add(t5);

        TextEditingController t6 = TextEditingController();
        t6.text = plandata["institutieCodPostal"].toString();
        _tempPostelcode.add(t6);

        TextEditingController t7 = TextEditingController();
        t7.text = plandata["institutieTara"].toString();
        _tempTara.add(t7);

        TextEditingController t8 = TextEditingController();
        t8.text = plandata["institutieAdresa"].toString();
        _tempAddres.add(t8);

        TextEditingController t9 = TextEditingController();
        t9.text = plandata["institutieOras"].toString();
        _tempOrasul.add(t9);

        TextEditingController t10 = TextEditingController();
        t10.text = plandata["institutieDenumire"].toString();
        _tempOrasul.add(t10);

        TextEditingController t11 = TextEditingController();
        t11.text = plandata["Specification"].toString();
        _tempSpecificati.add(t11);

        TextEditingController t12 = TextEditingController();
        t12.text = plandata["Disciplin"].toString();
        _temoDeisciplinere.add(t12);

        TextEditingController t13 = TextEditingController();
        t13.text = plandata["Denumirea"].toString();
        _tempDenumirea.add(t13);

      }

      setState(() {
        // rowCount = 0;
        _d2 = _temptodate;
        _Titlu = _tempTitlu;
        _Domeniul = _tempDomeniul;
        print("print date data = $_Domeniul");
        _Site_web = _tempSite_web;
        _Postelcode = _tempPostelcode;
        _Tara = _tempTara;
        _Addres = _tempAddres;
        _Orasul = _tempOrasul;
        _Denumirea = _tempDenumirea;
        _Specificati = _tempSpecificati;
        _Deisciplinere = _temoDeisciplinere;
        _d1 = _tempfromDate;
        rowCount = _d1.length;

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
      _d1.add(tt);
      _d2.add(tt1);
      });
    }



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


  @override
  void initState() {
    super.initState();
    GetUserdata();
    GetCVPlandata();
    FetchCVData();
    super.initState();
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



    Widget _forLastinde(int _inx) {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[

              new Flexible(
                child:  DateTimePickerFormField(format: dateFormat,controller:  _d1[_inx],decoration: InputDecoration(labelText: 'De la') ,editable: true,dateOnly:true, onChanged: (date) {
                  setState(() {
                    //
                  });
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text('$date'),));

                }),
              ),
              SizedBox(width: 10,),
              new Flexible(
                child:  DateTimePickerFormField(format: dateFormat,controller: _d2[_inx],decoration: InputDecoration(labelText: 'La'),editable: true,dateOnly:true, onChanged: (date) {
                  setState(() {
                    //
                  });
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text('$date'),));

                }),
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
                      _d2[_inx].text = dateFormat.format(now);
                    }

                  });
                },
              ),
              Text("Prezent")

            ],
          ),
          SizedBox(height: 20,),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Titlu certificatului sau diplomei obtinute'
            ),
            controller: _Titlu[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Denumirea institutiei de invatamant'
            ),
            controller: _Denumirea[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Orasul'
            ),
            controller: _Orasul[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Tara'
            ),
            controller: _Tara[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Adresa'
            ),
            controller: _Addres[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Codul postal'
            ),
            controller: _Postelcode[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Site web'
            ),
            controller: _Site_web[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Specificati nivelul CEC sau clasificarea la nivel national',
                labelStyle: new TextStyle(
                  fontSize: 14.0,

                )
            ),
            controller: _Specificati[_inx],
          ),
          TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Deisciplinere principale studiate',


            ),
            controller: _Deisciplinere[_inx],
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Domeniul de studii'
            ),
            controller: _Domeniul[_inx],
          ),
          SizedBox(height: 10,),
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
          SizedBox(
            height: 20,
          ),
        ],
      );
    }

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

        body: ModalProgressHUD(inAsyncCall: _saving, child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30,),
                Text(
                    "Pasul 4 din 13",
                    style:
                    TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
                ),
                SizedBox(height: 10,),
                Text(
                    "Educatie si formare",
                    style:
                    TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'demi')
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: rowCount,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    _Titlu.add(new TextEditingController());

                    _Denumirea.add(new TextEditingController());
                    _Orasul.add(new TextEditingController());
                    _Tara.add(new TextEditingController());
                    _Addres.add(new TextEditingController());
                    _Postelcode.add(new TextEditingController());
                    _Site_web.add(new TextEditingController());
                    _Specificati.add(new TextEditingController());
                    _Deisciplinere.add(new TextEditingController());
                    _Domeniul.add(new TextEditingController());
                    _prezent.add(false);

                    return Container(
                      height: 900,
                      child: _forLastinde(index),
                    );
                  },
                ),

                SizedBox(height: 20,),
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
                              "Salvați și mergeți la pasul 5", style: TextStyle(fontFamily: 'regular')
                          )
                      )
                    ],
                  ),
                  onPressed: (){
                    if (createPayload() == true)
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CVCompletion_5(StrUserType: StrUserType)));
                    }
                  },
                  color: Appcolor.AppGreen,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),

                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),)
    );
  }
}

