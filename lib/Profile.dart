import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/EVROMenu.dart';
//import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
//Call Mentor Profile-----------------------------------


class MentorProfileView extends StatefulWidget {
  @override
  _MentorProfileViewState createState() => _MentorProfileViewState();
}

class _MentorProfileViewState extends State<MentorProfileView> {

  String imgURL;
  Map userdata;
  bool _saving = false;
  Map _ProfileInfo;
  String Strname = "";
  String struserid;
  File _image;
  String struserfolder;
  final dateFormat = DateFormat("yyyy-MM-dd");
  final _fnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dob = TextEditingController();
  final _phone = TextEditingController();
  final _lastname = TextEditingController();
  final _gender = TextEditingController();
  final _date_of_birth = TextEditingController();
  final _Oras = TextEditingController();
  final _address = TextEditingController();
  final _country = TextEditingController();
  final _county = TextEditingController();
  final _locality = TextEditingController();
  final _facultate = TextEditingController();
  final _nivelStudiu = TextEditingController();
  final _programStudiu = TextEditingController();
  final _locDeMunca = TextEditingController();
  final _functieLocDeMunca = TextEditingController();
  final _anPromotie = TextEditingController();
  final _domeniuSpecializare = TextEditingController();

  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      Strname = userdata["fullname"].toString();
      _fnameController.text = userdata["fullname"].toString().split(" ")[0];
      _lastname.text = userdata["fullname"].toString().split(" ")[1];
      _emailController.text = userdata["email"].toString();
      struserid = userdata["userid"].toString();
      fetchData();
    });
    print("Print userdata in Side menu");
    print(userdata);

  }
  Future _prfofileDeletionRequest() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.DeleteAccountRequest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      showMyDialog(context, map["message"].toString());
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
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        showMyDialog(context, map["romanMsg"].toString());
      }
    }

  }
  SaveProfileData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Profiledata", json.encode(map));
  }
  Future<List> getProfile() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetUserProfile;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();
      setState(() {
        _saving = false;
      });
//      if (Status == "200") {
//
//      } else {
//        showMyDialog(context, map["message"].toString());
//      }

      SaveProfileData(map);
      struserfolder = map["userFolder"];
      return map["listUser"];//listUser1
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
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        showMyDialog(context, map["romanMsg"].toString());
      }
    }

  }

  upload() async {
    // open a bytestream
    Map <String,String>_payload = {
      'user_id': struserid,
      'firstname': _fnameController.text,
      'lastname': _lastname.text,
      'email': _emailController.text,
      'phone': _phone.text,
      'dateOfBirth': _dob.text,
      'gender': "Male",
      //'dateOfBirth': _dob.text,
      'address': _address.text,
      'country': _country.text,
      'locality': _locality.text,
      'facultate': _facultate.text,
      'nivelStudiu': _nivelStudiu.text,
      'programStudiu': _programStudiu.text,
      'anPromotie': _anPromotie.text,
      'domeniuSpecializare': _domeniuSpecializare.text,
      'locDeMunca': _locDeMunca.text,
      'functieLocDeMunca':  _functieLocDeMunca.text,
    };


    Map <String,String> _header = {'End-Client': 'escon', 'Auth-Key': 'escon@2019'};
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse(API.Base_url + API.UpdateUserprofile);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    // multipart that takes file
    var multipartFile = new http.MultipartFile('pictureFile', stream, length,
        filename: _image.path);

    // add file to multipart
    request.files.add(multipartFile);
    request.fields.addAll(_payload);

    // send
    var streamedRest = await request.send();
    print(streamedRest.statusCode);
    // listen for response
    streamedRest.stream.transform(utf8.decoder).listen((value) {
      print(value);
      if(streamedRest.statusCode == 200)
      {
//        Map<String, String> map = json.decode(value);
//        String Status = map["status"].toString();
        setState(() {
          _saving = false;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(StrUserType: UserType.Mentor)));
      //  showMyDialog(context, map["message"].toString());

      }
      else
      {
        setState(() {
          _saving = false;
        });
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
    });
  }
  Future updateProfile() async {
    //-------------------------------------------------------
    if (_fnameController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_lastname.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
//    else if (_emailController.text.length < 1) {
//      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
//    }
    else if (_dob.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_phone.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_address.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_country.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_locality.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else {
      setState(() {
        _saving = true;
      });
      upload();
    }
  }

  //Image selection---------------------------------------------
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
  void fetchData() {
    getProfile().then((res) {
      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+res[0]["picture"];

      setState(() {
        _ProfileInfo = res[0];
        _dob.text = _ProfileInfo["date_of_birth"];
        _emailController.text = _ProfileInfo["email"];
        _phone.text = _ProfileInfo["phone"];
        _lastname.text = _ProfileInfo["lastname"];
        _date_of_birth.text = _ProfileInfo["date_of_birth"].toString().split(" ")[0];
        _address.text = _ProfileInfo["address"];
        _country.text = _ProfileInfo["country"];
        _locality.text = _ProfileInfo["locality"];
        _county.text = _ProfileInfo["locality"];
        _facultate.text = _ProfileInfo["facultate"];
        _nivelStudiu.text = _ProfileInfo["nivel_studiu"];
        _programStudiu.text = _ProfileInfo["program_studiu"];
        _locDeMunca.text = _ProfileInfo["an_studiu"];
        _fnameController.text = _ProfileInfo["firstname"];
        _anPromotie.text = _ProfileInfo["anPromotie"];
        _functieLocDeMunca.text = _ProfileInfo["functieLocDeMunca"];
        _domeniuSpecializare.text = _ProfileInfo["domeniuSpecializare"];
        _dob.text = _ProfileInfo["dateOfBirth"];
        imgURL = _imgURL;

      });
    });

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
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    final RequestDeleteAccBtn = Material(

        color: Colors.transparent,
        child:OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 3,
                  child:Text("Cerere stergere cont", style: TextStyle(fontFamily: 'regular'))
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.red,
          onPressed: () {
            _prfofileDeletionRequest();

          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )
    );

    return Scaffold(

      appBar: AppBar(
        title: Text("Profil", style: TextStyle(fontFamily: 'Demi'),textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body:ModalProgressHUD(inAsyncCall: _saving, child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20,left: 25,right: 25,bottom: 25),
        //color: Colors.red,
child: Container(
  color: Colors.white,
  alignment: Alignment.center,
  child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            width: 150,
            height: 150,
            decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: _image == null ? ( imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL)) : FileImage(_image),
                  fit: BoxFit.fill,
                ),
                borderRadius: new BorderRadius.all(const Radius.circular(75))
            ),
          ),
        ),
        SizedBox(height: 15,),
        Container(

            height: 19.0,
            width: MediaQuery.of(context).size.width,
            child:  RaisedButton(
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
              color: Colors.white,
              textColor: Colors.red,
              elevation: 0,
            )
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Prenume',

          ),
          controller: _fnameController,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Nume',

          ),
          //initialValue: userdata["fullname"].toString().split(" ")[1]
          controller: _lastname,
        ),
        TextFormField(
            decoration: InputDecoration(
              labelText: 'Nume de utilizator',

            ),
            enabled: false,
            initialValue: userdata["username"].toString()
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Email',
          ),
          enabled: false,
          controller: _emailController,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Telefon'
          ),
          controller: _phone,
          keyboardType: TextInputType.phone,
          maxLength: 12,
        ),
        Column(
          mainAxisAlignment:  MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 8),
            Text("Data nasterii"),
            DateTimePickerFormField(format: dateFormat ,initialValue: DateTime(1970) ,controller:_dob ,editable: false,dateOnly:true, onChanged: (date) {
              setState(() {
                //
              });
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text('$date'),));
            }),
          ],
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Judet'
          ),

        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Oras'
          ),
         controller: _Oras,
         // controller: ,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Adresa'
          ),
          controller: _address,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Tara',
//                  suffixIcon: const Icon(
//                    Icons.keyboard_arrow_down,
//                    color: Colors.red,
//                  ),
          ),
          controller: _country,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Facultate'
          ),
          controller: _facultate,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Nivel de studiu'
          ),
          controller: _nivelStudiu,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Program de studiu'
          ),
          controller: _programStudiu,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'An promotie'
          ),
          controller: _anPromotie,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Domeniu Specializare'
          ),
          controller: _domeniuSpecializare,
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: 'Loc de munca'
          ),
          controller: _locDeMunca,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Functia ocupata la locul de munca',

          ),
          controller: _functieLocDeMunca,
        ),
        SizedBox(height: 10),
        RequestDeleteAccBtn,
        SizedBox(height: 10),
        RaisedButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 4.5,
                  child: Text(
                      "Actualizați", style: TextStyle(fontFamily: 'regular')
                  )
              )
            ],
          ),
          onPressed: (){updateProfile();},
          color: Appcolor.AppGreen,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),
        )

      ]
  ),
),

      ),),
  drawer: Drawer(
    child: SideMenu(StrUserType: UserType.Mentor),
  ),
    );

  }
}

//Call Phsycological counsellor Profile-----------------------------------
class PhsycologicalProfile extends StatefulWidget {
  @override
  _PhsycologicalProfileState createState() => _PhsycologicalProfileState();
}

class _PhsycologicalProfileState extends State<PhsycologicalProfile> {

  Map userdata;
  Map _ProfileInfo;
  bool _saving = false;
  String Strname = "";
  String struserid;
  String struserfolder;
  final dateFormat = DateFormat("yyyy-MM-dd");
  final _fnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dob = TextEditingController();
  final _Oras = TextEditingController();
  final _phone = TextEditingController();
  final _lastname = TextEditingController();
  final _gender = TextEditingController();
  final _date_of_birth = TextEditingController();
  final _address = TextEditingController();
  final _country = TextEditingController();
  final _judet = TextEditingController();
  final _locality = TextEditingController();
  final _facultate = TextEditingController();
  final _username = TextEditingController();
  final _locatieConsiliere= TextEditingController();
  final _orar= TextEditingController();
  String imgURL;


  File _image ;
  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      Strname = userdata["fullname"].toString();
      _fnameController.text = userdata["fullname"].toString().split(" ")[0];
      _lastname.text = userdata["fullname"].toString().split(" ")[1];
      _emailController.text = userdata["email"].toString();
      struserid = userdata["userid"].toString();
      _username.text = userdata["username"].toString();
      fetchData();
    });
    print("Print userdata in Side menu");
    print(userdata);

  }
  Future _prfofileDeletionRequest() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.DeleteAccountRequest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      showMyDialog(context, map["message"].toString());
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
  SaveProfileData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Profiledata", json.encode(map));
  }
  Future<List> getProfile() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetUserProfile;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();
      setState(() {
        _saving = false;
      });
//      if (Status == "200") {
//
//      } else {
//        showMyDialog(context, map["message"].toString());
//      }

      SaveProfileData(map);
      struserfolder = map["userFolder"];
      return map["listUser"];//listUser1
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
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        showMyDialog(context, map["romanMsg"].toString());
      }
    }

  }

  upload() async {
    // open a bytestream
    Map <String,String>_payload = {
      'user_id': struserid,
      'firstname': _fnameController.text,
      'lastname': _lastname.text,
      'email': _emailController.text,
      'phone': _phone.text,
      'dateOfBirth': _dob.text,
      'gender': "Male",
      'date_of_birth': _dob.text,
      'address': _address.text,
      'country': _country.text,
      'locality': _locality.text,
      'facultate': _facultate.text,
      'locatieConsiliere': _locatieConsiliere.text,
      'orar': _orar.text,
      'judet': _judet.text,
     'oras': _Oras.text,

    };

    Map <String,String> _header = {'End-Client': 'escon', 'Auth-Key': 'escon@2019'};
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse(API.Base_url + API.UpdateUserprofile);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    // multipart that takes file
    var multipartFile = new http.MultipartFile('pictureFile', stream, length,
        filename: _image.path);

    // add file to multipart
    request.files.add(multipartFile);
    request.fields.addAll(_payload);

    // send
    var streamedRest = await request.send();
    print(streamedRest.statusCode);
    // listen for response
    streamedRest.stream.transform(utf8.decoder).listen((value) {
      print(value);
      if(streamedRest.statusCode == 200)
      {
//        Map<String, String> map = json.decode(value);
//        String Status = map["status"].toString();
        setState(() {
          _saving = false;
        });
        showMyDialog(context, "Profil actualizat cu succes");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(StrUserType: UserType.Pcounsellor)));


      }
      else
      {
        setState(() {
          _saving = false;
        });
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
    });
  }
  Future updateProfile() async {
    //-------------------------------------------------------
    if (_fnameController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_lastname.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_emailController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_dob.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_phone.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_address.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_country.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
//    else if (_locality.text.length < 1) {
//      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
//    }
    else {
      setState(() {
        _saving = true;
      });
      upload();
    }
  }
  //Image selection---------------------------------------------
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
  void fetchData() {
    getProfile().then((res) {
      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+res[0]["picture"];

      setState(() {
        _ProfileInfo = res[0];
        _dob.text = _ProfileInfo["date_of_birth"];
        _emailController.text = _ProfileInfo["email"];
        _phone.text = _ProfileInfo["phone"];
        _lastname.text = _ProfileInfo["lastname"];
       _gender.text = _ProfileInfo["gender"];
        _date_of_birth.text = _ProfileInfo["date_of_birth"];
        _address.text = _ProfileInfo["address"];
        _country.text = _ProfileInfo["country"];
        _locality.text = _ProfileInfo["locality"];
        _facultate.text = _ProfileInfo["facultate"];
        _orar.text = _ProfileInfo["orar"];
        _locatieConsiliere.text = _ProfileInfo["locatieConsiliere"];
        _fnameController.text = _ProfileInfo["firstname"];
        _judet.text = _ProfileInfo["judet"];
        _dob.text = _ProfileInfo["dateOfBirth"];
      //  _Oras.text = _ProfileInfo["oras"];
        imgURL = _imgURL;

      });
    });

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
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {

    final RequestDeleteAccBtn = Material(

        color: Colors.transparent,
        child:OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 3,
                  child: Text(
                    "Cerere stergere cont",
                  )
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.red,
          onPressed: () {
            _prfofileDeletionRequest();
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )
    );

    return Scaffold(

      appBar: AppBar(
        title: Text("Profil", style: TextStyle(fontFamily: 'Demi',),textAlign: TextAlign.center),
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.only(top: 20,left: 25,right: 25,bottom: 25),
        //color: Colors.red,
        child: Container(
          color: Colors.white,
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 150,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: _image == null ? ( imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL)) : FileImage(_image),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: new BorderRadius.all(const Radius.circular(75))
                      ),
                    ),
                  ),
                  Container(

                      height: 19.0,
                      width: MediaQuery.of(context).size.width,
                      child:  RaisedButton(
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
                        color: Colors.white,
                        textColor: Colors.red,
                        elevation: 0,
                      )
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Prenume',

                    ),
                    controller: _fnameController,
                    // initialValue: userdata["fullname"].toString().split(" ")[0] ,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nume',

                    ),
                    controller: _lastname,
                    // initialValue: userdata["fullname"].toString().split(" ")[1]
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nume de utilizator',

                      ),
                      enabled: false,
                      controller: _username,
                    //  initialValue: userdata["username"].toString()
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    enabled: false,
                    controller: _emailController,
                    //initialValue: userdata["email"].toString()
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Telefon'
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 12,
                      controller: _phone
                  ),
                  Column(
                    mainAxisAlignment:  MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 8),
                      Text("Data nasterii"),
                      DateTimePickerFormField(format: dateFormat ,initialValue: DateTime(1970) ,controller:_dob ,editable: false,dateOnly:true, onChanged: (date) {
                        setState(() {
                          //
                        });
                        Scaffold
                            .of(context)
                            .showSnackBar(SnackBar(content: Text('$date'),));
                      }),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Judet'
                    ),
                    controller: _judet,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Oras'
                    ),
                    controller: _locality,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Adresa'
                    ),
                    controller: _address,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Locatie consiliere',

                    ),
                    controller: _locatieConsiliere,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Tara',
//                  suffixIcon: const Icon(
//                    Icons.keyboard_arrow_down,
//                    color: Colors.red,
//                  ),
                    ),
                    controller: _country,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Orar consiliere Luni-Vineri'
                    ),
                    controller: _orar,
                  ),

                  SizedBox(height: 10),
                  RequestDeleteAccBtn,
                  SizedBox(height: 10),
                  RaisedButton(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            widthFactor: 4.5,
                            child: Text(
                                "Actualizați"
                            )
                        )
                      ],
                    ),
                    onPressed: (){updateProfile();},
                    color: Appcolor.AppGreen,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                  )

                ]
            ),
        ),

      ),
      drawer: Drawer(
        child: SideMenu(StrUserType: UserType.Pcounsellor),
      ),
    );

  }
}
//Call Career counsellor Profile-----------------------------------

class CareerCounsellor extends StatefulWidget {
  @override
  _CareerCounsellorState createState() => _CareerCounsellorState();
}

class _CareerCounsellorState extends State<CareerCounsellor> {
  Map userdata;
  Map _ProfileInfo;
  bool _saving = false;
  String Strname = "";
  String struserid;
  String struserfolder;
  final dateFormat = DateFormat("yyyy-MM-dd");
  final _fnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dob = TextEditingController();
  final _phone = TextEditingController();
  final _lastname = TextEditingController();
  final _gender = TextEditingController();
  final _date_of_birth = TextEditingController();
  final _address = TextEditingController();
  final _country = TextEditingController();
  final _locality = TextEditingController();
  final _facultate = TextEditingController();
  final _locatieConsiliere= TextEditingController();
  final _orar= TextEditingController();
  final _judet= TextEditingController();
  File _image ;
  String imgURL;

  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      Strname = userdata["fullname"].toString();
      _fnameController.text = userdata["fullname"].toString().split(" ")[0];
      _lastname.text = userdata["fullname"].toString().split(" ")[1];
      _emailController.text = userdata["email"].toString();
      struserid = userdata["userid"].toString();
      fetchData();
    });
    print("Print userdata in Side menu");
    print(userdata);

  }
  Future _prfofileDeletionRequest() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.DeleteAccountRequest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      showMyDialog(context, map["message"].toString());
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
  SaveProfileData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Profiledata", json.encode(map));
  }
  Future<List> getProfile() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetUserProfile;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();
      setState(() {
        _saving = false;
      });
//      if (Status == "200") {
//
//      } else {
//        showMyDialog(context, map["message"].toString());
//      }

      SaveProfileData(map);
      struserfolder = map["userFolder"];
      return map["listUser"];//listUser1
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
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        showMyDialog(context, map["romanMsg"].toString());
      }
    }

  }

  upload() async {
    // open a bytestream
    Map <String,String>_payload = {
      'user_id': struserid,
      'firstname': _fnameController.text,
      'lastname': _lastname.text,
      'email': _emailController.text,
      'phone': _phone.text,
      'dateOfBirth': _dob.text,
      //'gender': "Male",
      'date_of_birth': _dob.text,
      'address': _address.text,
      'country': _country.text,
      'locality': _locality.text,
      'facultate': _facultate.text,
      'locatieConsiliere': _locatieConsiliere.text,
      'orar': _orar.text,
      'judet': _judet.text,
    };

    Map <String,String> _header = {'End-Client': 'escon', 'Auth-Key': 'escon@2019'};
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse(API.Base_url + API.UpdateUserprofile);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    // multipart that takes file
    var multipartFile = new http.MultipartFile('pictureFile', stream, length,
        filename: _image.path);

    // add file to multipart
    request.files.add(multipartFile);
    request.fields.addAll(_payload);

    // send
    var streamedRest = await request.send();
    print(streamedRest.statusCode);
    // listen for response
    streamedRest.stream.transform(utf8.decoder).listen((value) {
      print(value);
      if(streamedRest.statusCode == 200)
      {
//        Map<String, String> map = json.decode(value);
//        String Status = map["status"].toString();
        setState(() {
          _saving = false;
        });
        showMyDialog(context, "Profil actualizat cu succes");

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(StrUserType: UserType.CCounsellor)));

      }
      else
      {
        setState(() {
          _saving = false;
        });
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
    });
  }
  Future updateProfile() async {
    //-------------------------------------------------------
    if (_fnameController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_lastname.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_emailController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_dob.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_phone.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_address.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_country.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_locality.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else {
      setState(() {
        _saving = true;
      });
      upload();
    }
  }

  //Image selection---------------------------------------------
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
  void fetchData() {
    getProfile().then((res) {

      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+res[0]["picture"];

      setState(() {
        _ProfileInfo = res[0];
        _dob.text = _ProfileInfo["date_of_birth"];
        _emailController.text = _ProfileInfo["email"];
        _phone.text = _ProfileInfo["phone"];
        _lastname.text = _ProfileInfo["lastname"];
        _date_of_birth.text = _ProfileInfo["date_of_birth"];
        _address.text = _ProfileInfo["address"];
        _country.text = _ProfileInfo["country"];
        _locality.text = _ProfileInfo["locality"];
        _facultate.text = _ProfileInfo["facultate"];
        _orar.text = _ProfileInfo["orar"];
        _locatieConsiliere.text = _ProfileInfo["locatieConsiliere"];
        _fnameController.text = _ProfileInfo["firstname"];
        _judet.text = _ProfileInfo["judet"];
        _dob.text = _ProfileInfo["dateOfBirth"];
        imgURL = _imgURL;


      });
    });

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
  @override
  void initState() {
    super.initState();
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

  Widget build(BuildContext context) {

    final RequestDeleteAccBtn = Material(

        color: Colors.transparent,
        child:OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 3,
                  child: Text(
                    "Cerere stergere cont",
                  )
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.red,
          onPressed: () {
            _prfofileDeletionRequest();
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )
    );

    return Scaffold(

      appBar: AppBar(
        title: Text("Profil", style: TextStyle(fontFamily: 'Demi',),textAlign: TextAlign.center),
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.only(top: 20,left: 25,right: 25,bottom: 25),
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 150,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: _image == null ? ( imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL)) : FileImage(_image),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: new BorderRadius.all(const Radius.circular(75))
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Container(

                    height: 19.0,
                    width: MediaQuery.of(context).size.width,
                    child:  RaisedButton(
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
                      color: Colors.white,
                      textColor: Colors.red,
                      elevation: 0,
                    )
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Prenume',

                  ),
                  controller: _fnameController,
                  //  initialValue: userdata["fullname"].toString().split(" ")[0] ,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nume',

                  ),
                  controller: _lastname,
                  //  initialValue: userdata["fullname"].toString().split(" ")[1]
                ),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Nume de utilizator',

                    ),
                    enabled: false,
                    initialValue: userdata["username"].toString()
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  enabled: false,
                  // initialValue: userdata["email"].toString(),
                  controller: _emailController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Telefon'
                  ),
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 12,
                ),
                Column(
                  mainAxisAlignment:  MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 8),
                    Text("Data nasterii"),
                    DateTimePickerFormField(format: dateFormat ,initialValue: DateTime(1970) ,controller:_dob ,editable: false,dateOnly:true, onChanged: (date) {
                      setState(() {
                        //
                      });
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text('$date'),));
                    }),
                  ],
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Judet'
                  ),
                  controller: _locality,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Oras'
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Adresa'
                  ),
                  controller: _address,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Locatie consiliere'
                  ),
                  controller: _locality,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tara',
//                  suffixIcon: const Icon(
//                    Icons.keyboard_arrow_down,
//                    color: Colors.red,
//                  ),
                  ),
                  controller: _country,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Orar consiliere Luni-Vineri'
                  ),
                ),

                SizedBox(height: 10),
                RequestDeleteAccBtn,
                SizedBox(height: 10),
                RaisedButton(
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          widthFactor: 4.5,
                          child: Text(
                              "Actualizați"
                          )
                      )
                    ],
                  ),
                  onPressed: (){
                    updateProfile();
                  },
                  color: Appcolor.AppGreen,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                )

              ]
          ),
        ),
        //color: Colors.red,

      ),

      drawer: Drawer(
        child: SideMenu(StrUserType: UserType.CCounsellor),
      ),
    );

  }
}

//Call Pupil  Profile-----------------------------------
class PupilProfile extends StatefulWidget {
  @override
  _PupilProfileState createState() => _PupilProfileState();
}

class _PupilProfileState extends State<PupilProfile> {

  Map userdata;
  Map _ProfileInfo;
  bool _saving = false;
  String Strname = "";
  String struserid;
  String struserfolder;
  final dateFormat = DateFormat("yyyy-MM-dd");
  final _fnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dob = TextEditingController();
  final _phone = TextEditingController();
  final _lastname = TextEditingController();
  final _gender = TextEditingController();
  final _date_of_birth = TextEditingController();
  final _address = TextEditingController();
  final _country = TextEditingController();
  final _locality = TextEditingController();
  final _facultate = TextEditingController();
  final _locatieConsiliere= TextEditingController();
  final _judet= TextEditingController();
  final _Oras= TextEditingController();
  final _orar= TextEditingController();
  final _Liceu= TextEditingController();
  final _Profile= TextEditingController();
  final _AndeStudi= TextEditingController();
  File _image ;
  String imgURL;

  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      Strname = userdata["fullname"].toString();
      _fnameController.text = userdata["fullname"].toString().split(" ")[0];
      _lastname.text = userdata["fullname"].toString().split(" ")[1];
      _emailController.text = userdata["email"].toString();
      struserid = userdata["userid"].toString();
      fetchData();
    });
    print("Print userdata in Side menu");
    print(userdata);

  }
  Future _prfofileDeletionRequest() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.DeleteAccountRequest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      showMyDialog(context, map["message"].toString());
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
  SaveProfileData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Profiledata", json.encode(map));
  }
  Future<List> getProfile() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetUserProfile;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();
      setState(() {
        _saving = false;
      });
//      if (Status == "200") {
//
//      } else {
//        showMyDialog(context, map["message"].toString());
//      }

      SaveProfileData(map);
      struserfolder = map["userFolder"];
      return map["listUser"];//listUser1
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
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        showMyDialog(context, map["romanMsg"].toString());
      }
    }

  }

  upload() async {
    // open a bytestream
    Map <String,String>_payload = {
      'user_id': struserid,
      'firstname': _fnameController.text,
      'lastname': _lastname.text,
      'email': _emailController.text,
      'phone': _phone.text,
      'dateOfBirth': _dob.text,
      'gender': "Male",
      'date_of_birth': _dob.text,
      'address': _address.text,
      'country': _country.text,
      'locality': _locality.text,
      'anStudiu': _AndeStudi.text,
      'profil': _Profile.text,
      'liceu': _Liceu.text,

    };

    Map <String,String> _header = {'End-Client': 'escon', 'Auth-Key': 'escon@2019'};
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    // get file length
    var length = await _image.length();

    // string to uri
    var uri = Uri.parse(API.Base_url + API.UpdateUserprofile);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    // multipart that takes file
    var multipartFile = new http.MultipartFile('pictureFile', stream, length,
        filename: _image.path);

    // add file to multipart
    request.files.add(multipartFile);
    request.fields.addAll(_payload);

    // send
    var streamedRest = await request.send();
    print(streamedRest.statusCode);
    // listen for response
    streamedRest.stream.transform(utf8.decoder).listen((value) {
      print(value);
      if(streamedRest.statusCode == 200)
      {

        setState(() {
          _saving = false;
        });
        showMyDialog(context, "Profil actualizat cu succes");

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(StrUserType: UserType.Pupil)));


      }
      else
      {
        setState(() {
          _saving = false;
        });
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
    });
  }
  Future updateProfile() async {
    //-------------------------------------------------------
    if (_fnameController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_lastname.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_emailController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_dob.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_phone.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_address.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_country.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_locality.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else {
      setState(() {
        _saving = true;
      });
      upload();
    }
  }

  //Image selection---------------------------------------------
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
  void fetchData() {
    getProfile().then((res) {

      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+res[0]["picture"];

      setState(() {
        _ProfileInfo = res[0];
        _dob.text = _ProfileInfo["dateOfBirth"];
        _emailController.text = _ProfileInfo["email"];
        _phone.text = _ProfileInfo["phone"];
        _lastname.text = _ProfileInfo["lastname"];
       // _gender.text = _ProfileInfo["phone"];
        _date_of_birth.text = _ProfileInfo["date_of_birth"];
        _address.text = _ProfileInfo["address"];
        _country.text = _ProfileInfo["country"];
        _locality.text = _ProfileInfo["locality"];
        _AndeStudi.text = _ProfileInfo["anStudiu"];
        _Profile.text = _ProfileInfo["profil"];
        _Liceu.text = _ProfileInfo["liceu"];
        _fnameController.text = _ProfileInfo["firstname"];
        _dob.text = _ProfileInfo["dateOfBirth"];
        imgURL = _imgURL;
      });
    });

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
  @override
  void initState() {
    super.initState();
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


  Widget build(BuildContext context) {
    final RequestDeleteAccBtn = Material(

        color: Colors.transparent,
        child:OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 3,
                  child: Text(
                    "Cerere stergere cont",
                  )
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.red,
          onPressed: () {
            _prfofileDeletionRequest();
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )

    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil", style: TextStyle(fontFamily: 'Demi',),textAlign: TextAlign.center),
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.only(top: 20,left: 25,right: 25,bottom: 25),
        //color: Colors.red,
       child: Container(
         color: Colors.white,
         alignment: Alignment.center,
         child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Center(
                 child: Container(
                   alignment: Alignment.center,
                   width: 150,
                   height: 150,
                   decoration: new BoxDecoration(
                       image: new DecorationImage(
                         image: _image == null ? ( imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL)) : FileImage(_image),
                         fit: BoxFit.fill,
                       ),
                       borderRadius: new BorderRadius.all(const Radius.circular(75))
                   ),
                 ),
               ),
               SizedBox(height: 10,),
               Container(

                   height: 19.0,
                   width: MediaQuery.of(context).size.width,
                   child:  RaisedButton(
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
                     color: Colors.white,
                     textColor: Colors.red,
                     elevation: 0,
                   )
               ),
               TextFormField(
                 decoration: InputDecoration(
                   labelText: 'Prenume',

                 ),
                 controller: _fnameController,
                 // initialValue: userdata["fullname"].toString().split(" ")[0] ,
               ),
               TextFormField(
                 decoration: InputDecoration(
                   labelText: 'Nume',

                 ),
                 controller: _lastname,
                 //  initialValue: userdata["fullname"].toString().split(" ")[1]
               ),
               TextFormField(
                   decoration: InputDecoration(
                     labelText: 'Nume de utilizator',

                   ),
                   enabled: false,
                   initialValue: userdata["username"].toString()
               ),
               TextFormField(
                 decoration: InputDecoration(
                   labelText: 'Email',
                 ),
                 controller: _emailController,
                 enabled: false,
                 //initialValue: userdata["email"].toString()
               ),
               TextFormField(
                 decoration: InputDecoration(
                     labelText: 'Telefon'
                 ),
                 controller: _phone,
                 keyboardType: TextInputType.phone,
                 maxLength: 12,
               ),
               Column(
                 mainAxisAlignment:  MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                   SizedBox(height: 8),
                   Text("Data nasterii"),
                   DateTimePickerFormField(format: dateFormat ,initialValue: DateTime(1970) ,controller:_dob ,editable: false,dateOnly:true, onChanged: (date) {
                     setState(() {
                       //
                     });
                     Scaffold
                         .of(context)
                         .showSnackBar(SnackBar(content: Text('$date'),));
                   }),
                 ],
               ),
               TextFormField(
                 decoration: InputDecoration(
                     labelText: 'Judet'
                 ),
                 controller: _country,
               ),
               TextFormField(
                 decoration: InputDecoration(
                     labelText: 'Oras'
                 ),
                 controller: _locality,
               ),
               TextFormField(
                 decoration: InputDecoration(
                     labelText: 'Adresa'
                 ),
                 controller: _address,
               ),
               TextFormField(
                 decoration: InputDecoration(
                   labelText: 'Liceu',
                 ),
               ),
               TextFormField(
                 decoration: InputDecoration(
                     labelText: 'Profil'
                 ),
                 controller: _Profile,
               ),
               TextFormField(
                 decoration: InputDecoration(
                     labelText: 'An de studiu'
                 ),
                 controller: _AndeStudi,
               ),
               SizedBox(height: 10),
               RequestDeleteAccBtn,
               SizedBox(height: 10),
               RaisedButton(
                 child: Stack(
                   children: <Widget>[
                     Align(
                         alignment: Alignment.center,
                         widthFactor: 4.5,
                         child: Text(
                             "Actualizați"
                         )
                     )
                   ],
                 ),
                 onPressed: (){
                   updateProfile();
                 },
                 color: Appcolor.AppGreen,
                 textColor: Colors.white,
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(20.0)
                 ),
               )

             ]
         ),
       ),
      ),

      drawer: Drawer(
        child: SideMenu(StrUserType: UserType.Pupil),
      ),
    );
  }
}

//Call Student Profile-----------------------------------

class StudentProfile extends StatefulWidget {
  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  bool switchOn = true;
  Map userdata;
  Map _ProfileInfo;
  bool _saving = false;
  String Strname = "";
  String struserid;
  String struserfolder;
  final dateFormat = DateFormat("yyyy-MM-dd");
  final _fnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dob = TextEditingController();
  final _phone = TextEditingController();
  final _lastname = TextEditingController();
  final _gender = TextEditingController();
  final _date_of_birth = TextEditingController();
  final _address = TextEditingController();
  final _country = TextEditingController();
  final _locality = TextEditingController();
  final _judet = TextEditingController();
  final _Oras = TextEditingController();
  File _image ;
  final _facultate= TextEditingController();
  final _nivelStudiu= TextEditingController();
  final _programStudiu= TextEditingController();
  final _anStudiu= TextEditingController();
  String imgURL;

  //API caLL---------------------------------------------------------
  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      Strname = userdata["fullname"].toString();
      _fnameController.text = userdata["fullname"].toString().split(" ")[0];
      _lastname.text = userdata["fullname"].toString().split(" ")[1];
      _emailController.text = userdata["email"].toString();
      struserid = userdata["userid"].toString();
      fetchData();
    });
    print("Print userdata in Side menu");
    print(userdata);

  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
  SaveProfileData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Profiledata", json.encode(map));
  }
  Future<List> getProfile() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetUserProfile;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      print("profile update = $map");
      setState(() {
        _saving = false;
      });
      //  showMyDialog(context, map["message"].toString());
      SaveProfileData(map);
      struserfolder = map["userFolder"];
      return map["listUser"];//listUser1
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
  Future _prfofileDeletionRequest() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.DeleteAccountRequest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      showMyDialog(context, map["message"].toString());
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

  upload() async {
    // open a bytestream
    Map <String,String>_payload = {
      'user_id': struserid,
      'firstname': _fnameController.text,
      'lastname': _lastname.text,
      'email': _emailController.text,
      'phone': _phone.text,
      'dateOfBirth': _dob.text,
      'gender': "Male",
    //  'date_of_birth': _dob.text,
      'address': _address.text,
      'country': _country.text,
      'locality': _locality.text,
      'facultate': _facultate.text,
      'nivelStudiu': _nivelStudiu.text,
      'programStudiu': _programStudiu.text,
      'anStudiu': _anStudiu.text,
      'oras': _Oras.text,
      'sefGrupa': switchOn.toString(),
    };
//    if (_image == null)
//      {
//       // _image = await getImageFileFromAssets('Images/DefaultUser.png');
//        final File localImage = await image.copy('$path/$fileName');
//
//        setState(() {
//          _image = newImage;
//        });
//      }

    Map <String,String> _header = {'End-Client': 'escon', 'Auth-Key': 'escon@2019'};

    // string to uri
    var uri = Uri.parse(API.Base_url + API.UpdateUserprofile);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    // multipart that takes file

//    if (_image != null)
//      {
        var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
        // get file length
        var length = await _image.length();

        var multipartFile = new http.MultipartFile('pictureFile', stream, length,
            filename: _image.path);

        // add file to multipart
        request.files.add(multipartFile);
     // }

    request.fields.addAll(_payload);

    // send
    var streamedRest = await request.send();
    print(streamedRest.statusCode);
    // listen for response
   // streamedRest.stream.transform(utf8.decoder).listen((value) {
     // print(value);
      if(streamedRest.statusCode == 200)
      {
//        Map<String, String> map = json.decode(value);
//        String Status = map["status"].toString();
        setState(() {
          _saving = false;
        });
        showMyDialog(context, "Profil actualizat cu succes");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(StrUserType: UserType.Student)));


      }
      else
      {
        setState(() {
          _saving = false;
        });
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
   // });
  }
  Future updateProfile() async {
    //-------------------------------------------------------
    if (_fnameController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_lastname.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
//    else if (_emailController.text.length < 1) {
//      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
//    }
    else if (_dob.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_phone.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_address.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_country.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_locality.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else {
      setState(() {
        _saving = true;
      });
      upload();
    }
  }
  //Image selection---------------------------------------------
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
  void fetchData() {

    getProfile().then((res) {

      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+res[0]["picture"];
      
      print("Image BaseURL00: "+_imgURL);

      setState(() {
        _ProfileInfo = res[0];
        _dob.text = _ProfileInfo["date_of_birth"];
        _emailController.text = _ProfileInfo["email"];
        _phone.text = _ProfileInfo["phone"];

      //  _gender.text = _ProfileInfo["phone"];
        _date_of_birth.text = _ProfileInfo["date_of_birth"];
        _address.text = _ProfileInfo["address"];
        _country.text = _ProfileInfo["country"];
        _locality.text = _ProfileInfo["locality"];
        _facultate.text = _ProfileInfo["facultate"];
        _nivelStudiu.text = _ProfileInfo["nivel_studiu"];
        _programStudiu.text = _ProfileInfo["program_studiu"];
        _anStudiu.text = _ProfileInfo["an_studiu"];
        _fnameController.text = _ProfileInfo["firstname"];
        _lastname.text = _ProfileInfo["lastname"];
        _dob.text = _ProfileInfo["dateOfBirth"];
        _Oras.text = _ProfileInfo["oras"];
        imgURL = _imgURL;
        if(_ProfileInfo["sef_grupa"].toString() == "0")
          {
            switchOn = false;
          }else
            {
              switchOn = true;
            }

      });


    });


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
  @override
  void initState() {
    super.initState();
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
  void _onSwitchChanged(bool value) {
    switchOn = false;
  }
  Widget build(BuildContext context) {
    final RequestDeleteAccBtn = Material(

        color: Colors.transparent,
        child:OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 3,
                  child: Text("Cerere stergere cont", style: TextStyle(fontFamily: 'regular'))
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.red,
          onPressed: () {
            _prfofileDeletionRequest();
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil", style: TextStyle(fontFamily: 'Demi',),textAlign: TextAlign.center),
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.only(top: 20,left: 25,right: 25,bottom: 25),
        //color: Colors.red,
        child: Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 150,
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: _image == null ? ( imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL)) : FileImage(_image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: new BorderRadius.all(const Radius.circular(75))
                  ),
                ),
              ),

              //new AssetImage("Assets/Images/DefaultUser.png")
              SizedBox(height: 15,),
              Container(
                  height: 19.0,
                  width: MediaQuery.of(context).size.width,
                  child:  RaisedButton(
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
                    color: Colors.white,
                    textColor: Colors.red,
                    elevation: 0,
                  )
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Prenume',

                ),
                controller: _fnameController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nume',

                ),
                controller: _lastname,
                //initialValue: userdata["fullname"].toString().split(" ")[1]
              ),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nume de utilizator',

                  ),
                  enabled: false,
                  initialValue: userdata["username"].toString()
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
                enabled: false,
                controller: _emailController,

              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Telefon'
                ),
                keyboardType: TextInputType.phone,
                maxLength: 12,
                controller: _phone,
              ),
              Column(
                mainAxisAlignment:  MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8),
                  Text("Data nasterii"),
                  DateTimePickerFormField(format: dateFormat, initialValue: DateTime(1970), initialDate: DateTime.now(), lastDate: DateTime.now(), controller: _dob,editable: true,dateOnly:true, onChanged: (date) {
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text('$date'),));
                  }),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Judet'
                ),
                controller: _locality,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Oras'
                ),

                controller: _Oras,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Adresa'
                ),
                controller: _address,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Facultate'
                ),
                controller: _country,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Nivel de studiu'
                ),
                controller: _nivelStudiu,
                  keyboardType: TextInputType.number
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Program de studiu'
                ),
                controller: _programStudiu,
                  keyboardType: TextInputType.number
              ),
              Column(
                mainAxisAlignment:  MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8),
                  Text("An de studiu"),
                  DateTimePickerFormField(format: dateFormat , controller: _anStudiu,initialDate:new DateTime.now()  ,editable: false,dateOnly:true, onChanged: (date) {
                    setState(() {
                      //
                    });
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text('$date'),));
                  }),
                ],
              ),
              Row(
                children: <Widget>[
                  Switch(
                    onChanged: _onSwitchChanged,
                    value: switchOn,
                    activeColor: Colors.green,
                  ),
                  Text("Sef de grupa")
                ],
              ),

              aGreyHorizonalLine,

              SizedBox(height: 10),
              RequestDeleteAccBtn,
              SizedBox(height: 10),
              RaisedButton(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        widthFactor: 4.5,
                        child: Text("Actualizați", style: TextStyle(fontFamily: 'regular'))
                    )
                  ],
                ),
                onPressed: (){ updateProfile();},
                color: Appcolor.AppGreen,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
              )
            ]
        ),
        ),
      ),
      drawer: Drawer(
        child: SideMenu(StrUserType: UserType.Student),
      ),
    );
  }
}

//Call Company represtative-------------------------------
class CompanyRepresentative extends StatefulWidget {
  @override
  _CompanyRepresentativeState createState() => _CompanyRepresentativeState();
}

class _CompanyRepresentativeState extends State<CompanyRepresentative> {
  Map userdata;
  Map _ProfileInfo;
  bool _saving = false;
  String Strname = "";
  String struserid;
  File _image ;
  String struserfolder;
  final dateFormat = DateFormat("yyyy-MM-dd");
  final _fnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dob = TextEditingController();
  final _phone = TextEditingController();
  final _lastname = TextEditingController();
  final _gender = TextEditingController();
  final _date_of_birth = TextEditingController();
  final _address = TextEditingController();
  final _country = TextEditingController();
  final _judet = TextEditingController();
  final _Oras = TextEditingController();
  final _Functiereprezentant = TextEditingController();
  final _Denumire_firma = TextEditingController();
  final _Site_Web_Firma = TextEditingController();
  final _Domeniul_Activitate = TextEditingController();
  final _Scurtadescriere = TextEditingController();


  String imgURL;

  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    userdata = json.decode(myString);
    setState(() {
      Strname = userdata["fullname"].toString();
      _fnameController.text = userdata["fullname"].toString().split(" ")[0];
      _lastname.text = userdata["fullname"].toString().split(" ")[1];
      _emailController.text = userdata["email"].toString();
      struserid = userdata["userid"].toString();
      fetchData();
    });
    print("Print userdata in Side menu");
    print(userdata);

  }
  SaveProfileData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("Profiledata", json.encode(map));
  }
  Future _prfofileDeletionRequest() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.DeleteAccountRequest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200) {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      showMyDialog(context, map["message"].toString());
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
  Future<List> getProfile() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetUserProfile;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();
      setState(() {
        _saving = false;
      });
//      if (Status == "200") {
//
//      } else {
//        showMyDialog(context, map["message"].toString());
//      }

      SaveProfileData(map);
      struserfolder = map["userFolder"];
      return map["listUser"];//listUser1
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
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        showMyDialog(context, map["romanMsg"].toString());
      }
    }

  }

  upload() async {
    // open a bytestream
    Map <String,String>_payload = {
      'user_id': struserid,
      'firstname': _fnameController.text,
      'lastname': _lastname.text,
      'email': _emailController.text,
      'phone': _phone.text,
      'dateOfBirth': _dob.text,
      'gender': "Male",
      'date_of_birth': _dob.text,
      'address': _address.text,
      'country': _country.text,
      'locality': _country.text,
      'functieReprezentant': _Functiereprezentant.text,
      'denumire': _Denumire_firma.text,
      'site': _Site_Web_Firma.text,
      'domeniuActivitate': _Domeniul_Activitate.text,
      'descriere': _Scurtadescriere.text,
      'public': "1",

    };


    Map <String,String> _header = {'End-Client': 'escon', 'Auth-Key': 'escon@2019'};
    var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
    // get file length
    var length = await _image.length();
    // string to uri
    var uri = Uri.parse(API.Base_url + API.UpdateUserprofile);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    // multipart that takes file
    var multipartFile = new http.MultipartFile('pictureFile', stream, length,
        filename: _image.path);

    // add file to multipart
    request.files.add(multipartFile);
    request.fields.addAll(_payload);

    // send
    var streamedRest = await request.send();
    print(streamedRest.statusCode);
    // listen for response
    streamedRest.stream.transform(utf8.decoder).listen((value) {
      print(value);
      if(streamedRest.statusCode == 200)
      {
        showMyDialog(context, "Profil actualizat cu succes");

        setState(() {
          _saving = false;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Dashboard(StrUserType: UserType.CP)));


      }
      else
      {
        setState(() {
          _saving = false;
        });
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
    });
  }
  Future updateProfile() async {
    //-------------------------------------------------------
    if (_fnameController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_lastname.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_emailController.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_dob.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_phone.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_address.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_country.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else {
      setState(() {
        _saving = true;
      });
      upload();
    }
  }

  //Image selection---------------------------------------------
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
  void fetchData() {
    getProfile().then((res) {

      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+res[0]["picture"];

      setState(() {
        _ProfileInfo = res[0];
        _dob.text = _ProfileInfo["dateOfBirth"];
        _emailController.text = _ProfileInfo["email"];
        _phone.text = _ProfileInfo["phone"];
        _lastname.text = _ProfileInfo["lastname"];
        _date_of_birth.text = _ProfileInfo["date_of_birth"];
        _dob.text = _ProfileInfo["dateOfBirth"];
        _address.text = _ProfileInfo["address"];
        _country.text = _ProfileInfo["country"];
        _fnameController.text = _ProfileInfo["firstname"];
        _Functiereprezentant.text = _ProfileInfo["functieReprezentant"];
        _Denumire_firma.text = _ProfileInfo["denumire"];
        _Site_Web_Firma.text = _ProfileInfo["site"];
        _Domeniul_Activitate.text = _ProfileInfo["domeniuActivitate"];
        _Scurtadescriere.text = _ProfileInfo["descriere"];
        imgURL = _imgURL;

      });
    });

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
  @override
  void initState() {
    super.initState();
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

  Widget build(BuildContext context) {
    final RequestDeleteAccBtn = Material(

        color: Colors.transparent,
        child:OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 3,
                  child: Text("Cerere stergere cont", style: TextStyle(fontFamily: 'regular'))

              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.red,
          onPressed: () {
            _prfofileDeletionRequest();
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )
    );
    return Scaffold(

      appBar: AppBar(
        title: Text("Profil", style: TextStyle(fontFamily: 'Demi',),textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body:SingleChildScrollView(
        padding: EdgeInsets.only(top: 0,left: 25,right: 25,bottom: 25),
        //color: Colors.red,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 150,
                  decoration:  BoxDecoration(
                      image:  DecorationImage(
                        image: _image == null ? ( imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL)) : FileImage(_image),
                        fit: BoxFit.fill,
                      ),
                      borderRadius:  BorderRadius.all(const Radius.circular(75))
                  ),
                ),
              ),
              Container(

                height: 19.0,
                width: MediaQuery.of(context).size.width,
                  child:  RaisedButton(
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
                    color: Colors.white,
                    textColor: Colors.red,
                    elevation: 0,
                  )
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Prenume',

                ),
               controller: _fnameController,
               // initialValue: userdata["fullname"].toString().split(" ")[0] ,
              ),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nume',

                  ),
                  controller: _lastname,
                 // initialValue: userdata["fullname"].toString().split(" ")[1]
              ),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nume de utilizator',

                  ),
                  enabled: false,
                  initialValue: userdata["username"].toString()
              ),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                 enabled: false,
                 controller: _emailController,
                 // initialValue: userdata["email"].toString()
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Telefon'
                ),
                keyboardType: TextInputType.phone,
                maxLength: 12,
                controller: _phone,
              ),

              Column(
                mainAxisAlignment:  MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 8),
                  Text("Data nasterii"),
                  DateTimePickerFormField(format: dateFormat ,initialValue: DateTime(1970) ,controller:_dob ,editable: false,dateOnly:true, onChanged: (date) {
                    setState(() {
                      //
                    });
                    Scaffold
                        .of(context)
                        .showSnackBar(SnackBar(content: Text('$date'),));
                  }),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Judet'
                ),
                controller: _judet,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Oras'
                ),
                controller: _Oras,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Adresa'
                ),
                controller: _address,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tara',
                ),
                controller: _country,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Functie reprezentant'
                ),
                controller: _Functiereprezentant,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Denumire firma'
                ),
                controller: _Denumire_firma,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Site Web Firma'
                ),
                controller: _Site_Web_Firma,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Domeniul Activitate'
                ),
                controller: _Domeniul_Activitate,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Scurta descriere a firmei',
                ),
                controller: _Scurtadescriere,
              ),
              SizedBox(height: 10),
              RequestDeleteAccBtn,
              SizedBox(height: 10),
              RaisedButton(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        widthFactor: 4.5,
                        child: Text("Actualizați", style: TextStyle(fontFamily: 'regular'))


                    )
                  ],
                ),
                onPressed: (){
                  updateProfile();
                },
                color: Appcolor.AppGreen,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
              )

            ]
        ),
      ),
      drawer: Drawer(
        child: SideMenu(StrUserType: UserType.CP),
      ),
    );
  }
}



