import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/Mentor/MentorAddInformation.dart';
class StudentFacultyStudyCounsellor extends StatefulWidget {
  final UserType User;
  StudentFacultyStudyCounsellor({Key key, @required this.User}) : super(key: key);
  @override
  _StudentFacultyStudyCounsellorState createState() => _StudentFacultyStudyCounsellorState(User);
}

class _StudentFacultyStudyCounsellorState extends State<StudentFacultyStudyCounsellor> {
  final UserType User;
  bool _saving = true;
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List _informationList = new List();
  List _FilterinformationList = new List();
  String struserid;
  int counter = 0;
  //API Call (Get history list)----------------------
  Future<List> getinformation() async {

    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.GetFaculty;
    final client = new http.Client();
    //{'user_id' : struserid}
    final streamedRest = await client.post(url,
        body: null, headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if (streamedRest.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      int status = map["status"] as int;
      setState(() {
        _saving = false;
      });

      return map["facultyLists"];
    }else
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

  _StudentFacultyStudyCounsellorState(this. User) {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _FilterinformationList = _informationList;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  //Private method to get History list
  void fetchData() {
    getinformation().then((res) {
      setState(() {
        _informationList.addAll(res);
      });
    });


    setState(() {
      List tempList = new List();
      for (int i = 0; i < _informationList.length; i++) {
        tempList.add(_informationList[i]);
      }
      _informationList = tempList;
      _informationList.shuffle();
      _FilterinformationList = _informationList;
    });

  }
  Widget NodataWidget()
  {
    return Container(
      color: Colors.grey,
      alignment: Alignment.center,
      child: Text("Fără înregistrări",style: TextStyle(color: Appcolor.redHeader),),
    );
  }
  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    Map userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();
      fetchData();
    });
    print("Print userdata in Side menu");
    print(userdata);

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

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < _FilterinformationList.length; i++) {

        String fname = _FilterinformationList[i]["firstname"] == null?
        "":_FilterinformationList[i]["firstname"];

        String lname = _FilterinformationList[i]["lastname"] == null?
        "":_FilterinformationList[i]["lastname"];

        String uname = _FilterinformationList[i]["username"] == null?
        "":_FilterinformationList[i]["username"];

        if (fname.contains(
                _searchText.toLowerCase()) || lname.toLowerCase().contains(
            _searchText.toLowerCase()) || uname.toLowerCase().contains(
            _searchText.toLowerCase())) {
          tempList.add(_FilterinformationList[i]);
        }
      }
      _FilterinformationList = tempList;
    }
    return  Expanded(child: ListView.separated(
      padding: EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount:  _informationList == null ? 0 : _FilterinformationList.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.black38,),
      itemBuilder: (context, index) {
        return Column(
//crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _FilterinformationList[index]["firstname"]  +
                              " " +  _FilterinformationList[index]["lastname"],
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: "Demi"),
                        ),
                        SizedBox(height: 3),
                        Text(
                          _FilterinformationList[index]["email"] == null? "Nu e disponibil":_FilterinformationList[index]["email"],
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _FilterinformationList[index]["phone"] == null? "Nu e disponibil":_FilterinformationList[index]["phone"],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _FilterinformationList[index]["denumire"] == null? "Nu e disponibil":_FilterinformationList[index]["denumire"],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18.0,fontFamily: "Demi",
                          ),
                        )],
                    ),
                  ),
                ]),
          ],
        );
      },
    ));
  }

  //Life cycle ------------------View initiate here
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consilieri de studii"),
        centerTitle: true,
        actions: <Widget>[
          new Stack(
            children: <Widget>[
              new IconButton(icon: Icon(Icons.notifications), onPressed: () {
                setState(() {
                  counter = 0;
                });
              }),
              counter != 0 ? new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '$counter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ) : new Container()
            ],
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Column(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                height: 80.0,
                decoration: new BoxDecoration(
                    color: Appcolor.redHeader,
                    border:
                    new Border.all(color: Appcolor.redHeader, width: 4.0),
                    borderRadius: new BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                padding: EdgeInsets.all(15.0),
                child: Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      new BorderRadius.all(const Radius.circular(10.0))),
                  child: TextFormField(
                    decoration: InputDecoration(
                        hintText: "Cauta",
                        //  border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.white),
                    controller: _filter,
                  ),
                )),
            SizedBox(height: 10),
            _buildList(),
  SizedBox(height: 40,)
          ],
        ),

      ),
      drawer: Drawer(
        child: SideMenu(StrUserType: User),
      ),
    );
  }
}
