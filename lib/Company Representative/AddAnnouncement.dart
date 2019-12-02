import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert' ;
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class AddAnnouncement extends StatefulWidget {
  final UserType User;
    final bool forEdit;
  final Map mdata;
  AddAnnouncement({Key key, @required this.User,@required this.forEdit,@required this.mdata}) : super(key: key);
  @override
  _AddAnnouncementState createState() => _AddAnnouncementState(User,forEdit,mdata);
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  final UserType User;
  final bool forEdit;
  final Map mdata;
  //Dropdown items-------------


  _AddAnnouncementState(this.User,this.forEdit,this.mdata);

  List<VisibilityType> _users = VisibilityType.getUsers();
  List<DropdownMenuItem<VisibilityType>> _dropdownMenuItems;

  List<TipanuntType> _users1 = TipanuntType.getUsers();
  List<DropdownMenuItem<TipanuntType>> _dropdownMenuItems1;

 //Radio button items--------------
  int _groupValuenew = -1;
  int _active = -1;
  File _image;
  bool _saving = false;
  String struserid;
  Map<String,String> _payload;
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _localite = TextEditingController();
  TipanuntType _selectedTipanunt;
  VisibilityType _selvisibilityTye;

  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';

    setState(() {
      Map userdata = json.decode(myString);
      struserid = userdata["userid"].toString();
      print(userdata);
    });
    print("Print userdata in Side menu");
    if(forEdit == true)
      {
        FetchAnnouncementDetail();
      }

  }


  FetchAnnouncementDetail()
  {
    _title.text = mdata["titlu"].toString();
    _description.text = mdata["descriere"].toString();
    _localite.text = mdata["localitate"].toString();
    _active = int.parse( mdata["status"].toString());

    if (mdata["vizibilitate"].toString() == "1")
      {
        _selvisibilityTye = _dropdownMenuItems[1].value;
      }
    else
      {
        _selvisibilityTye = _dropdownMenuItems[2].value;
      }
    if (mdata["tip_anunt"].toString() == "1")
    {
      _selvisibilityTye = _dropdownMenuItems[1].value;
    }
     else if (mdata["tip_anunt"].toString() == "2")
    {
      _selvisibilityTye = _dropdownMenuItems[2].value;
    }
    else if (mdata["tip_anunt"].toString() == "3")
    {
      _selvisibilityTye = _dropdownMenuItems[3].value;
    }
    else if (mdata["tip_anunt"].toString() == "4")
    {
      _selvisibilityTye = _dropdownMenuItems[4].value;
    }else
      {
        _selvisibilityTye = _dropdownMenuItems[5].value;
      }
  }

  //--------API Call----------------------------------------------------

  upload() async {
    var uri;

    if(User == UserType.Mentor)
    {
      // For mentor------------------
      if(forEdit == true)
      {
        uri = Uri.parse(API.Base_url + API.UpdateMentorAnnouncement);
        _payload = {
          'anunt_id': mdata["id"].toString(),
          'user_id':struserid,
          'titlu': _title.text,
          'descriere': _description.text,
          'localitate': _localite.text,
          // 'slug': "rt456",
//      'tipAnunt': _selectedTipanunt.id.toString(),
//      'vizibilitate': _selvisibilityTye.id.toString(),
          'tipAnunt': _selectedTipanunt.id.toString(),
          'vizibilitate': _selvisibilityTye.id.toString(),
          'setInactiv': _active.toString(),
          'acces_id': struserid,
        };

      }
      else
      { uri = Uri.parse(API.Base_url + API.AddMentorAnnouncement);

        _payload = {

          'user_id':struserid,
          'titlu': _title.text,
          'descriere': _description.text,
          'localitate': _localite.text,
          'tipAnunt': _selectedTipanunt.id.toString(),
          'vizibilitate': _selvisibilityTye.id.toString(),
          'tipAnunt': "3",
          'vizibilitate': "1",
          'setInactiv': _active.toString(),
          'acces_id': struserid,
        };
      }
    }
    else
    {
      if(forEdit == true)
      {
        uri = Uri.parse(API.Base_url + API.UpdateMentorAnnouncement);
        _payload = {
          'user_id':struserid,
          'anunt_id': mdata["id"].toString(),
          'titlu': _title.text,
          'descriere': _description.text,
          'localitate': _localite.text,
          'tipAnunt': _selectedTipanunt.id.toString(),
          'vizibilitate': _selvisibilityTye.id.toString(),
          'setInactiv': _active.toString(),
          'acces_id': struserid,
        };

      }
      else
      {
        uri = Uri.parse(API.Base_url + API.AddMentorAnnouncement);
        _payload = {
          'user_id':struserid,
          'titlu': _title.text,
          'descriere': _description.text,
          'localitate': _localite.text,
          'tipAnunt': _selectedTipanunt.id.toString(),
          'vizibilitate': _selvisibilityTye.id.toString(),
          'setInactiv': _active.toString(),
          'acces_id': struserid,
        };
      }
    }

    print("print announcement payload = $_payload");
    setState(() {
      _saving = true;
    });

    Map <String,String> _header = {'End-Client': 'escon', 'Auth-Key': 'escon@2019'};
    // string to uri

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_header);
    // multipart that takes file

    if (_image != null)
    {
      var stream = new http.ByteStream(DelegatingStream.typed(_image.openRead()));
      // get file length
      var length = await _image.length();

      var multipartFile = new http.MultipartFile('fisierNou', stream, length,
          filename: _image.path);

      // add file to multipart
      request.files.add(multipartFile);
    }

    request.fields.addAll(_payload);


    var streamedRest = await request.send();
    print(streamedRest.statusCode);

    if(streamedRest.statusCode == 200)
    {
      setState(() {
        _saving = false;
      });
      showMyDialog(context, "Anunțul a fost adăugat cu succes");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(StrUserType: User)));


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
  Future _AddannouncementAPI() async {
    //-------------------------------------------------------
    if (_title.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_description.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_localite.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }

    else {
      setState(() {
        _saving = true;
      });
      upload();
    }
  }

  Future _UpdateannouncementAPI() async {
    //-------------------------------------------------------
    if (_title.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else  if (_description.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }
    else if (_localite.text.length < 1) {
      showMyDialog(context, "Vă rugăm să introduceți tot câmpul");
    }

    else {
      setState(() {
        _saving = true;
      });
      upload();
    }
  }
  //----------------- disable back button--------------------------------
  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButtonEvent) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }
  //----------------- Image selection--------------------------------
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

  List<DropdownMenuItem<VisibilityType>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<VisibilityType>> items = List();
    for (VisibilityType user in _users) {
      items.add(
        DropdownMenuItem(
          value: user,
          child: Text(user.name),
        ),
      );
    }
    return items;
  }
  List<DropdownMenuItem<TipanuntType>> buildDropdownMenuItems1(List companies) {
    List<DropdownMenuItem<TipanuntType>> items = List();
    for (TipanuntType user in _users1) {
      items.add(
        DropdownMenuItem(
          value: user,
          child: Text(user.name),
        ),
      );
    }
    return items;
  }



  //----------------Comman Alert-----------------
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
  String dropdownValue = 'One';


  @override
  void initState() {
    super.initState();

    _dropdownMenuItems = buildDropdownMenuItems(_users);
    _selvisibilityTye = _dropdownMenuItems[0].value;

    _dropdownMenuItems1 = buildDropdownMenuItems1(_users1);
    _selectedTipanunt = _dropdownMenuItems1[0].value;

    BackButtonInterceptor.add(myInterceptor);
    GetUserdata();
  }

  Widget build(BuildContext context) {
    onChangeDropdownVisibility(VisibilityType SelectedUser) {
      setState(() {
        _selvisibilityTye = SelectedUser;
      });
    }
    onChangeDropdowntipanunt(TipanuntType SelectedUser) {
      setState(() {
        _selectedTipanunt = SelectedUser;
      });
    }
    //Radio buttons----------------------------------
    Widget _myRadioButton({String title, int value, Function onChanged}) {
      return RadioListTile(
        value: value,
        groupValue: _groupValuenew,
        onChanged: onChanged,
        title: Text(title),
        activeColor: Appcolor.redHeader,
      );
    }

    Widget _myRadioaActive({String title, int value, Function onChanged}) {
      return RadioListTile(
        value: value,
        groupValue: _active,
        onChanged: onChanged,
        title: Text(title),
        activeColor: Appcolor.redHeader,
      );
    }
    final btnUploadFile = Material(

        color: Colors.transparent,
        child:OutlineButton(
          child: Stack(
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  widthFactor: 6,
                  child: Text(
                    "Incarca fisier",
                  )
              )
            ],
          ),
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
          textColor: Appcolor.AppGreen,
          onPressed: () {
            _selectimagefrom(context, "Selectați fișierul");
          }, //callback when button is clicked
          borderSide: BorderSide(
            color: Appcolor.AppGreen, //Color of the border
            style: BorderStyle.solid, //Style of the border
            width: 1, //width of the border
          ),
        )
    );
    return Scaffold(
      appBar: AppBar(

        title: Text(forEdit == false?"Adauga anunt":"Editează anunt"),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.notifications),
            onTap: () {
              print("click search");
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ModalProgressHUD(inAsyncCall: _saving, child: SingleChildScrollView(
        padding: EdgeInsets.only(top: 0,left: 25,right: 25,bottom: 25),
        //color: Colors.red
        //
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Titlu'
                ),
                controller: _title,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Localitate'
                ),
                controller: _localite,
              ),
              SizedBox(height: 10),
              Text(
                "Descriere",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                    hintText: ''
                ),
                controller: _description,
              ),
              SizedBox(height: 10),
              Text(
                "Tip anunt",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),
              ),
              Container(
                height: 50,
                width: double.infinity,
                child: DropdownButton(items: _dropdownMenuItems1,
                    onChanged: onChangeDropdowntipanunt,icon:Icon(Icons.keyboard_arrow_down,
                        color: Appcolor.redHeader),value: _selectedTipanunt,hint: Text('Selecteaza Vizibilitate',)),
              ),

              SizedBox(height: 10),
              Text(
                "Vizibilitate",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),
              ),
        Container(
          height: 50,
          width: double.infinity,
          child: DropdownButton(items: _dropdownMenuItems,
              onChanged: onChangeDropdownVisibility,icon:Icon(Icons.keyboard_arrow_down,
                  color: Appcolor.redHeader),value: _selvisibilityTye,hint: Text('Selecteaza un tip ',)),
        ),

              SizedBox(height: 10),
              Text(
                "Fisier detalii",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),
              ),
              SizedBox(height: 10),
              btnUploadFile,
              SizedBox(height: 10),
              Text(
                "Pentru",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),
              ),
              _myRadioaActive(
                title: "Inactiv",
                value: 0,
                onChanged: (newValue) => setState(() => _active = newValue),
              ),
              SizedBox(height: 10),
              RaisedButton(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            forEdit== false?"Salveaza":"Editați | ×"
                        )
                    )
                  ],
                ),
                onPressed: (){
                  if(forEdit == true)
                  {
                    _UpdateannouncementAPI();
                    // print("In edit mode");
                    //    showMyDialog(context, "In Development mode");
                  }
                  else
                  {
                    _AddannouncementAPI();
                  }

                },
                color: Appcolor.AppGreen,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
              )
            ]
        ),
      )),
    );
  }
}


class VisibilityType {
  int id;
  String name;
  VisibilityType(this.id, this.name);
  static List<VisibilityType> getUsers() {
    return <VisibilityType>[
      VisibilityType(1, 'Public'),
      VisibilityType(2, 'Doar pentru utilizatori'),
    ];
  }
}


class TipanuntType{
  int id;
  String name;
  TipanuntType(this.id, this.name);

  static List<TipanuntType> getUsers() {
    return <TipanuntType>[
      TipanuntType(1, 'Anunt'),
      TipanuntType(2, 'Oferta loc de munca'),
      TipanuntType(3, 'Oferta internship/practica'),
      TipanuntType(4, 'Mentorat Licenta'),
      TipanuntType(5, 'Mentorat Disertatie'),
    ];
  }
}
