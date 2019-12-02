import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:escouniv/EVROMenu.dart';
//import 'SuccessStoriesDetails.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:escouniv/Student/MentorDetail.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class Mentorlist extends StatefulWidget {
  @override
  final UserType StrUserType;
  Mentorlist({Key key, @required this.StrUserType}) : super(key: key);
  _MentorlistState createState() => _MentorlistState(StrUserType);
}

class _MentorlistState extends State<Mentorlist> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
int counter = 0;
  List _FilterMentors = new List();
  UserType User;
  String struserid;
  bool _saving = true;
  List _Mentors = new List();
//  _MentorlistState(this. User);
  @override
  //API Call (Get history list)----------------------
  Future<List> getMentor() async {
    final String url = API.Base_url + API.GetMentorList;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    Map<dynamic, dynamic> map = json.decode(streamedRest.body);
    String Status = map["status"].toString();
    setState(() {
      _saving = false;
    });
    return map["mentorList"];
  }

  //Private method to get Mentor list

  _MentorlistState(this. User) {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _FilterMentors = _Mentors;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void fetchData() {
    getMentor().then((res) {
      setState(() {
        _Mentors.addAll(res);

      });
    });

    setState(() {
      List tempList = new List();
      for (int i = 0; i < _Mentors.length; i++) {
        tempList.add(_Mentors[i]);
      }
      _Mentors = tempList;
      _Mentors.shuffle();
      _FilterMentors = _Mentors;
    });
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

  //Life cycle ------------------View initiate here
  void initState() {
    _filter.addListener(_searchPressed);
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


  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < _FilterMentors.length; i++) {
        if (_FilterMentors[i]['username'].toLowerCase().contains(
            _searchText.toLowerCase()) ||
            _FilterMentors[i]['loc_de_munca'].toLowerCase().contains(
                _searchText.toLowerCase())) {
          tempList.add(_FilterMentors[i]);
        }
      }
      _FilterMentors = tempList;
    }
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _Mentors == null ? 0 : _FilterMentors.length,
      padding: EdgeInsets.all(10),
      separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black38,),
      itemBuilder: (context, index) {
        return Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[//
              ListTile(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => mentorDetails(StrUserType: User, map: _FilterMentors[index])));
                },
                title: Text( _FilterMentors[index]['username'].toString()+' - '+
                    _FilterMentors[index]['loc_de_munca'].toString(),
                  style: TextStyle(fontSize: 20,color: Colors.black87,fontFamily: 'Demi'),),
                subtitle: Text( _FilterMentors[index]['functie_loc_de_munca'].toString() + " - " +  _FilterMentors[index]['domeniu_specializare'].toString(),
                  style: TextStyle(fontSize: 20,color: Colors.grey,fontFamily: 'regular'),),
              ),
            ],
          ),
        );

      },
    );
  }

  void _searchPressed() {

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Center(child: new Text('Mentorat', textAlign: TextAlign.center)),
        elevation: 1,
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
      body: ModalProgressHUD(inAsyncCall: _saving, child: Container(
        child: Column(
          children: <Widget>[

            Container(
                alignment: Alignment.center,
                height: 80.0,
                decoration: new BoxDecoration(
                    color: Appcolor.redHeader,
                    border: new Border.all(
                        color: Appcolor.redHeader,
                        width: 4.0
                    ),
                    borderRadius: new BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                ),
                padding: EdgeInsets.all(15.0),
                child: Container(

                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(const Radius.circular(10.0))),
                  child:
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Cauta",
                        //  border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.white

                    ),
                    controller: _filter,
                  ),
                )
            ),
            SizedBox(height:10),
            Expanded(

              child: _buildList(),
            ),
          ],
        ),
      ),),
      drawer: Drawer(
        child: SideMenu(StrUserType: User),
      ),
    );
  }
}

