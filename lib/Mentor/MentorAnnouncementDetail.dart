import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class MentorAnnouncemntDetail extends StatefulWidget {
  @override
  UserType StrUserType;
  Map map;
  MentorAnnouncemntDetail({Key key, @required this.StrUserType,  @required this.map}) : super(key: key);
  _MentorAnnouncemntDetailState createState() => _MentorAnnouncemntDetailState(StrUserType,map);
}

class _MentorAnnouncemntDetailState extends State<MentorAnnouncemntDetail> {
  final UserType User;
  Map map;
  _MentorAnnouncemntDetailState(this.User,this.map);
  final btnDownloadFile = Material(

      color: Colors.transparent,
      child:OutlineButton(
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Descarca oferta",
                )
            )
          ],
        ),
        //   padding: EdgeInsets.only(left: 30,right: 30,top: 30),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
        textColor: Appcolor.AppGreen,
        onPressed: () {

        }, //callback when button is clicked
        borderSide: BorderSide(
          color: Appcolor.AppGreen, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 1, //width of the border
        ),
      )
  );
  final btnEdit = Material(
      color: Colors.transparent,
      child:OutlineButton(
        child: Stack(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Text(
                  "Editeaza",
                )
            )
          ],
        ),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
        textColor: Appcolor.AppGreen,
        onPressed: () {

        }, //callback when button is clicked
        borderSide: BorderSide(
          color: Appcolor.AppGreen, //Color of the border
          style: BorderStyle.solid, //Style of the border
          width: 1, //width of the border
        ),
      )
  );

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("detalii anunt"),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.notifications),
            onTap: () {
              print("click search");
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body:SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(map["titlu"],style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: "demi"), textAlign: TextAlign.left,textDirection: TextDirection.ltr,),
            SizedBox(height: 15),
            Text("Tip",style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: "demi")),
            SizedBox(height: 10,),
            Text(map["tip_anunt"],style: TextStyle(color: Colors.grey,fontSize: 18,fontFamily: "regular")),
            SizedBox(height: 15,),
            Text("Status",style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: "demi")),
            SizedBox(height: 10,),
            Text("Activ",style: TextStyle(color: Colors.grey,fontSize: 18,fontFamily: "regular")),
            SizedBox(height: 15,),
            Text("Descriere",style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: "demi")),
            SizedBox(height: 10,),
            Text(map["descriere"],style: TextStyle(color: Colors.grey,fontSize: 18,fontFamily: "regular")),
            SizedBox(height: 180,),
            Container(
              child:OutlineButton(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                            "Descarca oferta",style: TextStyle(
                            color: Colors.green,
                            fontSize: 20.0,
                            fontFamily: 'Demi')
                        )
                    )
                  ],
                ),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                textColor: Colors.green,
                onPressed: () {

                }, //callback when button is clicked
                borderSide: BorderSide(
                  color: Colors.green, //Color of the border
                  style: BorderStyle.solid, //Style of the border
                  width: 1, //width of the border
                ),
              ),
            )
         //   btnEdit

//        Expanded(
//            btnEdit
//        );
          ],
        ),
      ),
      ),
    );

  }
}
