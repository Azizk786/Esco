import 'package:flutter/material.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/EVROChat.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/Career Plan/CareerPlan_1.dart';
import 'package:escouniv/CVCompletion/CVCompletion_1.dart';
import 'package:escouniv/LetterOFIntent/LetterOFIntent_1.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RedatareCV extends StatefulWidget {

  @override
  final UserType User;
   String cVType;
  RedatareCV({Key key, @required this.User, @required this.cVType}) : super(key: key);
  _RedatareCVState createState() => _RedatareCVState(User,cVType);

}

class _RedatareCVState extends State<RedatareCV> {
   UserType  StrUserType;
   String struserid;
   String strcvplanid;
   String cvStatus = "1";
   String _CVCorrectionText = "Ultimele corectii de CV";
   String _CVUpdateText = "Ultimele corectii de CV";
   String _CVDownloadText = "Ultimele corectii de CV";
   bool _saving = false;
    String cVType;
   _RedatareCVState( this.StrUserType, this.cVType);
   bool _isCVPlanPresent = false;
   bool _isLoiPresent = false;
   bool _isCVPresent = false;
   Map CVData;
   Map CVPlanData;
   Map CVLOIData;
   int Tabindex = 0;
int counter = 0;

   Future<bool> SendcvplanDocumentReviewRequest() async {
    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.SendCareerplanCorrectRquest;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid,'cv_id': strcvplanid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    if (streamedRest.statusCode == 200)
    {
      print(streamedRest.body);
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      String Status = map["status"].toString();

      fetchData();
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
   Future<bool> SendLOIDocumentReviewRequest() async {
     setState(() {
       _saving = true;
     });
     final String url = API.Base_url + API.SendLoiCorrectRquest;
     final client = new http.Client();
     final streamedRest = await client.post(url,
         body: {'user_id': struserid,'later_id': strcvplanid},
         headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
     if (streamedRest.statusCode == 200)
     {
       print(streamedRest.body);
       Map<dynamic, dynamic> map = json.decode(streamedRest.body);
       String Status = map["status"].toString();

       fetchData();
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
   Future<bool> SendCVDocumentReviewRequest() async {

     setState(() {
       _saving = true;
     });
     final String url = API.Base_url + API.SendCVCorrectRquest;
     final client = new http.Client();
     final streamedRest = await client.post(url,
         body: {'user_id': struserid,'onlinecv_id': strcvplanid},
         headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
     if (streamedRest.statusCode == 200)
     {
       print(streamedRest.body);
       Map<dynamic, dynamic> map = json.decode(streamedRest.body);
       String Status = map["status"].toString();

       fetchData();
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
   Future<bool> CancelCVDocumentReviewRequest() async {

     setState(() {
       _saving = true;
     });
     final String url = API.Base_url + API.CancelCVCorrectRquest;
     final client = new http.Client();
     final streamedRest = await client.post(url,
         body: {'user_id': struserid,'onlinecv_id': strcvplanid},
         headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
     if (streamedRest.statusCode == 200)
     {
       print(streamedRest.body);
       Map<dynamic, dynamic> map = json.decode(streamedRest.body);
       String Status = map["status"].toString();

       fetchData();
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
   Future<bool> CancelLOIDocumentReviewRequest() async {

     setState(() {
       _saving = true;
     });
     final String url = API.Base_url + API.CancelLOICorrectRquest;
     final client = new http.Client();
     final streamedRest = await client.post(url,
         body: {'user_id': struserid,'later_id': strcvplanid},
         headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
     if (streamedRest.statusCode == 200)
     {
       print(streamedRest.body);
       Map<dynamic, dynamic> map = json.decode(streamedRest.body);
       String Status = map["status"].toString();

       fetchData();
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
   Future<bool> CancelcvplanDocumentReviewRequest() async {

     setState(() {
       _saving = true;
     });
     final String url = API.Base_url + API.CancelCVPlanCorrectRquest;
     final client = new http.Client();
     final streamedRest = await client.post(url,
         body: {'user_id': struserid,'cv_id': strcvplanid},
         headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
     if (streamedRest.statusCode == 200)
     {
       print(streamedRest.body);
       Map<dynamic, dynamic> map = json.decode(streamedRest.body);
       String Status = map["status"].toString();

       fetchData();
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

  Future <List> GetCVPlan() async {
     setState(() {
       _saving = true;
     });
     final String url = API.Base_url + API.GetCVPlan;
     final client = new http.Client();
     Map<String,String> _finalPayload = {"user_id":struserid};
     final streamedRest = await client.post(url,
         body: _finalPayload,
         headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
     print(streamedRest.body);
     _isCVPlanPresent = false;
     strcvplanid = null;
     CVData = {};
     cvStatus = "1";
     if(streamedRest.statusCode == 200) {

       Map<dynamic, dynamic> map = json.decode(streamedRest.body);
       print("dashboard resposne");
       return map["getPlan"];

     }
     else if(streamedRest.statusCode == 201) {
       setState(() {
         _saving = false;
       });
       _isCVPlanPresent = false;
       Map<dynamic, dynamic> map = json.decode(streamedRest.body);

       showMyDialog(context, map["message"].toString());
     }
     else {
       _isCVPlanPresent = false;
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
   Future <List> GetCV() async {
     setState(() {
       _saving = true;
     });
     final String url = API.Base_url + API.GetCV;
     final client = new http.Client();
     Map<String,String> _finalPayload = {"user_id":struserid};
     final streamedRest = await client.post(url,
         body: _finalPayload,
         headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
     print(streamedRest.body);
     _isCVPresent = false;
     strcvplanid = null;
     CVData = {};
     cvStatus = "1";
     if(streamedRest.statusCode == 200) {

       Map<dynamic, dynamic> map = json.decode(streamedRest.body);

       print("dashboard resposne");
       return map["getOnlinecv"];

     }
     else if(streamedRest.statusCode == 201) {
       setState(() {
         _saving = false;
       });
       _isCVPresent = false;
       Map<dynamic, dynamic> map = json.decode(streamedRest.body);
       showMyDialog(context, map["message"].toString());
     }
     else {
       _isCVPresent = false;
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
   Future <List> GetLOI() async {
     setState(() {
       _saving = true;
     });
     final String url = API.Base_url + API.GetLOI;
     final client = new http.Client();
     Map<String,String> _finalPayload = {"user_id":struserid};
     final streamedRest = await client.post(url,
         body: _finalPayload,
         headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
     print(streamedRest.body);
     _isLoiPresent = false;
     strcvplanid = null;
     CVData = {};
     cvStatus = "1";
     if(streamedRest.statusCode == 200) {

       Map<dynamic, dynamic> map = json.decode(streamedRest.body);

       print("dashboard resposne");
       return map["getLetterOfIntent"];

     }
     else if(streamedRest.statusCode == 201) {
       setState(() {
         _saving = false;
       });
       _isLoiPresent = false;
       Map<dynamic, dynamic> map = json.decode(streamedRest.body);
       showMyDialog(context, map["message"].toString());
     }
     else {
       _isLoiPresent = false;
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
   GetUserdata() async
   {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final myString = prefs.getString('Userdata') ?? '';
     Map userdata = json.decode(myString);
     setState(() {
       struserid = userdata["userid"].toString();
       fetchData();
     });

   }

   void fetchData() {

    if(cVType == "1")
      {
        _CVCorrectionText = "Ultimele corectii de CV";
        _CVUpdateText = "Actualizare CV";
        _CVDownloadText = "Descarca CV";

        GetCV().then((res) {

          if(res != null)
            {
              setState(() {
                _isCVPresent = true;
                strcvplanid = res[0]["id"];
                CVData = res[0];
                setState(() {
                  _saving = false;
                });
                cvStatus = CVData["status"].toString();
                SaveCVData(res[0]);


              });
            }
          else
          {
            _isCVPresent = false;
          }
        });
      }
    else if(cVType == "2")
      {
        _CVCorrectionText = "Ultimele corectii ale Scrisorii de intentie";
        _CVUpdateText = "Actualizare Scrisoare de intentie";
        _CVDownloadText = "Descarca Scrisoare de intentie";


          GetLOI().then((res) {
            if(res != null) {
            setState(() {
              _isLoiPresent = true;
              setState(() {
                _saving = false;
              });
              strcvplanid = res[0]["id"];
              CVLOIData = res[0];
              cvStatus = CVLOIData["status"].toString();
              SaveLOIData(res[0]);
            });
            }
            else
              {
                _isLoiPresent = false;
              }
          });

      }
    else
      {

        _CVCorrectionText = "Ultimele corectii ale Planului de Cariera";
        _CVUpdateText = "Actualizare Plan Cariera";
        _CVDownloadText = "Descarca Plan Cariera";


        GetCVPlan().then((res) {
print("reposne here = $res");
          if(res != null)
            {
              setState(() {
                _isCVPlanPresent = true;
                setState(() {
                  _saving = false;
                });
                strcvplanid = res[0]["id"];
                CVPlanData = res[0];
                cvStatus = CVPlanData["status"].toString();
                SaveCVPlanData(res[0]);

              });
            } else
          {
            _isCVPlanPresent = false;
          }
        });
      }

   }

   SaveCVPlanData(Map map) async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString("CVPlanData", json.encode(map));
     final myString = prefs.getString('CVPlanData') ?? '';

     Map sem_data  = json.decode(myString);
     print("Chanegd to 2 == $sem_data");
     print("received data for student = $sem_data");
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
     prefs.setString("LOI1",map["informatii_personale"]);
     prefs.setString("LOI2",map["destinatar"]);
     prefs.setString("LOI3",map["subiect"]);
     prefs.setString("LOI4",map["formula_salut"]);
     prefs.setString("LOI5",map["continut"]);
     prefs.setString("LOI6",map["formula_incheiere"]);
     prefs.setString("LOI7",map["anexe"]);

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
     if(cVType == "1")
     {
       Tabindex = 0;
     }
    else if(cVType == "2")
     {
       Tabindex = 1;
     }
    else
     {
       Tabindex = 2;
     }
     GetUserdata();
   }
  Widget build(BuildContext context) {

    Widget _whenRequestedforCorrection()
    {
      if (cvStatus == "2")
        {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_CVCorrectionText,style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,fontFamily: 'Demi' )),
                SizedBox(height: 10,),
//                Text("02/21/2018 19:43:57 - 03/03/2018 10:49:21 D-na Consilier Cariera",style: TextStyle(
//                    color: Colors.grey,
//                    fontSize: 18.0,fontFamily: 'Regular' )),
                Container(child: Text("CV-ul dvs. a fost preluat pentru corectare. În maxim 24 de ore sau imediat după corecție, veți putea modifica din nou conținutul CV-ului.",style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,fontFamily: 'Regular' ),),color: Colors.white70,height: 60),
                SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OutlineButton(
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Anulați solicitarea de corectare",
                              )
                          )
                        ],
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                      textColor: Colors.red,
                      onPressed: () {
                        if (cVType == "1")
                        {
                         CancelCVDocumentReviewRequest();
                        }
                        else if(cVType == "2")
                        {
                          CancelLOIDocumentReviewRequest();
                        }
                        else
                        {
                         CancelcvplanDocumentReviewRequest();
                        }
                      }, //callback when button is clicked
                      borderSide: BorderSide(
                        color: Colors.red, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 1, //width of the border
                      ),
                    ),
                    OutlineButton(
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                _CVDownloadText,
                              )
                          )
                        ],
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                      textColor: Colors.green,
                      onPressed: () {
                        showMyDialog(context, "Under developement");

                      }, //callback when button is clicked
                      borderSide: BorderSide(
                        color: Colors.green, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 1, //width of the border
                      ),
                    ),
                  ],
                ),

              ],
            ),
          );
        }
      else
        {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_CVCorrectionText,style: TextStyle(
                    color: Colors.black,
                    fontSize: 22.0,fontFamily: 'Demi' )),
                SizedBox(height: 10,),
//                Text("02/21/2018 19:43:57 - 03/03/2018 10:49:21 D-na Consilier Cariera",style: TextStyle(
//                    color: Colors.grey,
//                    fontSize: 18.0,fontFamily: 'Regular' )),
                Container(child: Text("The career plan will be taken over for correction as soon as possible.",style: TextStyle(
                    color: Colors.red,
                    fontSize: 15.0,fontFamily: 'Regular' ),),color: Colors.orangeAccent,height: 60),
                SizedBox(height: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    OutlineButton(
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Consilier acceptat",
                              )
                          )
                        ],
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                      textColor: Colors.red,
                      onPressed: () {
                        if (cVType == "1")
                        {
                          SaveCVData(CVData);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CVCompletion_1(StrUserType:StrUserType)));
                        }
                        else if(cVType == "2")
                        {
                          SaveLOIData(CVLOIData);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LetterofIntent_1(StrUserType:StrUserType)));
                        }
                        else
                        {
                          SaveCVPlanData(CVPlanData);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CareerPlan_1(StrUserType:StrUserType)));
                        }
                      }, //callback when button is clicked
                      borderSide: BorderSide(
                        color: Colors.red, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 1, //width of the border
                      ),
                    ),
                    OutlineButton(
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.center,
                              child: Text(
                                _CVDownloadText,
                              )
                          )
                        ],
                      ),
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                      textColor: Colors.green,
                      onPressed: () {
                        showMyDialog(context, "Under developement");

                      }, //callback when button is clicked
                      borderSide: BorderSide(
                        color: Colors.green, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 1, //width of the border
                      ),
                    ),
                  ],
                ),

              ],
            ),
          );

        }
    }
    Widget _Defaultview()
    {
      return SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_CVCorrectionText,style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,fontFamily: 'Demi' )),
            SizedBox(height: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                OutlineButton(
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                           _CVUpdateText,
                          )
                      )
                    ],
                  ),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                  textColor: Colors.green,
                  onPressed: () {

                    if (cVType == "1")
                      {
                        SaveCVData(CVData);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CVCompletion_1(StrUserType:StrUserType)));
                      }
                    else if(cVType == "2")
                      {
                        SaveLOIData(CVLOIData);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LetterofIntent_1(StrUserType:StrUserType)));
                      }
                    else
                      {
                        SaveCVPlanData(CVPlanData);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CareerPlan_1(StrUserType:StrUserType)));
                      }

                  }, //callback when button is clicked
                  borderSide: BorderSide(
                    color: Colors.green, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 1, //width of the border
                  ),
                ),
                OutlineButton(
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Trimiteti la corectat",
                          )
                      )
                    ],
                  ),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                  textColor: Colors.green,
                  onPressed: () {

                    if(cVType == "1")
                      {

                        if (_isCVPresent == true)
                        {
                          SendCVDocumentReviewRequest();
                        }
                        else{
                          showMyDialog(context, "Nu este prezent un plan de carieră");
                        }
                      }
                    else if(cVType == "2")
                      {
                        if (_isLoiPresent == true)
                      {
                        SendLOIDocumentReviewRequest();
                      }
                      else{
                        showMyDialog(context, "Nu este prezent un plan de carieră");
                      }


                      }
                    else
                      {
                        if (_isCVPlanPresent == true)
                        {
                          SendcvplanDocumentReviewRequest();
                        }
                        else{
                          showMyDialog(context, "Nu este prezent un plan de carieră");
                        }
                      }
                  }, //callback when button is clicked
                  borderSide: BorderSide(
                    color: Colors.green, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 1, //width of the border
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            RaisedButton(
              child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.center,

                      child: Text(
                          _CVDownloadText, style: TextStyle(fontFamily: 'regular')
                      )
                  )
                ],
              ),
              onPressed: (){
                showMyDialog(context, "Under developement");

              },
              color: Appcolor.AppGreen,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
              ),
            ),

          ],
        ),
      );
    }
    Widget _whenAccepted()
    {
      return SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_CVCorrectionText,style: TextStyle(
                color: Colors.black,
                fontSize: 22.0,fontFamily: 'Demi' )),
            SizedBox(height: 10,),
//            Text("02/21/2018 19:43:57 - 03/03/2018 10:49:21 D-na Consilier Cariera",style: TextStyle(
//                color: Colors.grey,
//                fontSize: 18.0,fontFamily: 'Regular' )),
            SizedBox(height: 10,),

          ],
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: Text("Redactare CV",style: TextStyle(fontFamily: 'Demi'),textAlign: TextAlign.center,),
        elevation: 0,
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
      drawer: Drawer(
        child: SideMenu(StrUserType: StrUserType),
      ),
      body: ModalProgressHUD(inAsyncCall: _saving, child: DefaultTabController(
        length: 3,
        initialIndex: Tabindex,
        child: Column(
          children: <Widget>[
            Container(
              //   constraints: BoxConstraints.expand(height: 55),
              child: TabBar(
                  onTap: (int inx){
                    print("selected index $inx");
                    if(inx == 0)
                    {
                      cVType = "1";
                      fetchData();
                    }
                    else if (inx == 1)
                    {
                      cVType = "2";
                      fetchData();
                    }
                    else
                    {
                      cVType = "3";
                      fetchData();
                    }
                  },
                  tabs: [
                    Tab(child: Text("CV",style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,fontFamily: 'Demi' ))),
                    Tab(child:Text("Scrisoare de intentie",style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,fontFamily: 'Demi' ))),
                    Tab(child: Text("Plan Cariera",style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,fontFamily: 'Demi' ))),
                  ]),
            ),
            cvStatus == "1"  || cvStatus == "4" ? _Defaultview() : _whenRequestedforCorrection()
          ],
        ),
      ),)
    );
  }
}

