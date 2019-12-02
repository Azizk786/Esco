import 'package:flutter/material.dart';
import 'package:escouniv/CVCompletion/CVCompletion_7.dart';
import 'package:escouniv/Constant/Constant.dart';
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
class CVCompletion_6 extends StatefulWidget {
  @override
  UserType  StrUserType;
  CVCompletion_6({Key key, @required this.StrUserType}) : super(key: key);
  _CVCompletion_6State createState() => _CVCompletion_6State(StrUserType);
}

class _CVCompletion_6State extends State<CVCompletion_6> {
  UserType  StrUserType;
  String struserid;
  bool _saving = false;
  int rowCount = 1;
  Map userdata;
  int _valueOf = 0;
  List<String> _inte = new List();
  List<String> _Citire =new List();
  List<String> _Vorbire = new List();
  List<String> _Discurs = new List();
  List<String> _Scriere = new List();
  List<String> _selectedContactType = new List();

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

  List<Map> Payloaddata = new List();
  List<String> _users = ["Romania","English","Other","Selectați"];

  _CVCompletion_6State(this.StrUserType);

  SaveCreerPlan_PersonalInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CV6", json.encode(_cv6));
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

  Future<Null>  FetchCVData() async
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

    if(_selectedContactType[rowCount-1] == _users[_users.length-1])
      {
        showMyDialog(context, "Selecteaza limba");
        return false;
      }
    if(_Citire[rowCount-1].length<1)
    {
      showMyDialog(context, "Selecteaza citire");
      return false;
    }
    if(_Scriere[rowCount-1].length<1)
    {
      showMyDialog(context, "Selecteaza scriere");
      return false;
    }
    if(_Discurs[rowCount-1].length<1)
    {
      showMyDialog(context, "Selecteaza Discurs oral");
      return false;
    }
    if(_inte[rowCount-1].length<1)
    {
      showMyDialog(context, "Selecteaza conversatie");
      return false;
    }
    if(_Vorbire[rowCount-1].length<1)
    {
      showMyDialog(context, "Selecteaza vorbire");
      return false;
    }
    if(_inte[rowCount-1].length<1)
    {
      showMyDialog(context, "Selecteaza Intelegere");
      return false;
    }

    Map sem = {
      "limba":_selectedContactType[rowCount-1],
      "citire":_Citire[rowCount-1],
      "scriere":_Scriere[rowCount-1],
      "discurs":_Discurs[rowCount-1],
      "conversatie":_inte[rowCount-1],
      "ascultare":_Vorbire[rowCount-1],
    };
    Payloaddata.add(sem);
    _cv6 = {
      "1567069845882":Payloaddata,
    };

    SaveCreerPlan_PersonalInfo();
    return true;
  }
  Future<Null>   GetCVPlandata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final myString = prefs.getString('CVData') ?? '';
    Map sem_data = json.decode(myString);

    String rrr = sem_data["limbi_straine"];
    Map sem_data1 = json.decode(rrr);

    print("rrr va;lue =$sem_data1");
    List receiveddata = sem_data1["1567069845882"];
    List <String>_tempCitire = [];
    List <String>_tempScriere = [];
    List <String>_tempDiscurs = [];
    List <String>_tempinte = [];
    List <String>_tempVorbire = [];
    List <String> tempC = [];
    for (int v = 0; v < receiveddata.length; v++) {
      Map plandata = receiveddata[v];
     _tempCitire.add(plandata["citire"].toString());
      _tempScriere.add(plandata["scriere"].toString());
      _tempDiscurs.add(plandata["discurs"].toString());
      _tempinte.add(plandata["conversatie"].toString());
      _tempVorbire.add(plandata["ascultare"].toString());
      tempC.add(plandata["limba"].toString());
      Payloaddata.add(plandata);

    }
      setState(() {
        rowCount = 0;
      _Citire = _tempCitire;
      _Scriere = _tempScriere;
      _Discurs = _tempDiscurs;
      _inte = _tempinte;
      _Vorbire = _tempVorbire;
      _selectedContactType = tempC;
      rowCount = _Citire.length;

    });

  }
  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedContactType.add(_users[_users.length-1]);
    _inte.add("");
    _Citire.add("");
    _Vorbire.add("");
    _Discurs.add("");
    _Scriere.add("");
    GetUserdata();
    GetCVPlandata();
    FetchCVData();
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


    Widget Dialogview(int _inx)
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
                   if(_valueOf == 1)
                     {
                       _inte[_inx] =  family[index][0];//+"|"+family[index][1]+family[index][2];
                     }
                 else  if(_valueOf == 2)
                   {
                     _Citire[_inx] =  family[index][0];//+"|"+family[index][1]+family[index][2];
                   }
                   else  if(_valueOf == 3)
                   {
                     _Vorbire[_inx] =  family[index][0];//+"|"+family[index][1]+family[index][2];

                   }
                   else  if(_valueOf == 4)
                   {
                     _Discurs[_inx] =  family[index][0];//+"|"+family[index][1]+family[index][2];

                   }
                   else  if(_valueOf == 5)
                   {
                     _Scriere[_inx] =  family[index][0];//+"|"+family[index][1]+family[index][2];
                   }

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
    _AddNewPlatform(int _inx) {

      if(_selectedContactType[_inx] == _users[_users.length-1])
      {
        showMyDialog(context, "Selecteaza limba");
        return false;
      }
      if(_Citire[_inx].length<1)
      {
        showMyDialog(context, "Selecteaza citire");
        return false;
      }
      if(_Scriere[_inx].length<1)
      {
        showMyDialog(context, "Selecteaza scriere");
        return false;
      }
      if(_Discurs[rowCount-1].length<1)
      {
        showMyDialog(context, "Selecteaza Discurs oral");
        return false;
      }
      if(_inte[_inx].length<1)
      {
        showMyDialog(context, "Selecteaza conversatie");
        return false;
      }
      if(_Vorbire[_inx].length<1)
      {
        showMyDialog(context, "Selecteaza vorbire");
        return false;
      }
      if(_inte[_inx].length<1)
      {
        showMyDialog(context, "Selecteaza Intelegere");
        return false;
      }

      Map sem = {
        "limba":_selectedContactType[_inx],
        "citire":_Citire[_inx],
        "scriere":_Scriere[_inx],
        "discurs":_Discurs[_inx],
        "conversatie":_inte[_inx],
        "ascultare":_Vorbire[_inx],
      };
      Payloaddata.add(sem);
      _cv6 = {
        "1567069845882":Payloaddata,
      };

      SaveCreerPlan_PersonalInfo();
      rowCount = rowCount+1;
      _selectedContactType.add(_users[_users.length-1]);
      _inte.add("");
      _Citire.add("");
      _Vorbire.add("");
      _Discurs.add("");
      _Scriere.add("");
      return true;
    }

    Future<void> _ackAlert(BuildContext context,int _inx) {
      return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return  Container(
            margin: EdgeInsets.all(20),
            color: Colors.transparent,
            child: Dialogview(_inx),
          );
        },
      );
    };
    Widget _forLastinde(int _inx) {
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 60,
            child: DropdownButton(
              value: _selectedContactType[_inx],
              isDense: true,
              onChanged: (String SelectedUser) {
                setState(() {
                  _selectedContactType[_inx] = SelectedUser;
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

          SizedBox(height: 5,),
          Text(
              "Intelegere",
              style:
              TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
          ),
          FlatButton(onPressed: (){ setState(() {
            _valueOf = 1; _ackAlert(context,_inx);
            print(_inte);
          });},child: Text(_inte[_inx],overflow: TextOverflow.ellipsis,
              style:
              TextStyle(color: Colors.black87, fontSize: 18.0, fontFamily: 'regular')),),
          aGreyHorizonalLine,
          SizedBox(height: 5,),
          Text(
              "Citire",
              style:
              TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
          ),
          FlatButton(onPressed: (){ setState(() {
            _valueOf = 2; _ackAlert(context,_inx);
            print(_Citire);
          });},child: Text(_Citire[_inx],overflow: TextOverflow.ellipsis,style:
          TextStyle(color: Colors.black87, fontSize: 18.0, fontFamily: 'regular')),),
          aGreyHorizonalLine,
          SizedBox(height: 5,),
          Text(
              "Vorbire",
              style:
              TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
          ),
          FlatButton(onPressed: (){ setState(() {
            _valueOf = 3; _ackAlert(context,_inx);
            print(_Citire);
          });},child: Text(_Vorbire[_inx],overflow: TextOverflow.ellipsis,style:
          TextStyle(color: Colors.black87, fontSize: 18.0, fontFamily: 'regular')),),
          aGreyHorizonalLine,
          SizedBox(height: 5,),
          Text(
              "Discurs oral",
              style:
              TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
          ),
          FlatButton(onPressed: (){ setState(() {
            _valueOf = 4; _ackAlert(context,_inx);
            print(_Citire);
          });},child: Text(_Discurs[_inx],overflow: TextOverflow.ellipsis,style:
          TextStyle(color: Colors.black87, fontSize: 18.0, fontFamily: 'regular')),),
          aGreyHorizonalLine,
          SizedBox(height: 5,),
          Text(
              "Scriere",
              style:
              TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
          ),
          FlatButton(onPressed: (){ setState(() {
            _valueOf = 5; _ackAlert(context,_inx);
            print(_Citire);
          });},child: Text(_Scriere[_inx],overflow: TextOverflow.ellipsis,style:
          TextStyle(color: Colors.black87, fontSize: 18.0, fontFamily: 'regular')),),
          aGreyHorizonalLine,
          SizedBox(height: 15,),
          OutlineButton(
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      rowCount - 1 == _inx
                          ? "Adaugati inca un camp"
                          : "Eliminați inca un camp",
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
        ],
      );
    }


    return ModalProgressHUD(inAsyncCall: _saving, child:  Scaffold(
      appBar: AppBar(
        title: Text("Completare CV"),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.help_outline),
            onTap: () {
              _ackAlert(context,0);
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
        child: Container(

          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Text(
                  "Pasul 6 din 13",
                  style:
                  TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
              ),
              SizedBox(height: 10,),
              Text(
                  "Alte limbi straine cunoscute",
                  style:
                  TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'demi')
              ),
              SizedBox(height: 30,),
              ListView.builder(
                shrinkWrap: true,
                itemCount: rowCount,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 500,
                    child: _forLastinde(index),
                  );
                },
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
              SizedBox(height: 15),
              RaisedButton(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,

                        child: Text(
                            "Salvați și mergeți la pasul 7", style: TextStyle(fontFamily: 'regular')
                        )
                    )
                  ],
                ),
                onPressed: (


                    ){
                  if (createPayload() == true)
                  {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => CVCompletion_7(StrUserType: StrUserType)));
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
    ));
  }
}




