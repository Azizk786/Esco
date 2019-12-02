import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/Career Plan/CareerPlan_2.dart';
import 'package:escouniv/Career Plan/CareerPlan_3.dart';
import 'package:escouniv/Career Plan/CareerPlan_4.dart';
import 'package:escouniv/Career Plan/CareerPlan_5.dart';
import 'package:escouniv/Career Plan/CareerPlan_6.dart';
import 'package:escouniv/Career Plan/CareerPlan_7.dart';
import 'package:escouniv/Career Plan/CareerPlan_8.dart';
import 'package:escouniv/Career Plan/CareerPlan_9.dart';
import 'package:escouniv/Career Plan/CareerPlan_10.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' ;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/CustomWidget/Selector.dart';

enum SingingCharacter { radio1, radio2 }

class CareerPlan_1 extends StatefulWidget {
  @override
  UserType  StrUserType;
  CareerPlan_1({Key key, @required this.StrUserType}) : super(key: key);
  _CareerPlan_1State createState() => _CareerPlan_1State(StrUserType);
}


class _CareerPlan_1State extends State<CareerPlan_1> {

  //*> Contact Selector
  Selector contactSelectorWidget = new Selector(selectorTypes: ["Domiciliu", "Loc de Munca", "Mobil", "Telefon(Oane)"], placeHolder:"Telefon(Oane)", keyboardType: KeyBoardType.phone);

  //*> Social Selector
  Selector socialSelectorWidget = new Selector(selectorTypes: ["Skype", "Linkedin", "Facebook"], placeHolder:"Id", keyboardType: KeyBoardType.email);


  double _value = 0;
  UserType  StrUserType;
  String struserid;
  int rowCount = 1;
  int rowCount1 = 1;
  String  _sex = "Masculin";
  String _strDob;
  bool _saving = false;
  SingingCharacter _character = SingingCharacter.radio1;
  _CareerPlan_1State( this.StrUserType);
  Map userdata;
  String Strname = "";
  int _groupValuenew = -1;


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


  ContactNumber _selectedContactType ;
  Furnizer _selectedid ;
  List<ContactNumber> _users = ContactNumber.getUsers();
  List<Furnizer> _funers = Furnizer.getUsers();
  List<String> _selectedTypeWithContact;

  final dateFormat = DateFormat("dd/MM/yyyy");
  List<TextEditingController> _controllers = new List();
  List<TextEditingController> _controllers1 = new List();
  List<Furnizer> _controllersfurni = new List();
  List<DropdownMenuItem<ContactNumber>> _dropdownMenuItems;
  List<DropdownMenuItem<Furnizer>> _dropdownMenuItems1;


  List StepList = ["Informatii personale", "Puncte tari", "Puncte slabe", "Oportunitati", "Amenintari","Descriere", "Viziune dezvoltare personala", "Post vizat", "Obiective dezvoltare personala","Plan actiune"];


 String strSelectedStep = "informatii personale";
  //Textfield controller-----------------------------------
  final _preName = TextEditingController();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _postalcode = TextEditingController();
  final _orasol = TextEditingController();
  final _tara = TextEditingController();
  final _nationality = TextEditingController();
  final _email = TextEditingController();
  final _websites = TextEditingController();
  final _phoneType = TextEditingController();
  final _dob = TextEditingController();


  onChangeDropdownItem(ContactNumber SelectedUser) {
    setState(() {
      _selectedContactType = SelectedUser;

    });
  }
  onChangeDropdownItem1(Furnizer SelectedUser) {
    setState(() {
      _selectedid = SelectedUser;
      _controllersfurni.add(_selectedid);
    });
  }

  List<DropdownMenuItem<ContactNumber>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<ContactNumber>> items = List();
    for (ContactNumber user in _users) {
      items.add(
        DropdownMenuItem(
          value: user,
          child: Text(user.name),
        ),
      );
    }
    return items;
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


  SaveCreerPlan_PersonalInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CP1", json.encode(_cp1));
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
      "post_vizat":json.encode(_cp8),
      "obiective_dezvoltare_personala":json.encode(_cp9),
      "user_id":struserid};
    print("add data = $_finalPayload");
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
    if(_name.text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți prenumele");
      return false;
    }
    if(_preName.text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți prenumele");
      return false;
    }
    if(_address.text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți adresa");
      return false;
    }
    if(_postalcode.text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți codul poștal");
      return false;
    }
    if(_tara.text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți țara");
      return false;
    }
    if(_email.text.length <1) {

      showMyDialog(context,"Introduceți codul de e-mail");
      return false;
    }
    if(_nationality.text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți naționalitatea");
      return false;
    }
    if(_sex == null) {

      showMyDialog(context,"Vă rugăm să introduceți sexul dvs.");
      return false;
    }
    if(_strDob == null) {

      showMyDialog(context,"Selecteaza data ta de nastere");
      return false;
    }
    if(_controllers == null) {

      showMyDialog(context,"Vă rugăm să selectați cel puțin un număr de telefon");
      return false;
    }

    //*> get selected contact
    List<Map> contactList = contactSelectorWidget.getSelectedSelector(["phone_lbl", "phone_number"]);

    //*> get selected contact
    List<Map> socialList = socialSelectorWidget.getSelectedSelector(["social_lbl", "social_number"]);


    _cp1 = {
      "prenume":_preName.text.toString(),
      "nume":_name.text.toString(),
      "adresa":_address.text.toString(),
      "codPostal":_postalcode.text.toString(),
      "oras":_orasol.text.toString(),
      "tara":_tara.text.toString(),
      "email":_email.text.toString(),
      "nationalitate":_nationality.text.toString(),
      "web":_websites.text.toString(),
      "sex":_sex,
      "data_nasterii":_dob.text.toString(),
      "contact":contactList.length == 0?[]:contactList, //*> pass selected contact
      "Socail_Media":socialList.length == 0?[]:socialList, //*> pass selected media
    };

    print(_cp1);
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

  Future<Null>  GetCVPlandata() async
  {
    Map plandata;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final myString = prefs.getString('CVPlanData') ?? '';
      Map sem_data = json.decode(myString);
      plandata = json.decode(
          sem_data["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""));
      setState(() {
        _preName.text = plandata["prenume"];
        _name.text = plandata["nume"];
        _address.text = plandata["adresa"];
        _orasol.text = plandata["oras"];
        _dob.text = plandata["data_nasterii"];
        _tara.text = plandata["tara"];
        _postalcode.text = plandata["codPostal"];
        _nationality.text = plandata["nationalitate"];
        _phoneType.text = plandata["nationalitate"];
        _email.text = plandata["email"];
        _websites.text = plandata["web"];
        if (plandata["sex"] == "Masculin")
        {
          _groupValuenew = 0;
        }
        else if (plandata["sex"] == "Feminin")
        {
          _groupValuenew = 1;
        }
        else
        {
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
  @override

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropdownMenuItems(_users);
    _selectedContactType = _dropdownMenuItems[0].value;
    _dropdownMenuItems1 = buildDropdownMenuItems1(_funers);
    _selectedid = _dropdownMenuItems1[0].value;
        GetUserdata();
    super.initState();
    GetCVPlandata();
    FetchCVPlanAllData();
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
  Widget _forLastinde(int _inx)
  {
    if(_inx == rowCount-1)
      {
        return  Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // new Flexible(
            Container(
              margin: EdgeInsets.only(top: 25),
              //width: double.infinity,
              child: DropdownButton(items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,icon:Icon(Icons.keyboard_arrow_down,
                      color: Appcolor.redHeader),value: _users[_inx],hint: Text('Tip de telefon',)),
            ),
            //),
            SizedBox(width: 20),
            new Flexible(
              child: new  TextFormField(
                controller: _controllers[_inx],
                decoration: InputDecoration(
                    hintText: 'Telefon(Oane)',
                    suffixIcon: IconButton(icon: Icon(Icons.add_circle,color: Appcolor.redHeader,),  onPressed: () {
                      this.setState(() {
                        TextEditingController ctrl = _controllers[rowCount-1];
                        if (ctrl.text.length>0 && _users.length>rowCount)
                        {
                          rowCount = rowCount+1;
                        }
                      });
                    },)
                ),
                keyboardType: TextInputType.phone,
                maxLength: 12,

              ),
            ),
          ],
        );
      }else
        {
          return   Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30),
                //width: double.infinity,
                child: DropdownButton(items: _dropdownMenuItems,elevation: 1,isDense: false,
                    onChanged: onChangeDropdownItem,icon:Icon(Icons.keyboard_arrow_down,
                        color: Appcolor.redHeader),value:  _users[_inx],hint: Text('Tip de telefon',)),
              ),
              SizedBox(width: 20),
              new Flexible(
                child: new  TextFormField(
                  controller: _controllers[_inx],
                  decoration: InputDecoration(
                      hintText: 'Telefon(Oane)',
                      suffixIcon: IconButton(icon: Icon(Icons.remove_circle,color: Appcolor.redHeader,),  onPressed: () {
                        this.setState(() {
                          if (rowCount>1)
                            rowCount = rowCount-1;
                        });
                      },)
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 12,

                ),
              ),
            ],
          );
        }
  }
  Widget _forFurnozorLastIndex(int _inx)
  {
    if(_inx == rowCount1-1)
    {
      return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // new Flexible(
          Container(
            margin: EdgeInsets.only(top: 25),
            //width: double.infinity,
            child: DropdownButton(items: _dropdownMenuItems1,onChanged: onChangeDropdownItem1,
                icon:Icon(Icons.keyboard_arrow_down,
                    color: Appcolor.redHeader),value: _funers[_inx],hint: Text('Furnizer',)),
          ),
          //),
          SizedBox(width: 20),
          new Flexible(
            child: new  TextFormField(
              controller: _controllers1[_inx],
              decoration: InputDecoration(
                  hintText: 'Id',
                  suffixIcon: IconButton(icon: Icon(Icons.add_circle,color: Appcolor.redHeader,),  onPressed: () {
//                    this.setState(() {
//                      TextEditingController ctrl = _controllers1[rowCount-1];
//                      if (ctrl.text.length>0 && _funers.length>rowCount1)
//                      {
//                        rowCount1 = rowCount1+1;
//                      }
//                    });
                  },)
              ),

            ),
          ),
        ],
      );
    }else
    {
      return   Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            //width: double.infinity,
            child: DropdownButton(items: _dropdownMenuItems1,elevation: 1,isDense: false,onChanged: onChangeDropdownItem1,
                icon:Icon(Icons.keyboard_arrow_down,
                    color: Appcolor.redHeader),value:  _funers[_inx],hint: Text('Funizer',)),
          ),
          SizedBox(width: 20),
          new Flexible(
            child: new  TextFormField(
              controller: _controllers1[_inx],
              decoration: InputDecoration(
                  hintText: 'Id',
                  suffixIcon: IconButton(icon: Icon(Icons.remove_circle,color: Appcolor.redHeader,),  onPressed: () {
                    this.setState(() {
                      if (rowCount1>1)
                        rowCount1 = rowCount1-1;
                    });
                  },)
              ),
              keyboardType: TextInputType.phone,
              maxLength: 12,

            ),
          ),
        ],
      );
    }
  }
  _AddNewPlatform()
  {
    this.setState(() {
      TextEditingController ctrl = _controllers1[rowCount1-1];
      if (ctrl.text.length>0  && _funers.length>rowCount1)
     {
        rowCount1 = rowCount1+1;
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
    Widget _myRadioButton({String title, int value, Function onChanged})
    {
      return RadioListTile(
        value: value,
        groupValue: _groupValuenew,
        onChanged: onChanged,
        title: Text(title),
        activeColor: Appcolor.redHeader,
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
                  "Pasul 1 din 10",
                  style:
                  TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
              ),
              SizedBox(height: 10,),
              Text(
                  "Informatii personale",
                  style:
                  TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'demi')
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Prenume'
                ),
                // initialValue: userdata["fullname"].toString().split(" ")[0],
                controller: _preName,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Nume'
                ),

                controller: _name,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Adresa'
                ),
                controller: _address,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new Flexible(
                    child: new  TextFormField(
                      decoration: InputDecoration(

                        labelText: 'Codul Postal',
                      ),
                      controller: _postalcode,
                      keyboardType: TextInputType.number,
                      maxLength: 7,
                    ),
                  ),
                  SizedBox(width: 20),
                  new Flexible(
                    child: new  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Orasul',
                      ),
                      controller: _orasol,
                    ),
                  )
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Tara'
                ),
                controller: _tara,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Nationalitate'
                ),
                controller: _nationality,
              ),
              contactSelectorWidget,
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email'
                ),

                controller: _email,
                keyboardType: TextInputType.emailAddress,
                maxLength: 30,
              ),
              socialSelectorWidget,
              SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Website / Blog'
                ),
                controller: _websites,
              ),
              SizedBox(height: 10,),

              Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      child:  Text(
                          "Sexul",
                          style:
                          TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
                      ),
                    ),
                  ),
                ],
              ),
              _myRadioButton(
                title: "Masculin",
                value: 0,
                onChanged: (newValue) => setState(() {
                  _groupValuenew = newValue;
                  _sex = "Masculin";
                }
                ),
              ),
              _myRadioButton(
                title: "Feminin",
                value: 1,
                onChanged: (newValue) => setState(() {
                  _groupValuenew = newValue;
                  _sex = "Feminin";
                }
                ),
              ),
              _myRadioButton(
                title: "Nu specific",
                value: 2,
                onChanged: (newValue) => setState(() {
                  _groupValuenew = newValue;
                  _sex = "Nu specific";
                }
                ),
              ),

              Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      child:  Text(
                          "Data nasterii",
                          style:
                          TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular',)
                      ),
                    ),
                  ),
                ],
              ),
              DateTimePickerFormField(format: dateFormat,editable: true,dateOnly:true,controller: _dob, onChanged: (date) {
                setState(() {
                  _strDob = date.toString();
                });
                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text('$date'),));


              }),
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
                            "Salveaza si mergi la pasul 2":"Corect si mergi la pasul 2", style: TextStyle(fontFamily: 'regular')
                        )
                    )
                  ],
                ),
                onPressed: (){
                  //
                  if(StrUserType == UserType.Student || StrUserType == UserType.Pupil)
                  {
                    if (createPayload() == true)
                    {
//                      _apiTo_addCareerPlan1().then((res) {
//                        if (res == true)
//                        {
                          setState(() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => CareerPlan_2(StrUserType: StrUserType,cp1: _cp1,)));
                          });
//                        }
//                      });
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
                                MaterialPageRoute(builder: (context) => CareerPlan_2(StrUserType: StrUserType,cp1: _cp1,)));
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

              SizedBox(height: 40),
              Slider(
                value: _value,
                activeColor: Appcolor.AppGreen,
                label: (_value+1).round().toString(),
                inactiveColor: Colors.grey,
                max: 9,
                min: 0,
                divisions: 9,
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
              Text(
                   strSelectedStep,
                  style:
                  TextStyle(color: Appcolor.redHeader, fontSize: 16.0, fontFamily: 'demi')
              ),
              SizedBox(height: 20),
              new IconButton(
                onPressed: ()
                {

                  if (_value == 0.0)
                  {

                  }
                  else if (_value == 1.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CareerPlan_2(StrUserType: StrUserType)));
                  }
                  else  if (_value == 2.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CareerPlan_3(StrUserType: StrUserType)));
                  }
                  else if (_value == 3.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CareerPlan_4(StrUserType: StrUserType)));
                  }
                  else if (_value == 4.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CareerPlan_5(StrUserType: StrUserType)));
                  }
                  else if (_value == 5.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CareerPlan_6(StrUserType: StrUserType)));
                  }
                  else if (_value == 6.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CareerPlan_7(StrUserType: StrUserType)));
                  }
                  else if (_value == 7.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CareerPlan_8(StrUserType: StrUserType,)));
                  }
                  else if (_value == 8.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CareerPlan_9(StrUserType: StrUserType)));
                  }
                  else if (_value == 9.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CareerPlan_10(StrUserType: StrUserType)));
                  }
                },
                //
                //onPressed: _toggle,
                icon: new Image(image: AssetImage("Assets/Images/CareerplanEdit.png")),
                color:Appcolor.redHeader,
                iconSize: 20,
              ),
              // Image(image: new AssetImage("Assets/Images/DefaultUser.png"),width: 40,height: 40,),
              SizedBox(height: 20),
              Text(
                  "Editeaza pasul",
                  style:
                  TextStyle(color: Appcolor.redHeader, fontSize: 14.0, fontFamily: 'demi')
              ),
            ],
          ),
        ),
      )),
      drawer: Drawer(
        child: SideMenu(StrUserType: StrUserType),
      ),
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
      Furnizer(2, 'Whatsapp'),
      Furnizer(3, 'Facebook'),
    ];
  }
}
