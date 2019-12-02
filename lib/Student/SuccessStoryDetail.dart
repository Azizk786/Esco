import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class SuccessStorydetail extends StatelessWidget {
  UserType StrUserType;
  Map map;
  SuccessStorydetail({Key key, @required this.StrUserType,  @required this.map}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SuccessStorydetailview(StrUserType: StrUserType, map: map);
  }
}

class SuccessStorydetailview extends StatefulWidget {
  UserType StrUserType;
  Map map;
  SuccessStorydetailview({Key key, @required this.StrUserType,  @required this.map}) : super(key: key);
  @override
  _SuccessStorydetailviewState createState() => _SuccessStorydetailviewState(StrUserType, map);
}

class _SuccessStorydetailviewState extends State<SuccessStorydetailview> {
  final UserType User;
  Map map;
  _SuccessStorydetailviewState(this.User,this.map);
  @override
  void initState() {
  super.initState();
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

    return Scaffold(
      appBar: AppBar(
        title: Text( map['titlu'].toString()),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Container(
          //    color: Colors.blue,
            width: double.infinity,
            height: 240,
            margin: EdgeInsets.only(top:56.0),
            alignment: AlignmentDirectional.center,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("Assets/Images/Success.png"),
                fit: BoxFit.fill,
              ),

            ),
          ),
              SizedBox(height: 25,),
           HtmlTextView(data: map['continut_principal'].toString()),
      ]
    ))
    );

  }
}
