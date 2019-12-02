
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class TutorialDetails extends StatelessWidget {
  UserType StrUserType;
  Map map;
  TutorialDetails({Key key, @required this.StrUserType,  @required this.map}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TutorialDetailsView(User: StrUserType, map: map);
  }
}

class TutorialDetailsView extends StatefulWidget {
  @override
  final UserType User;
  Map map;
  TutorialDetailsView({Key key, @required this.User,  @required this.map}) : super(key: key);
  TutorialDetailsViewState createState() => TutorialDetailsViewState(User, map);
}

class TutorialDetailsViewState extends State<TutorialDetailsView> {
  final UserType User;
  Map map;
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
  TutorialDetailsViewState(this.User,this.map);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(map["titlu"].toString()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(map["titlu"].toString(),style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'Demi')),
            SizedBox(height: 15,),
            HtmlTextView(data: map['continut_principal'].toString()),
            SizedBox(height: 25,),
          ],
        ),
      ),

    );
  }
}
