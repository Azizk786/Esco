import 'package:flutter/material.dart';
import 'package:escouniv/Profile.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'Constant/Constant.dart';
import 'package:escouniv/EVRORightMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:escouniv/Constant/Constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RightDrawer extends StatefulWidget {
  @override
  _RightDrawerState createState() => _RightDrawerState();
}

class _RightDrawerState extends State<RightDrawer> {

  bool _saving = true;
  List _informationList = new List();
  String struserid;

  @override
  void initState() {
    super.initState();
    GetUserdata();
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
        }
    );
  }

  Future<List> getNotification() async {

    setState(() {
      _saving = true;
    });
    final String url = API.Base_url + API.UserAddedInformation;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id' : struserid}, headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if (streamedRest.statusCode == 200) {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      int status = map["status"] as int;
      setState(() {
        _saving = false;
      });
      if (status == 200) {

      } else {
        showMyDialog(context, map["message"].toString());
      }

      return map["informationlist"];
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
        showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_DEFAULT);
      }

    }
  }
  GetUserdata() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    Map  userdata = json.decode(myString);
    struserid = userdata["userid"].toString();
    getNotification().then((res) {
      setState(() {
        _informationList.addAll(res);
      });
    });

    print(userdata);
  }
  Widget build(BuildContext context) {

    return Container(

        color: Colors.black.withOpacity(0.9),
        child: Column(
          children: <Widget>[
            Text("Ultimele mesaje"),
            ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.red,
              ),
              itemCount: _informationList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
//    print("click search");
//    Navigator.push(
//    context,
//    MaterialPageRoute(builder: (context) => Chatview()));
                  },
                  title: Text(
                    _informationList[index]['titlu'],
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0, fontFamily: 'Demi' ),
                  ),
                  leading: new Container(
                    color: Colors.red,
                    height:40 ,
                    width: 5,
                  ),
                );
              },
            ),
          ],
        )

    );
  }
}















