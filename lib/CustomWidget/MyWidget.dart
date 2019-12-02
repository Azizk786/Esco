import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:escouniv/Career Plan/CareerPlan_1.dart';
import 'package:escouniv/CVCompletion/CVCompletion_1.dart';
import 'package:escouniv/LetterOFIntent/LetterOFIntent_1.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class CCDocumentReview extends StatefulWidget {
  @override
  final UserType User;
  CCDocumentReview({Key key, @required this.User}) : super(key: key);
  _CCDocumentReviewState createState() => _CCDocumentReviewState(User);
}

class _CCDocumentReviewState extends State<CCDocumentReview> {
  UserType User;
  String struserid;
  bool _saving = false;
  List _cvRequest = new List();
  List _cvCareerPlan = new List();
  List _cvLatterofIntent = new List();
  _CCDocumentReviewState(this. User);

  Future<bool> AcceptDocumentReviewRequest(String strcvid) async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.AcceptCV;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid,'cv_id': strcvid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200)
    {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();
      setState(() {
        _saving = false;
      });
      if (Status == "200") {
        showMyDialog(context, map["message"].toString());

      }
      return true;
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
  Future<List> getCVRequest() async {

    final String url = API.Base_url + API.LetterOfIntentList;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200)
    {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      if (Status != "200") {
        showMyDialog(context, map["message"].toString());
      }
      return map["requestList"];
    }
    else  if (streamedRest.statusCode == 201) {
      //   showMyDialog(context, "Nicio inregistrare gasita");
    }
    else
    {
//      setState(() {
//        _saving = false;
//      });
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
  Future<List> getLetterofIntentRequest() async {

    final String url = API.Base_url + API.LetterOfIntentList;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if(streamedRest.statusCode == 200)
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body).replaceAll(new RegExp(r"(\s\n)"), "");
      String Status = map["status"].toString();

      if (Status != "200") {
        showMyDialog(context, map["message"].toString());
      }
      return map["requestList"];
    }
    else  if (streamedRest.statusCode == 201) {
      showMyDialog(context, "Nicio inregistrare gasita");
    }
    else
    {

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
  Future<List> getCareerPlanRequest() async {

    final String url = API.Base_url + API.PlancvRequestList;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if (streamedRest.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      //json.decode(_cvRequest[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""))
      String Status = map["status"].toString();

      if (Status == "200") {} else {
        showMyDialog(context, map["message"].toString());
      }
      return map["requestList"];
    }
    else  if (streamedRest.statusCode == 201) {
      showMyDialog(context, "Nicio inregistrare gasita");
    }
    else
    {

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

  //Private method to get Mentor list

  void fetchData() {
//    getCVRequest().then((res) {
//      setState(() {
//        _cvRequest = res["requestList"];
//        //_cvRequest = res["acceptedList"];
//      });
//    });

    getLetterofIntentRequest().then((res) {
      setState(() {
        _cvLatterofIntent = res;

      });
    });
    getCareerPlanRequest().then((res) {
      setState(() {
        _cvCareerPlan = res;
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
  Widget NodataWidget()
  {
    return Container(
      height: 40,

      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
      color: Colors.grey,
      alignment: Alignment.center,
      child: Text("Fără înregistrări",style: TextStyle(color: Appcolor.redHeader),),
    );
  }
  //Life cycle ------------------View initiate here
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    GetUserdata();
//    setState(() {
//      showMyDialog(context, "Under Development");
//    });

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

  SaveCVPlanData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CVPlanData", json.encode(map));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Corectare Documente"),
        elevation: 0,
      ),

      body: ModalProgressHUD(inAsyncCall: _saving, child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:10),
            Text(
              "CV",
              textAlign: TextAlign.left,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0 ),
            ),
            SizedBox(height:10),
            Flexible(
              child: _cvRequest== null || _cvRequest.length == 0 ? NodataWidget(): ListView.separated(
                shrinkWrap: true,
                itemCount: _cvRequest.length,
                separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black38,),
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  //json.decode(_cvRequest[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""))

                                  Text(json.decode(_cvRequest[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), "")["prenume"])
                                      +json.decode(_cvRequest[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), "")["nume"]),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.0 ),
                                  ),
                                  SizedBox(height:5),
                                  Text(_cvRequest[index]["create_date"],
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontSize: 16.0 ),
                                  ),
                                  SizedBox(height:5),
                                ],
                              ),
                              Container(
                                child:OutlineButton(
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text( _cvRequest[index]["status"].toString() == "2"?
                                          "Accept":"Continuați corecția",
                                          )
                                      )
                                    ],
                                  ),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                  textColor: Colors.green,
                                  onPressed: () {

                                    if (_cvRequest[index]["status"].toString() == "1")
                                    {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CVCompletion_1(StrUserType: User)));
                                    }
                                    else
                                    {
                                      AcceptDocumentReviewRequest( _cvRequest[index]["id"].toString());
                                    }

//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) => AddAvailability()));
                                  }, //callback when button is clicked
                                  borderSide: BorderSide(
                                    color: Colors.green, //Color of the border
                                    style: BorderStyle.solid, //Style of the border
                                    width: 1, //width of the border
                                  ),
                                ),
                              )
                            ]
                        ),
                        HtmlTextView(data: json.decode(_cvCareerPlan[index]["descriere"].replaceAll(new RegExp(r"(\s\n)"), "")["1550836423912"]["continut"],))
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height:10),

            Text(
              "Scrisoare Intentie",
              textAlign: TextAlign.left,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0 ),
            ),
            SizedBox(height:10),
            Flexible(
              child: _cvLatterofIntent== null || _cvLatterofIntent.length == 0 ? NodataWidget(): ListView.separated(
                shrinkWrap: true,
                itemCount: _cvLatterofIntent.length,
                separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black38,),
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //json.decode(_cvLatterofIntent[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), "")["prenume"])
                                  Text(json.decode(_cvLatterofIntent[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), "")["prenume"])+
                                      json.decode(_cvLatterofIntent[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), "")["nume"]),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.0 ),
                                  ),
                                  SizedBox(height:5),
                                  Text(_cvLatterofIntent[index]["create_date"],
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 16.0 ),
                                  ),
                                  SizedBox(height:5),
                                ],
                              ),
                              Container(
                                child:OutlineButton(
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text( _cvLatterofIntent[index]["status"].toString() == "2"?
                                          "Accept":"Continuați corecția",
                                          )
                                      )
                                    ],
                                  ),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                  textColor: Colors.green,
                                  onPressed: () {

                                    if (_cvLatterofIntent[index]["status"].toString() == "1")
                                    {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LetterofIntent_1(StrUserType: User)));
                                    }
                                    else
                                    {
                                      AcceptDocumentReviewRequest( _cvLatterofIntent[index]["id"].toString());
                                    }

//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) => AddAvailability()));
                                  }, //callback when button is clicked
                                  borderSide: BorderSide(
                                    color: Colors.green, //Color of the border
                                    style: BorderStyle.solid, //Style of the border
                                    width: 1, //width of the border
                                  ),
                                ),
                              )
                            ]
                        ),

                        HtmlTextView(data: json.decode(_cvLatterofIntent[index]["descriere"]["1550836423912"].replaceAll(new RegExp(r"(\s\n)"), "")["continut"]))
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height:10),

            Text(
              "Plan de dezvoltare a carierei",
              textAlign: TextAlign.left,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0 ),
            ),
            SizedBox(height:10),
            Flexible(
              child: _cvCareerPlan== null || _cvCareerPlan.length == 0 ? NodataWidget(): ListView.separated(
                shrinkWrap: true,
                itemCount: _cvCareerPlan.length,
                separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black38,),
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(json.decode(_cvCareerPlan[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), "")["prenume"])+
                                      json.decode(_cvCareerPlan[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), "")["nume"]),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0 ,fontFamily: "Dami"),
                                  ),
                                  SizedBox(height:5),
                                  Text(_cvCareerPlan[index]["create_date"].toString().split(" ")[0],
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16.0,fontFamily: "regular" ),
                                  ),
                                  SizedBox(height:5),
                                ],
                              ),
                              Container(
                                child:OutlineButton(
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text( _cvCareerPlan[index]["status"].toString() == "2"?
                                          "Accept":"Continuați corecția",style: TextStyle(fontFamily: "regular",decorationStyle: TextDecorationStyle.wavy),)
                                      )
                                    ],
                                  ),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                  textColor: Colors.green,
                                  onPressed: () {

                                    if (_cvCareerPlan[index]["status"].toString() == "1")
                                    {
                                      SaveCVPlanData(_cvCareerPlan[index]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CareerPlan_1(StrUserType: User)));
                                    }
                                    else
                                    {
                                      AcceptDocumentReviewRequest( _cvCareerPlan[index]["id"].toString());
                                    }

//                              Navigator.push(
//                                  context,
//                                  MaterialPageRoute(builder: (context) => AddAvailability()));
                                  }, //callback when button is clicked
                                  borderSide: BorderSide(
                                    color: Colors.green, //Color of the border
                                    style: BorderStyle.solid, //Style of the border
                                    width: 1, //width of the border
                                  ),
                                ),
                              )
                            ]
                        ),
                        HtmlTextView(data:json.decode(_cvCareerPlan[index]["descriere"]["1550836423912"].replaceAll(new RegExp(r"(\s\n)"), "")["continut"]))
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height:10),
          ],
        ),
      )),
      drawer: Drawer(
        child: SideMenu(StrUserType: User),
      ),
    );
  }
}

