
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class mentorDetails extends StatelessWidget {
  UserType StrUserType;
  Map map;
  mentorDetails({Key key, @required this.StrUserType,  @required this.map}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return mentorDetailsView(User: StrUserType, map: map);
  }
}

class mentorDetailsView extends StatefulWidget {
  @override
  final UserType User;
  Map map;
  mentorDetailsView({Key key, @required this.User,  @required this.map}) : super(key: key);
  mentorDetailsViewState createState() => mentorDetailsViewState(User, map);
}

class mentorDetailsViewState extends State<mentorDetailsView> {
  final UserType User;
  Map map;
  mentorDetailsViewState(this.User,this.map);
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
        title: Text(map['username'].toString()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text( map['username'].toString()+' - '+
                map['loc_de_munca'].toString(),style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'Demi')),
            SizedBox(height: 15,),
            Text(map['functie_loc_de_munca'].toString() + " - " +  map['domeniu_specializare'].toString(),style: TextStyle(
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


/*
     title: Text( _FilterMentors[index]['username'].toString()+' - '+
                    _FilterMentors[index]['loc_de_munca'].toString(),
                  style: TextStyle(fontSize: 20,color: Colors.black87,fontFamily: 'Demi'),),
                subtitle: Text( _FilterMentors[index]['functie_loc_de_munca'].toString() + " - " +  _FilterMentors[index]['domeniu_specializare'].toString(),
                  style: TextStyle(fontSize: 20,color: Colors.grey,fontFamily: 'regular'),),
* */