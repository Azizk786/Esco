
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

class dashboardEventDetails extends StatefulWidget {
  @override
  final UserType User;
  Map map;
  dashboardEventDetails({Key key, @required this.User,  @required this.map}) : super(key: key);
  dashboardEventDetailsState createState() => dashboardEventDetailsState(User, map);
}

class dashboardEventDetailsState extends State<dashboardEventDetails> {
  final UserType User;
  Map map;
  dashboardEventDetailsState(this.User,this.map);
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
             Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Image.asset(
                        "Assets/Images/calender_black.png"),
                    SizedBox(width: 10.0),
                    new Text(map["data_inceput"].toString(), style:
                    TextStyle(fontFamily: 'regular')),
                  ],
                )
            ),
            SizedBox(height: 5,),
             Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Image.asset(
                        "Assets/Images/Watch_black.png"),
                    SizedBox(width: 10.0),
                    new Text(map["ora_inceput"].toString(), style:
                    TextStyle(fontFamily: 'regular')),

                  ],
                )
            ),
            SizedBox(height: 25,),
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
