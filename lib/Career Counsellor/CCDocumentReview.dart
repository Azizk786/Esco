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

  Future<bool> AcceptCVPlanDocumentReviewRequest(String strcvid) async {
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

        getCareerPlanRequest().then((res) {
          setState(() {
            _cvCareerPlan = res;
            setState(() {
              _saving = false;
            });
          });
        });
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
          Map<dynamic, dynamic> map = json.decode(streamedRest.body);
          showMyDialog(context, map["romanMsg"].toString());
        }
      }

  }
  Future<bool> AcceptLOIDocumentReviewRequest(String strcvid) async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.AcceptLoiCorrectRquest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid,'later_id': strcvid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200)
    {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      getLetterofIntentRequest().then((res) {
        setState(() {
          _cvLatterofIntent = res;
          setState(() {
            _saving = false;
          });
        });
      });

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
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        showMyDialog(context, map["romanMsg"].toString());
      }
    }

  }
  Future<bool> AcceptCVDocumentReviewRequest(String strcvid) async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.AcceptCVCorrectRquest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid,'onlinecv_id': strcvid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200)
    {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      getCVRequest().then((res) {
        setState(() {
          _cvRequest = res;
          setState(() {
            _saving = false;
          });
        });
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

    final String url = API.Base_url + API.OnlineCVRequestList;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200)
    {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
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
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        return map["requestList"];
      }
    else  if (streamedRest.statusCode == 201) {

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
      return map["requestList"];
    }
    else  if (streamedRest.statusCode == 201) {
      //   showMyDialog(context, "Nicio inregistrare gasita");
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
    getCVRequest().then((res) {
      setState(() {
        _cvRequest = [];
        _cvRequest = res;

      });
    });

    getLetterofIntentRequest().then((res) {
      setState(() {
        _cvLatterofIntent = [];
        _cvLatterofIntent = res;

      });
    });
    getCareerPlanRequest().then((res) {
      setState(() {
        _cvCareerPlan = [];
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
    final myString = prefs.getString('CVPlanData') ?? '';
    Map sem_data  = json.decode(myString);

    prefs.setString("CP1",sem_data["informatii_personale"]);
    prefs.setString("CP2",sem_data["puncte_tari"]);
    prefs.setString("CP3",sem_data["puncte_slabe"]);
    prefs.setString("CP4",sem_data["oportunitati"]);
    prefs.setString("CP5",sem_data["amenintari"]);
    prefs.setString("CP6",sem_data["descriere"]);
    prefs.setString("CP7",sem_data["viziune_dezvoltare_personala"]);
    prefs.setString("CP8",sem_data["post_vizat"]);
    prefs.setString("CP9",sem_data["obiective_dezvoltare_personala"]);
    prefs.setString("CP10",sem_data["plan_actiune"]);
  }
  SaveLOIData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CVLOIData", json.encode(map));
    final myString = prefs.getString('CVLOIData') ?? '';
    Map sem_data = json.decode(myString);
    prefs.setString("LOI1",sem_data["informatii_personale"]);
    prefs.setString("LOI2",sem_data["destinatar"]);
    prefs.setString("LOI3",sem_data["subiect"]);
    prefs.setString("LOI4",sem_data["formula_salut"]);
    prefs.setString("LOI5",sem_data["continut"]);
    prefs.setString("LOI6",sem_data["formula_incheiere"]);
    prefs.setString("LOI7",sem_data["anexe"]);

  }
  SaveCVData(Map map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("CVData", json.encode(map));
    final myString = prefs.getString('CVData') ?? '';
    Map sem_data = json.decode(myString);
    prefs.setString("CV1",sem_data["informatii_personale"]);
    prefs.setString("CV2",sem_data["tip_aplicatie"]);
    prefs.setString("CV3",sem_data["experienta_profesionala"]);
    prefs.setString("CV4",sem_data["educatie_formare"]);
    prefs.setString("CV5",sem_data["limba_materna"]);
    prefs.setString("CV6",sem_data["limbi_straine"]);
    prefs.setString("CV7",sem_data["competente_comunicare"]);
    prefs.setString("CV8",sem_data["competente_manageriale"]);
    prefs.setString("CV9",sem_data["competente_loc_de_munca"]);
    prefs.setString("CV10",sem_data["competente_digitale"]);
    prefs.setString("CV11",sem_data["alte_competente"]);
    prefs.setString("CV12",sem_data["permis_conducere"]);
    prefs.setString("CV13",sem_data["informatii_suplimentare"]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Corectare Documente"),
        elevation: 0,
        centerTitle: true,
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
                                  Text(json.decode(_cvRequest[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""))["prenume"]
                                      +json.decode(_cvRequest[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""))["nume"],
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0 ,fontFamily: "Dami"),
                                  ),
                                  SizedBox(height:5),
                                  Text(_cvRequest[index]["create_date"].toString().split(" ")[0],
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
                                          child: Text( _cvRequest[index]["status"].toString() == "2"?
                                          "Accept":"Continuați corecția",style: TextStyle(fontFamily: "Demi"),)
                                      )
                                    ],
                                  ),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                  textColor: Colors.green,

                                  onPressed: () {

                                    if (_cvRequest[index]["status"].toString() == "1")
                                    {
                                      SaveCVData(_cvRequest[index]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CVCompletion_1(StrUserType: User)));
                                    }
                                    else
                                    {
                                      AcceptCVDocumentReviewRequest(_cvRequest[index]["id"].toString());
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

                        // HtmlTextView(data:_cvCareerPlan[index]["descriere"].toString() == "[]" ? json.decode(_cvCareerPlan[index]["descriere"].replaceAll(new RegExp(r"(\s\n)"), ""))["1566389223572"]["continut"]:"")
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
                                  Text(json.decode(_cvLatterofIntent[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""))["prenume"]
                                      +json.decode(_cvLatterofIntent[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""))["nume"],
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0 ,fontFamily: "Dami"),
                                  ),
                                  SizedBox(height:5),
                                  Text(_cvLatterofIntent[index]["create_date"].toString().split(" ")[0],
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
                                          child: Text( _cvLatterofIntent[index]["status"].toString() == "2"?
                                          "Accept":"Continuați corecția",style: TextStyle(fontFamily: "Demi"),)
                                      )
                                    ],
                                  ),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                                  textColor: Colors.green,

                                  onPressed: () {

                                    if (_cvLatterofIntent[index]["status"].toString() == "1")
                                    {
                                      SaveLOIData(_cvLatterofIntent[index]);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LetterofIntent_1(StrUserType: User)));
                                    }
                                    else
                                    {
                                      AcceptLOIDocumentReviewRequest( _cvLatterofIntent[index]["id"].toString());
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

                        // HtmlTextView(data:_cvCareerPlan[index]["descriere"].toString() == "[]" ? json.decode(_cvCareerPlan[index]["descriere"].replaceAll(new RegExp(r"(\s\n)"), ""))["1566389223572"]["continut"]:"")
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
                                  Text(json.decode(_cvCareerPlan[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""))["prenume"]
                                      +json.decode(_cvCareerPlan[index]["informatii_personale"].replaceAll(new RegExp(r"(\s\n)"), ""))["nume"],
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
                                            "Accept":"Continuați corecția",style: TextStyle(fontFamily: "Demi"),)
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
                                        AcceptCVPlanDocumentReviewRequest( _cvCareerPlan[index]["id"].toString());
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

                       // HtmlTextView(data:_cvCareerPlan[index]["descriere"].toString() == "[]" ? json.decode(_cvCareerPlan[index]["descriere"].replaceAll(new RegExp(r"(\s\n)"), ""))["1566389223572"]["continut"]:"")
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

