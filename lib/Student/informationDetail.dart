
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class informationDetails extends StatelessWidget {
  UserType StrUserType;
  Map map;
  informationDetails({Key key, @required this.StrUserType,  @required this.map}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return informationDetailsView(User: StrUserType, map: map);
  }
}

class informationDetailsView extends StatefulWidget {
  @override
  final UserType User;
  Map map;
  informationDetailsView({Key key, @required this.User,  @required this.map}) : super(key: key);
  informationDetailsViewState createState() => informationDetailsViewState(User, map);
}

class informationDetailsViewState extends State<informationDetailsView> {
  final UserType User;
  Map map;
  informationDetailsViewState(this.User,this.map);
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
            Text(map["descriere"].toString(),style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'regular')),
            SizedBox(height: 25,),
          ],
        ),
      ),
    );
  }
}
