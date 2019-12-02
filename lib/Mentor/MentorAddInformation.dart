import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum SingingCharacter { lafayette, jefferson }

class AddInformation extends StatefulWidget {
  @override
  final UserType User;
  final bool forEdit;
  final Map mdata;
  AddInformation(
      {Key key,
      @required this.User,
      @required this.forEdit,
      @required this.mdata})
      : super(key: key);
  _AddInformationState createState() =>
      _AddInformationState(User, forEdit, mdata);
}

class _AddInformationState extends State<AddInformation> {
  final UserType User;
  final bool forEdit;
  final Map mdata;
  _AddInformationState(this.User, this.forEdit, this.mdata);
  String struserid;
  Visibilty _selectedUser;
  bool isSaving = false;
  int _groupValuenew = -1;
  int _groupValuenew1 = -1;
  int _ISActive = -1;
  File _image;
  bool _saving = false;
  List<Visibilty> _users = Visibilty.getUsers();
  List<DropdownMenuItem<Visibilty>> _dropdownMenuItems;
  final TextEditingController _title = new TextEditingController();
  final TextEditingController _Description = new TextEditingController();
  final TextEditingController _Cprinciple = new TextEditingController();
  final TextEditingController _VideoLink = new TextEditingController();

  //----------------- Image selection--------------------------------
  openGallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 240, maxWidth: 320);
    setState(() {
      _image = image;
    });
  }

  openCamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 240, maxWidth: 320);
    setState(() {
      _image = image;
    });
  }

  _selectimagefrom(BuildContext context, String strmsg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
                child: const Text('Guillery'),
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
        });
  }

//Privaye methods-------
  GetUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    Map userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();
      if (forEdit == true) {
        FetchInformationDetail();
      }
    });
    print("Print userdata in Side menu");
  }

  FetchInformationDetail() {
    _title.text = mdata["titlu"].toString();
    _Description.text = mdata["descriere"].toString();
    _Cprinciple.text = mdata["continut_principal"].toString();
    _VideoLink.text = mdata["video_link"].toString();
    _ISActive = int.parse(mdata["video_link"].toString());

    if (mdata["vizibilitate"].toString() == "0") {
      _selectedUser = _dropdownMenuItems[1].value;
    } else {
      _selectedUser = _dropdownMenuItems[2].value;
    }
    // _selvisibilityTye =
/*//
"id": "11",
            "creat_de": "143",
            "fisier_id": null,
            "data_adaugarii": "2019-08-21 07:08:30",
            "data_ultimei_modificari": "0000-00-00 00:00:00",
            "titlu": "hyfvbfj",
            "slug": "test121",
            "localitate": null,
            "descriere": "test",
            "tip_anunt": "3",
            "status": "0",
            "vizibilitate": "2"
* */
  }

  onChangeDropdownItem(Visibilty SelectedUser) {
    setState(() {
      _selectedUser = SelectedUser;
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

  List<DropdownMenuItem<Visibilty>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Visibilty>> items = List();
    for (Visibilty user in _users) {
      items.add(
        DropdownMenuItem(
          value: user,
          child: Text(user.name),
        ),
      );
    }
    return items;
  }
  //API Methods------------------

  Future<bool> addinformationaPI() async {
    if (_title.text.length < 1 ||
        _Description.text.length < 1 ||
        _VideoLink.text.length < 1 ||
        _selectedUser == null) {
      showMyDialog(context, 'Vă rugăm să furnizați toate informațiile');
      return false;
    } else {
      setState(() {
        isSaving = true;
      });
      Map _payload = {
        'user_id': struserid,
        'titlu': _title.text,
        'descriere': _Description.text,
        'continut_principal': _Cprinciple.text,
        'video_link': _VideoLink.text,
        'type': "student",
        'active': _ISActive == -1 ? "false" : "true",
      };
      print(_payload);

      String _usertype = "Student";
      final String url = API.Base_url + API.AddInformation;
      final client = new http.Client();
      final streamedRest = await client.post(url,
          body: _payload,
          headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
      print(streamedRest.body);

      if (streamedRest.statusCode == 200) {
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        int Status = map["status"] as int;
        if (Status == 200) {
          setState(() {
            isSaving = false;
          });
          showMyDialog(context, map["message"].toString());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Dashboard(StrUserType: User)));
          return true;
        } else {
          showMyDialog(context, map["message"].toString());
          return false;
        }
      } else {
        setState(() {
          isSaving = false;
        });
        if (streamedRest.statusCode == 400) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
        } else if (streamedRest.statusCode == 401) {
          showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
        } else if (streamedRest.statusCode == 500) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
        } else if (streamedRest.statusCode == 1001) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
        } else if (streamedRest.statusCode == 1005) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
        } else if (streamedRest.statusCode == 999) {
          showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
        } else {
          Map<dynamic, dynamic> map = json.decode(streamedRest.body);
          showMyDialog(context, map["romanMsg"].toString());
        }
      }
    }
  }

// In the State of a stateful widget:
  @override
  void initState() {
    super.initState();
    GetUserdata();
    _dropdownMenuItems = buildDropdownMenuItems(_users);
    _selectedUser = _dropdownMenuItems[0].value;
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
    Widget _myRadioButton({String title, int value, Function onChanged}) {
      return RadioListTile(
        value: value,
        groupValue: _groupValuenew,
        onChanged: onChanged,
        title: Text(title),
        activeColor: Appcolor.redHeader,
      );
    }

    Widget _myRadioButton1({String title, int value, Function onChanged}) {
      return RadioListTile(
        value: value,
        groupValue: _groupValuenew1,
        onChanged: onChanged,
        title: Text(title),
        activeColor: Appcolor.redHeader,
      );
    }

    Widget _myRadioButton3({String title, int value, Function onChanged}) {
      return RadioListTile(
        value: value,
        groupValue: _ISActive,
        onChanged: onChanged,
        title: Text(title),
        activeColor: Appcolor.redHeader,
      );
    }

    final uploadbtn = Material(
      color: Appcolor.redHeader,
      child: IconButton(
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          _selectimagefrom(context, "Selectați imaginea");
        },
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(
              forEdit == false ? "Adăugați informații" : "Editează informații"),
          centerTitle: true,
          elevation: 0,
        ),
        body: ModalProgressHUD(
          inAsyncCall: isSaving,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height+400,
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Titlu'),
                    controller: _title,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: ' ',
                      labelText: "Descriere",
                    ),
                    controller: _Description,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: ' ',
                      labelText: "Continut principal",
                    ),
                    controller: _Cprinciple,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Video link'),
                    controller: _VideoLink,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Pentru",
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                  _myRadioButton(
                    title: "Student",
                    value: 1,
                    onChanged: (newValue) => setState(
                          () => _groupValuenew = newValue,
                        ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Categorii",
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                  _myRadioButton1(
                    title: "Student",
                    value: 1,
                    onChanged: (newValue) =>
                        setState(() => _groupValuenew1 = newValue),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Vizibilitate",
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                  Container(
                    height: 50,
                    child: DropdownButton(
                        items: _dropdownMenuItems,
                        onChanged: onChangeDropdownItem,
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Appcolor.redHeader),
                        value: _selectedUser,
                        hint: Text(
                          'Selectați Vizibilitate',
                        )),
                  ),
                  SizedBox(height: 10),
                  _myRadioButton3(
                    title: "Inactiv",
                    value: 1,
                    onChanged: (newValue) =>
                        setState(() => _ISActive = newValue),
                  ),
                  Text(
                    "Galerie",
                    maxLines: 1,
                    style: TextStyle(color: Colors.grey, fontSize: 16.0),
                  ),
                  SizedBox(height: 10),
                  uploadbtn,
                  SizedBox(height: 20),
                  RaisedButton(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            //widthFactor: 4.5,
                            child: Text(
                                forEdit == false ? "Salveaza" : "Editați | ×"))
                      ],
                    ),
                    onPressed: () {
                      if (forEdit == true) {
                        showMyDialog(context, "In development");
                      } else {
                        addinformationaPI();
                      }
                    },
                    color: Appcolor.AppGreen,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class Visibilty {
  int id;
  String name;
  Visibilty(this.id, this.name);

  static List<Visibilty> getUsers() {
    return <Visibilty>[
      Visibilty(1, 'Public'),
      Visibilty(2, 'Doar pentru utilizatori'),
    ];
  }
}
