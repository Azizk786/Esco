import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/CVCompletion/CVCompletion_2.dart';
import 'package:escouniv/CVCompletion/CVCompletion_3.dart';
import 'package:escouniv/CVCompletion/CVCompletion_4.dart';
import 'package:escouniv/CVCompletion/CVCompletion_5.dart';
import 'package:escouniv/CVCompletion/CVCompletion_6.dart';
import 'package:escouniv/CVCompletion/CVCompletion_7.dart';
import 'package:escouniv/CVCompletion/CVCompletion_8.dart';
import 'package:escouniv/CVCompletion/CVCompletion_9.dart';
import 'package:escouniv/CVCompletion/CVCompletion_10.dart';
import 'package:escouniv/CVCompletion/CVCompletion_11.dart';
import 'package:escouniv/CVCompletion/CVCompletion_12.dart';
import 'package:escouniv/CVCompletion/CVCompletion_13.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/HelperClass/DataCollected.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:escouniv/CustomWidget/Selector.dart';

enum SingingCharacter { lafayette, jefferson }


class CVCompletion_1 extends StatefulWidget {

  UserType  StrUserType;
  CVCompletion_1({Key key, @required this.StrUserType}) : super(key: key);

  @override
  _CVCompletion_1State createState() => _CVCompletion_1State(StrUserType);
}

class _CVCompletion_1State extends State<CVCompletion_1> {

  //*> Contact Selector
  Selector contactSelectorWidget = new Selector(selectorTypes: ["Domiciliu", "Loc de Munca", "Mobil", "Telefon(Oane)"], placeHolder:"Telefon(Oane)", keyboardType: KeyBoardType.phone);

  //*> Social Selector
  Selector socialSelectorWidget = new Selector(selectorTypes: ["Skype", "Linkedin", "Facebook"], placeHolder:"Id", keyboardType: KeyBoardType.email);


  double _value = 0;
  SingingCharacter _character = SingingCharacter.lafayette;
  UserType  strUserType;
  String struserid;
  bool _saving = true;
  Map userdata;
  String  _sex = "Masculin";
  String _strDob;
  int rowCount1 = 1;
  String Strname = "";
  int _groupValuenew = -1;
  String struserfolder;
  String imgURL;


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


  List StepList = ["Informatii Personale", "Tipul aplicatiei", "Experienta profesionala", "Educatie si formare",
    "Competente personale", "Alte limbi straine cunoscute", "Competente de comunicare", "Competente organizationale/manageriale","Competente manageriale",
    "Competente dobandite la locul de munca","Competente digitale","Alte competente","Permis de conducere","Informatii suplimentare"];
  String strSelectedStep = "informatii personale";
  final dateFormat = DateFormat("dd/MM/yyyy");

  File _image ;
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
  final _dob = TextEditingController();
  final _cnp = TextEditingController();

  _CVCompletion_1State(this.strUserType);


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
  Future<bool> _apiToCorrectCV() async {

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
    print(_finalPayload);
    setState(() {
      _saving = false;
    });
    print(streamedRest.body);
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

  openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 240, maxWidth: 320);
    setState(() {
      _image = image;
    });
  }
  openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 240, maxWidth: 320);
    setState(() {

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
                child: const Text('Camera'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  openCamera();
                },
              ),
              OutlineButton(
                child: const Text('Gallery'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                  openGallery();
                },
              ),
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        }
    );
  }

  SaveCreerPlan_PersonalInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CV1", json.encode(_cv1));
  }


  Future<Null> FetchCVData() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Profiledata') ?? '';
    setState(() {


     Map profiledata = json.decode(myString);
      struserfolder = profiledata["userFolder"];
      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+profiledata["listUser"][0]["picture"];
      imgURL = _imgURL;

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
    if(_name.text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți prenumele");
      return false;
    }
    if(_preName.text.length <1) {

      showMyDialog(context,"Vă rugăm să introduceți Nume");
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

    //*> get selected contact
    List<Map> contactList = contactSelectorWidget.getSelectedSelector(["phone_lbl", "phone_number"]);

    //*> get selected contact
    List<Map> socialList = socialSelectorWidget.getSelectedSelector(["social_lbl", "social_number"]);


    _cv1 = {
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
      "CNP":_cnp.text.toString(),
      "contact":contactList.length == 0?[]:contactList, //*> pass selected contact
      "Socail_Media":socialList.length == 0?[]:socialList, //*> pass selected media
    };

    print("payload for cv 1 = $_cv1");

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

      FetchCVData();
    });
    print("Print userdata in Side menu");
    print(userdata);
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
  Future<Null> GetCVPlandata() async
  {
    Map<String,dynamic> plandata;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _saving = false;
      final myString = prefs.getString('CVData') ?? '';
      Map sem_data = json.decode(myString);
      plandata = json.decode(
          sem_data["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""));
      _preName.text = plandata["prenume"];
      _name.text = plandata["nume"];
      _address.text = plandata["adresa"];
      _orasol.text = plandata["oras"];
      _dob.text = plandata["data_nasterii"];
      _tara.text = plandata["tara"];
      _postalcode.text = plandata["codPostal"];
      _nationality.text = plandata["nationalitate"];
      _email.text = plandata["email"];
      _websites.text = plandata["web"];
      _cnp.text = plandata["CNP"];
      if (plandata["sex"] == "Masculin" || plandata["sex"] == "m")
      {
        _groupValuenew = 0;
      }
      else if (plandata["sex"] == "Feminin" || plandata["sex"] == "f")
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
    GetCVPlandata();
    GetUserdata();
    strSelectedStep = StepList[0];
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

  _AddNewPlatform()
  {
//    this.setState(() {
//      TextEditingController ctrl = _[rowCount1-1];
//
//      if (ctrl.text.length>0  && ctrl.text.length>0)
//      {
//        rowCount1 = rowCount1+1;
//      }
//    });

  }

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
//      drawer: Drawer(
//        child: SideMenu(StrUserType: strUserType),
//      ),
      body: ModalProgressHUD(inAsyncCall:_saving, child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30,),
              Text(
                  "Pasul 1 din 13",
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
              Container(
                alignment: Alignment.center,
                width: 120,
                height: 120,
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: _image == null ? ( imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL)) : FileImage(_image),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: new BorderRadius.all(const Radius.circular(60))
                ),
              ),
              SizedBox(height: 8,),
              Container(
//color: Colors.white,
                  height: 19.0,
                  width: MediaQuery.of(context).size.width,
                  child:  RaisedButton(
                    color: Colors.white,
                    child: Stack(

                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            widthFactor: 4.5,
                            child: Text("Schimba poza", style: TextStyle(fontFamily: 'dami'))
                        )
                      ],
                    ),
                    onPressed: (){ _selectimagefrom(context, "Selectați poza de profil");
                    },
                   // color: Colors.white,
                    textColor: Colors.red,
                    elevation: 0,
                  )
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

                    //  maxLength: 8,
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
              //*> Use Selector Widget
              contactSelectorWidget,
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email'
                ),
                keyboardType: TextInputType.emailAddress,
                maxLength: 30,
                controller: _email,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'CNP'
                ),

                controller: _cnp,
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
                          TextStyle(color: Colors.grey, fontSize: 16.0, fontFamily: 'regular')
                      ),
                    ),
                  ),
                ],
              ),


              DateTimePickerFormField(format: dateFormat,enabled: true, initialValue: DateTime(1970), initialDate: DateTime.now(), lastDate: DateTime.now(), controller: _dob,editable: true,dateOnly:false, onChanged: (date) {
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
                        child: Text(strUserType == UserType.Student || strUserType == UserType.Pupil?
                        "Salveaza si inchide":"Corect si inchide",
                        )
                    )
                  ],
                ),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                textColor: Colors.green,
                onPressed: () {

                  if(strUserType == UserType.Student || strUserType == UserType.Pupil)
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
                                    builder: (context) => Dashboard(StrUserType: strUserType)));
                          });
                        }
                      });
                    }
                  }
                  else
                  {
                    if (createPayload() == true)
                    {
                      _apiToCorrectCV().then((res) {
                        if (res == true)
                        {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Dashboard(StrUserType: strUserType)));
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
                            " Salveaza si mergi la pasul 2", style: TextStyle(fontFamily: 'regular')
                        )
                    )
                  ],
                ),
                onPressed: (){
                  if (createPayload() == true)
                  {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => CVCompletion_2(StrUserType: strUserType)));
    }
                },

                color: Appcolor.AppGreen,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
              ),
              SizedBox(height: 15,),
              SizedBox(height: 40),
              Slider(
                value: _value,
                activeColor: Appcolor.AppGreen,
                label: (_value+1).round().toString(),
                inactiveColor: Colors.grey,
                max: 12,
                min: 0,
                divisions: 12,
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
                        MaterialPageRoute(builder: (context) => CVCompletion_2(StrUserType: strUserType)));
                  }
                  else  if (_value == 2.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_3(StrUserType: strUserType)));
                  }
                  else if (_value == 3.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_4(StrUserType: strUserType)));
                  }
                  else if (_value == 4.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_5(StrUserType: strUserType)));
                  }
                  else if (_value == 5.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_6(StrUserType: strUserType)));
                  }
                  else if (_value == 6.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_7(StrUserType: strUserType)));
                  }
                  else if (_value == 7.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_8(StrUserType: strUserType,)));
                  }
                  else if (_value == 8.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_9(StrUserType: strUserType)));
                  }
                  else if (_value == 9.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_10(StrUserType: strUserType)));
                  }
                  else if (_value == 10.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_11(StrUserType: strUserType)));
                  }
                  else if (_value == 11.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_12(StrUserType: strUserType)));
                  }
                  else if (_value == 12.0)
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CVCompletion_13(StrUserType: strUserType)));
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
      ),)
    );
  }
}
