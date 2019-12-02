import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/Career Counsellor/New Availability.dart';
import 'package:escouniv/EVROMenu.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class CCAvailability extends StatefulWidget {
  final UserType User;
  CCAvailability({Key key, @required this.User}) : super(key: key);

  @override
  _CCAvailabilityState createState() => _CCAvailabilityState(User);
}

class _CCAvailabilityState extends State<CCAvailability> {
  UserType User;
  String struserid;
  bool _saving = false;
  List _availabilty = new List();
  _CCAvailabilityState(this. User);

  Future<List> getAvailability() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.AvailabilityList;
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
        return map["listProgram"];
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
          Map<dynamic, dynamic> map = json.decode(streamedRest.body);
          showMyDialog(context, map["romanMsg"].toString());
        }
      }

  }
  void fetchData() {
    getAvailability().then((res) {
      setState(() {
        _availabilty.addAll(res);
      });
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
        title: Text("Disponibilitati"),
        elevation: 0,
        centerTitle: true,
      ),

      body: ModalProgressHUD(inAsyncCall: _saving, child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(height:10),

            Expanded(

              child: ListView.separated(
             //   shrinkWrap: true,
                itemCount: _availabilty.length,
                separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black38,),
                itemBuilder: (context, index) {

                  return  new GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddAvailability(User: User,forEdit: _availabilty[index],)));
                      },
                      child: new Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          "Data: "+_availabilty[index]["data"].toString().split(" ")[0],
                          textAlign: TextAlign.left,
                          maxLines: 1,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0 ),
                        ),
                        SizedBox(height: 15,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Ora inceput : "+_availabilty[index]["oraInceput"].toString().split(" ")[1].toString().split(":")[0]+":"+_availabilty[index]["oraInceput"].toString().split(" ")[1].toString().split(":")[1],
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16.0 ),
                              ),
                              SizedBox(width: 15,),
                              Text(
                                "Ora sfarsit : "+_availabilty[index]["oraSfarsit"].toString().split(" ")[1].toString().split(":")[0]+":"+_availabilty[index]["oraInceput"].toString().split(" ")[1].toString().split(":")[1],
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16.0 ),
                              ),
                            ]
                        ),
                        SizedBox(height: 15,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Ore ocupate: " + _availabilty[index]["ore_ocupate"].toString(),
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0 ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                "Recurent: "+ _availabilty[index]["recurent"].toString()=="1"?"true":"false",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16.0 ),
                              ),
                            ]
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ));

                },
              ),
            ),
            Container(
              child:OutlineButton(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        widthFactor: 4,
                        child: Text(
                          "Adauga",
                        )
                    )
                  ],
                ),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                textColor: Colors.green,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddAvailability(User: User,forEdit: null,)));
                }, //callback when button is clicked
                borderSide: BorderSide(
                  color: Colors.green, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 1, //width of the border
                ),
              ),
            )
          ],
        ),
      )),
      drawer: Drawer(
        child: SideMenu(StrUserType: User),
      ),
    );
  }
}

