import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert' show json;
import 'package:http/http.dart' as http;
import 'package:escouniv/main.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:file_picker/file_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

enum SingingCharacter { radio1, radio2 }

class registrationStep2 extends StatefulWidget {
   String strUsername,strEmail,strPassword;
   String registrationTye;
  registrationStep2({Key key, this.strUsername, @required this.strEmail, this.strPassword,@required this.registrationTye}) : super(key: key);
  @override
  _registrationStep2State createState() => _registrationStep2State(strUsername,strEmail,strPassword,registrationTye);
}

class _registrationStep2State extends State<registrationStep2> {

  //SECTION: ========Widget and variable declarartion==============================
  List<Users> _users = Users.getUsers();
  List<DropdownMenuItem<Users>> _dropdownMenuItems;
  String strUsername,strEmail,strPassword;
  String registrationTye;
  SingingCharacter radioSelected = SingingCharacter.radio1;
  bool _groupValuenew = false;
  final dateFormat = DateFormat("yyyy-MM-dd");
  //Textfield controller
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _taraController = TextEditingController();
  final _judetController = TextEditingController();
  final _localitateController = TextEditingController();
  //for elve--------------------------------------------------------------------
  final _liceuController = TextEditingController();
  final _profileliceuController = TextEditingController();
  final _clasaController = TextEditingController();
  //----------------------------------------------------------------------------
  //For Student-----------------------------------------------------------------
  final _facultateController = TextEditingController();
  final _nivelstudiuController = TextEditingController();
  final _programstudiuController = TextEditingController();
  final _antudiuController = TextEditingController();
  //----------------------------------------------------------------------------
  //---For Career counsellor----------------------------------------------------
  final _ccFacultateController = TextEditingController();
  final _cclocatieconsiliereController = TextEditingController();
  final _ccOrarController = TextEditingController();
  //----------------------------------------------------------------------------
  //---For Psycological counsellor----------------------------------------------
  final _PClocatieconsiliereController = TextEditingController();
  final _pcOrarController = TextEditingController();
  //----------------------------------------------------------------------------
  //---For Mentor---------------------------------------------------------------
  final _mentorFacultateController = TextEditingController();
  final _mentorNivelStudiuController = TextEditingController();
  final _mentorProgramStudiuController = TextEditingController();
  final _mentorAnpromotieController = TextEditingController();
  final _mentorDomeniuSpecializareController = TextEditingController();
  final _mentorLoc_de_muncaController = TextEditingController();
  final _mentorFunctia_ocupata_la_locul_de_muncaController = TextEditingController();
  //----------------------------------------------------------------------------
  //---For Company representative-----------------------------------------------
  final _crFunctieReprezentantController = TextEditingController();
  final _crDenumireFirmaController = TextEditingController();
  final _crSiteFirmaController = TextEditingController();
  final _crDomeniu_de_ActivitateController = TextEditingController();
  final _crDescriereController = TextEditingController();
  final _isFirmpublic = false;
  SharedPreferences prefs;

  //----------------------------------------------------------------------------
  _registrationStep2State(this.strUsername,this.strEmail,this.strPassword,this.registrationTye);

  Users _selectedUser ;
  bool _saving = false;
  bool rememberMe = false;
  bool isChecked = false;
  String _filePath;
  File _image;
  String fileName;
  File pdfFile;

  @override
  void initState() {
    super.initState();
    getPreference();
    _dropdownMenuItems = buildDropdownMenuItems(_users);
    _selectedUser = _dropdownMenuItems[0].value;
    BackButtonInterceptor.add(myInterceptor);
  }

  getPreference() async {
    prefs = await SharedPreferences.getInstance();
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

  // 2. compress file and get file.
  Future<File> testCompressAndGetFile(File file, String targetPath) async {

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 70,
    );
    return result;
  }
  //SECTION:API CALL============================================================
  //Registration API-----------------------------

  Future<bool> studentRegistrationAPI() async {
    if(_fnameController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_lnameController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_localitateController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_judetController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_taraController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_addressController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_phoneController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }

   final String url = 'https://escouniv.ro/api/user/register';
    // final String url = 'http://192.168.1.111:8000/api/user/register';

    final client = new http.Client();
    if (_selectedUser.id == 1)
      {
        if (_image == null)
        {
          showMyDialog(context,'Selectați sigla');
          return false;
        }

        fileName = base64Encode(_image.readAsBytesSync());
      }

    if (_selectedUser.id == 5) {
      if (_filePath == null) {
        showMyDialog(context,'Selectați fișierul');
        return false;
      }
      fileName = _filePath.split("/").last;
    //  var pdfFile = File(_filePath);
      pdfFile = File(_filePath);
      int filesize = pdfFile.lengthSync();
     print("file size = $filesize");

    }

        setState(() {
      _saving = true;
    });

    Map _parameter = {};
    if (_selectedUser.id == 0)
    {
      Map _studentParameter = {
        'username': strUsername, //1
        'password': strPassword, //2
        'email': strEmail,//3
        'repeat_password': strPassword, //4
        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "student",//12
        'student[program_studiu]': _programstudiuController.text,//13
        'student[facultate]': _facultateController.text,//14
        'student[nivel_studiu]': _nivelstudiuController.text,//15
        'student[an_studiu]': _antudiuController.text,//16
        'student[sef_grupa]': "true",//17
      };
      _parameter = _studentParameter;
    }
    else if (_selectedUser.id == 1)
    {
      Map _firmParameter = {
        'username': strUsername, //1
        'password': strPassword, //2
        'email': strEmail,//3
        'repeat_password': strPassword, //4
        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "firma",//12
        'firma[functie_reprenzentant]': _crFunctieReprezentantController.text,//13
        'firma[denumire]': _crDenumireFirmaController.text,//14
        'firma[site]': _crSiteFirmaController.text,//15
        'firma[domeniu_activitate]': _crDomeniu_de_ActivitateController.text,//16
        'firma[descriere]': _crDescriereController.text,//16
        'firma[public]': _isFirmpublic.toString(),//17
        'firma[logo]': fileName,//18

      };
      _parameter = _firmParameter;
    }
    else if (_selectedUser.id == 2)
    {
      Map _mentorParameter = {
        'username': strUsername, //1
        'password': strPassword, //2
        'email': strEmail,//3
        'repeat_password': strPassword, //4
        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "mentor",//12
        'mentor[facultate]': _mentorFacultateController.text,//13
        'mentor[nivel_studiu]': _mentorNivelStudiuController.text,//14
        'mentor[program_studiu]': _mentorProgramStudiuController.text,//15
        'mentor[an_promotie]': _mentorAnpromotieController.text,//16
        'mentor[domeniu_specializare]': _mentorDomeniuSpecializareController.text,//17
        'mentor[loc_de_munca]': _mentorLoc_de_muncaController.text,//18
        'mentor[functie_loc_de_munca]': _mentorFunctia_ocupata_la_locul_de_muncaController.text//19

      };
      _parameter = _mentorParameter;
    }
    else if (_selectedUser.id == 3)
    {
      Map _pcParameter = {
        'username': strUsername, //1
        'password': strPassword, //2
        'email': strEmail,//3
        'repeat_password': strPassword, //4
        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "cp",//12
        'cp[locatie_consiliere]': _PClocatieconsiliereController.text,//13
        'cp[orar]': _pcOrarController.text,//14
      };
      _parameter = _pcParameter;
    }
    else if (_selectedUser.id == 4)
    {
      Map _ccParameter = {
        'username': strUsername, //1
        'password': strPassword, //2
        'email': strEmail, //3
        'repeat_password': strPassword, //4
        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "cc",//12
        'cc[facultate]': _ccFacultateController.text,//13
        'cc[locatie_consiliere]': _cclocatieconsiliereController.text,//14
        'cc[orar]': _ccOrarController.text,//15
      };
      _parameter = _ccParameter;
    }
    else{
      Map <String , dynamic>_pupilParameter = {
        'username': strUsername, //1
        'password': strPassword, //2
        'email': strEmail,//3
        'repeat_password': strPassword, //4
        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "elev",//12
        'elev[liceu]': _liceuController.text,//13
        'elev[profil]': _profileliceuController.text,//14
        'elev[an_studiu]': _clasaController.text,//15
        'elev[acord_parinte]': pdfFile,//16-----
      };

      _parameter = _pupilParameter;
    }
    print("print regiser parameter");
    print(_parameter);
    final streamedRest = await client.post(url,
      body: _parameter
    );

    if(streamedRest.statusCode == 200)
      {
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        String status = map["status"].toString();
        setState(() {
          _saving = false;
        });
        if( status == "200")
        {
          showMyDialog(context, "Inregistrarea in curs de aprobare");
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);

//          if(map["message"].toString() == "User registered successfully.")
//            {
//              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
//
//            }else
//              {
//                showMyDialog(context, map["message"].toString());
//              }


        }
        showMyDialog(context, map["romanMsg"].toString());
        print("print registration response");
        print(map);
      }
    else {
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
    if(_fnameController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_lnameController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_localitateController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_judetController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_taraController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_addressController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_phoneController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if (_filePath == null) {
      showMyDialog(context,'Selectați fișierul');
      return false;
    }
    fileName = _filePath.split("/").last;
    var pdfFile = File(_filePath);
    int filesize = pdfFile.lengthSync();
    print("file size = $filesize");
    // open a bytestream
    Map <String,String>_payload = {
      'username': strUsername, //1
      'password': strPassword, //2
      'email': strEmail,//3
      'repeat_password': strPassword, //4
      'firstname': _fnameController.text,//5
      'locality': _localitateController.text, //6
      'county': _judetController.text,//7
      'country': _taraController.text, //8
      'address': _addressController.text,//9
      'lastname': _lnameController.text, //10
      'phone': _phoneController.text,//11
      'type': "elev",//12
      'elev[liceu]': _liceuController.text,//13
      'elev[profil]': _profileliceuController.text,//14
      'elev[an_studiu]': _clasaController.text,//15

    };
    final String uri = 'https://escouniv.ro/api/user/register';
   // var uri = Uri.parse(API.Base_url + API.UpdateUserprofile);
    var request = new http.MultipartRequest("POST", Uri.parse(uri));
    Map <String,String> _header = {'End-Client': 'escon', 'Auth-Key': 'escon@2019'};
    
    //var multi = new http.MultipartFile.fromString(field, value)
    var multipartFile = new http.MultipartFile.fromString('elev[acord_parinte]', fileName);
    request.headers.addAll(_header);
    request.fields.addAll(_payload);
    request.files.add(multipartFile);
        request.send().then((streamedRest) {
      if (streamedRest.statusCode == 200) {
        setState(() {
          _saving = false;
        });
        showMyDialog(context, "Inregistrarea in curs de aprobare");
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      }
      else {
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
          //Map<dynamic, dynamic> map = json.decode(streamedRest.body);
          showMyDialog(context, "Ceva n-a mers bine");
        }

      }

    });
  }
  Future<bool> studentSocialRegistrationAPI() async {
    if(_fnameController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_lnameController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_localitateController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_judetController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_taraController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_addressController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }
    if(_phoneController.text.length <1) {

      showMyDialog(context,"Vă rugăm să completați câmpul");
      return false;
    }

    if (_selectedUser.id == 1)
    {
      if (_image == null)
      {
        showMyDialog(context,'Selectați sigla');
        return false;
      }

      List<int> imageBytes = _image.readAsBytesSync();
      print(imageBytes);
      fileName = base64Encode(imageBytes);

     
     
   //   fileName = base64Encode(_image.readAsBytesSync());
    //  var imageFile = File(_filePath);
//      int filesize = imageFile.lengthSync();
     // print("image size = $filesize");
    }

    if (_selectedUser.id == 5) {

      if (_filePath == null) {
        showMyDialog(context,'Selectați fișierul');
        return false;
      }
      fileName = _filePath.split("/").last;
      var pdfFile = File(_filePath);
      int filesize = pdfFile.lengthSync();
      print("file size = $filesize");

    }

    Map _parameter = {};

    if (_selectedUser.id == 0)
    {
      Map _studentParameter = {

        'email': strEmail,//3

        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "student",//12
        'student[program_studiu]': _programstudiuController.text,//13
        'student[facultate]': _facultateController.text,//14
        'student[nivel_studiu]': _nivelstudiuController.text,//15
        'student[an_studiu]': _antudiuController.text,//16
        'student[sef_grupa]': "true",//17
      };

      _parameter = _studentParameter;
    }
    else if (_selectedUser.id == 1)
    {
      Map _firmParameter = {

        'email': strEmail,//3

        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "firma",//12
        'firma[functie_reprezentat]': _crFunctieReprezentantController.text,//13
        'firma[denumire]': _crDenumireFirmaController.text,//14
        'firma[site]': _crSiteFirmaController.text,//15
        'firma[domeniu_activitate]': _crDomeniu_de_ActivitateController.text,//16
        'firma[descriere]': _crDescriereController.text,//16
        'firma[public]': _isFirmpublic.toString(),//17
        'firma[logo]': fileName,//18

      };
      _parameter = _firmParameter;
    }
    else if (_selectedUser.id == 2)
    {
      Map _mentorParameter = {
        'email': strEmail,//3
        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "mentor",//12
        'mentor[facultate]': _mentorFacultateController.text,//13
        'mentor[nivel_studiu]': _mentorNivelStudiuController.text,//14
        'mentor[program_studiu]': _mentorProgramStudiuController.text,//15
        'mentor[an_promotie]': _mentorAnpromotieController.text,//16
        'mentor[domeniu_specializare]': _mentorDomeniuSpecializareController.text,//17
        'mentor[loc_de_munca]': _mentorLoc_de_muncaController.text,//18
        'mentor[functie_loc_de_munca]': _mentorFunctia_ocupata_la_locul_de_muncaController.text//19
      };
      _parameter = _mentorParameter;
    }
    else if (_selectedUser.id == 3)
    {
      Map _pcParameter = {

        'email': strEmail,//3

        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "cp",//12
        'cp[locatie_consiliere]': _PClocatieconsiliereController.text,//13
        'cp[orar]': _pcOrarController.text,//14
      };
      _parameter = _pcParameter;
    }
    else if (_selectedUser.id == 4)
    {
      Map _ccParameter = {

        'email': strEmail, //3

        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "cc",//12
        'cc[facultate]': _ccFacultateController.text,//13
        'cc[locatie_consiliere]': _cclocatieconsiliereController.text,//14
        'cc[orar]': _ccOrarController.text,//15
      };
      _parameter = _ccParameter;
    }
    else{
      Map _pupilParameter = {

        'email': strEmail,//3
        'firstname': _fnameController.text,//5
        'locality': _localitateController.text, //6
        'county': _judetController.text,//7
        'country': _taraController.text, //8
        'address': _addressController.text,//9
        'lastname': _lnameController.text, //10
        'phone': _phoneController.text,//11
        'type': "elev",//12
        'elev[liceu]': _liceuController.text,//13
        'elev[profil]': _profileliceuController.text,//14
        'elev[an_studiu]': _clasaController.text,//15
        'elev[acord_parinte]': fileName,//16-----
      };
      _parameter = _pupilParameter;
    }
    setState(() {
      _saving = true;
    });
    print("print regiser parameter");
    print(_parameter);
    //http://192.168.1.20:8000/api/social/login
    //'https://escouniv.ro/api/social/register/step2';
  //  final String url = 'http://192.168.1.111:8000/api/social/register/step2';
   final String url = 'https://escouniv.ro/api/social/register/step2';
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: _parameter
      //  headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    );

    if(streamedRest.statusCode == 200)
    {   setState(() {
      _saving = false;
    });
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String status = map["status"].toString();
      if( status == "200")
      {
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      }

      showMyDialog(context, map["message"].toString());
      print("print registration response");
      print(map);
    }else {
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
        showMyDialog(context, "Server error");
      }

    }
  }

  //Comman Alert----------------------------------------------------------------------
  showMyDialog(BuildContext context, String strmsg) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return new AlertDialog(
            content: Text(
              strmsg,
            ),
            title: Text("ESCOUNIV"),
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
  //Drop down mebu
  List<DropdownMenuItem<Users>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Users>> items = List();
    for (Users user in _users) {
      items.add(
        DropdownMenuItem(
          value: user,
          child: Text(user.name),
        ),
      );
    }
    return items;
  }
  Widget build(BuildContext context) {
    //SECTION:-For image and file selection---------------------------------------------------------

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
    void getFilePath() async {
      try {
       String filePath = await FilePicker.getFilePath(type: FileType.CUSTOM, fileExtension: 'pdf');
        if (filePath == '') {
          return;
        }
        print("File path: " + filePath);
        setState(()
        {
          this._filePath = filePath;
        });
      } on Platform catch (e) {
        print("Error while picking the file: " + e.toString());
      }
    }
    //SECTION:-Button declaration-----------------------------------------------
    final uploadbtn = Material(
        color: Appcolor.redHeader,

        child:FlatButton(
          color: Appcolor.redHeader,
         child: Text("+",style: TextStyle(color: Colors.white,fontSize: 30),),

          onPressed: () {
            if (_selectedUser.id == 1)
            {
              _selectimagefrom(context, 'Select logo from');

            }else
              {

                getFilePath();
              }

          }, //callback when button is clicked
        )
    );
    final RegisterAction = Material(

        color: Colors.transparent,
        child:OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 3,
                  child:Text("Inregistrare", style: TextStyle(fontFamily: 'regular'))
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Colors.red,
          onPressed: () {
            if (registrationTye == "Social")
              {
                print("REgistration type = $registrationTye");
                studentSocialRegistrationAPI();
              }else
                {
                  print("REgistration type = $registrationTye");

                  if(_selectedUser.id == 5)
                    {
                      upload();
                    }else
                      {
                        studentRegistrationAPI();
                      }

                }
//studentRegistrationAPI();

          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Colors.red, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )
    );
    onChangeDropdownItem(Users SelectedUser) {
      setState(() {
        _selectedUser = SelectedUser;
      });
    }
    Widget _myRadioButton({String title, int value, Function onChanged}) {
      return RadioListTile(
        value: value,
        groupValue: _groupValuenew,
        onChanged: onChanged,
        title: Text(title),
        activeColor: Appcolor.redHeader,
      );
    }
    //SECTION:- Custom widget according to user type------------
    Widget elevview()
    {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Liceu',

              ),
              controller: _liceuController,

            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Profil liceu',

              ),
              controller: _profileliceuController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Clasa',
              ),
              controller: _clasaController,
              keyboardType: TextInputType.number
            ),
            SizedBox(height: 20,),
            Text("Acord Parinte PDF",style: TextStyle(fontSize: 18,fontFamily: 'regular',color: Colors.black),),
            SizedBox(height: 20,),
            Row(
    children: <Widget>[

      Container(
        height: 50,
        width: 50,
        child:uploadbtn ,
      ),
      SizedBox(width: 10,),
      Text('Alege fisierul',style: TextStyle(fontSize: 15,fontFamily: 'regular',color: Colors.black),),

        ],
         ),
            SizedBox(height: 25,)
          ],
        ),
      );
    }
    Widget mentorview()
    {
      return Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Facultate',

              ),
              controller: _mentorFacultateController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nivel Studiu',
              ),
              controller: _mentorNivelStudiuController,
                keyboardType: TextInputType.number
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Program Studiu',


              ),
              controller: _mentorProgramStudiuController,
                keyboardType: TextInputType.number
            ),

            Column(
              mainAxisAlignment:  MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Text("An Promotie"),
                DateTimePickerFormField(format: dateFormat,firstDate:new DateTime.now() ,initialDate:new DateTime.now() ,controller:_mentorAnpromotieController ,editable: false,dateOnly:true, onChanged: (date) {
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
                labelText: 'Domeniu Specializare',

              ),
              controller: _mentorDomeniuSpecializareController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Loc de munca',
              ),
              controller: _mentorLoc_de_muncaController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Functia Ocupata la locul De munca'
              ),
              controller: _mentorFunctia_ocupata_la_locul_de_muncaController,
            ),
            SizedBox(height: 20,),
          ],
        ),
      );
    }
    Widget ccview()
    {
      return Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Facultate',
              ),
              controller: _ccFacultateController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Locatai Consiliere',
              ),
              controller: _cclocatieconsiliereController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Orar[L-V]',
                 hintText: "Examplu : 09-18"
              ),
              controller: _ccOrarController,

            ),
            SizedBox(height: 20,),
          ],
        ),
      );
    }
    Widget pcview()
    {
      return Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Locatai Consiliere',
              ),
              controller: _PClocatieconsiliereController,
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Orar[L-V]',
                  hintText: "Examplu : 09-18"
              ),
              controller: _pcOrarController,
            ),
            SizedBox(height: 20,),
          ],
        ),
      );
    }
    Widget studentview()
    {

      return Container(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Facultate',

              ),
              controller: _facultateController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nivel Studiu',

              ),
              keyboardType: TextInputType.number,
              controller: _nivelstudiuController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Program Studiu',

              ),
              controller: _programstudiuController,
                keyboardType: TextInputType.number
            ),

            Column(
              mainAxisAlignment:  MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                Text("An"),
                DateTimePickerFormField(format: dateFormat,firstDate:new DateTime.now() ,initialDate:new DateTime.now() ,controller:_antudiuController ,editable: false,dateOnly:true, onChanged: (date) {
                  setState(() {
                    //
                  });
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text('$date'),));
                }),
              ],
            ),

            SizedBox(height: 20,),
            CheckboxListTile(
    title: Text("Sef grupa"),
    value: isChecked,
    onChanged: (newValue) {  setState(()
    {
      isChecked = newValue;
               }); },
    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
    ),
            SizedBox(height: 20,),
          ],
        ),
      );
    }
    Widget farmview()
    {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Functie Reprezentant',
              ),
              controller: _crFunctieReprezentantController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Dinumire Firma',
              ),
              controller: _crDenumireFirmaController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Site Firma',

              ),
              controller: _crSiteFirmaController,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Domeniu de Activitate',

              ),
              controller: _crDomeniu_de_ActivitateController,
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Descriere',
              ),
              maxLines: 4,
              controller: _crDescriereController,
            ),
           SizedBox(height: 20,),
           Text("Logo"),
            SizedBox(height: 10,),
            Row(
    children: <Widget>[
      Container(
        height: 50,
        width: 50,
        child:uploadbtn ,
      ),
      SizedBox(width: 20,),
      Text('Alege fisierul')
    ],
    ),
          
            SizedBox(height: 20,),
            //
            CheckboxListTile(
              title: Text("Public"),
              value: isChecked,
              onChanged: (newValue) {  setState(()
              {
                isChecked = newValue;
              }); },
              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            ),
            /////
          ],
        ),
      );
    }
    Widget setwidget()
    {
      if (_selectedUser.id == 0)
      {
        return studentview();
      }
      else if (_selectedUser.id ==1)
      {
        return farmview();
      }
      else if (_selectedUser.id == 2)
      {
        return mentorview();
      }
      else if (_selectedUser.id == 3)
      {
        return pcview();
      }
      else if (_selectedUser.id == 4)
      {
        return ccview();
      }
      else{
        return elevview();
      }
    }

    //SECTION:-  Main view loading here------------------------------------------------
    return Scaffold(
      appBar: AppBar(
        title: Text("Inregistrare: Pasul 2", style: TextStyle(fontFamily: 'Demi'),textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body:ModalProgressHUD(inAsyncCall: _saving, child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 0,left: 25,right: 25,bottom: 25),
        //color: Colors.red,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nume',
                ),
                controller: _fnameController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Prenume',
                ),
                controller: _lnameController,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Telefon'
                ),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 12,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Adresa'
                ),
                controller: _addressController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tara',
//                  suffixIcon: const Icon(
//                    Icons.keyboard_arrow_down,
//                    color: Colors.red,
//                  ),
                ),
                controller: _taraController,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Judet'
                ),
                controller: _judetController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Localitate',
                ),
                controller: _localitateController,
              ),
              SizedBox(height: 20,),
              Text("Tip de utilizator", textAlign: TextAlign.left,style: TextStyle(fontSize: 15,color: Colors.black54),),

              Container(
                height: 50,

                //width: double.infinity,
                child: DropdownButton(items: _dropdownMenuItems,
                  onChanged: onChangeDropdownItem,icon:Icon(Icons.keyboard_arrow_down,
                      color: Appcolor.redHeader),value: _selectedUser,hint: Text('Selecteaza un tip ',)),
              ),
              setwidget(),
        CheckboxListTile(

          title: Text("Ați citit politica de confidențialitate și cookies și sunteți de acord cu procesarea datelor",),
          value: _groupValuenew,
          onChanged: (newValue) {
            setState(() {
              _groupValuenew = newValue;
            });
          },
          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
        ),


              SizedBox(height: 30),
              Center(child: RegisterAction,)
            ]
        ),
      ),),
    );
  }
}


class Users {
  int id;
  String name;
  Users(this.id, this.name);

  static List<Users> getUsers() {
    return <Users>[
      Users(0, 'Student'),
      Users(1, 'Reprezentantul companiei'),
      Users(2, 'Mentor'),
      Users(3, 'Consilier psihologic'),
      Users(4, 'Consilier în carieră'),
      Users(5, 'Elev'),
    ];
  }
}