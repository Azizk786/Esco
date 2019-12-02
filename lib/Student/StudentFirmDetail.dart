
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class FarmDetails extends StatelessWidget {
  UserType StrUserType;
  Map map;
  FarmDetails({Key key, @required this.StrUserType,  @required this.map}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FarmDetailsView(User: StrUserType, map: map);
  }
}

class FarmDetailsView extends StatefulWidget {
  @override
  final UserType User;
  Map map;
  FarmDetailsView({Key key, @required this.User,  @required this.map}) : super(key: key);
  _FarmDetailsViewState createState() => _FarmDetailsViewState(User, map);
}

class _FarmDetailsViewState extends State<FarmDetailsView> {
  final UserType User;
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
  Map map;
  _FarmDetailsViewState(this.User,this.map);

  Widget ManageUnloadButton()
  {
    if(User == UserType.CP)
      {
        return Container(
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
        );
      }else
        {
          return Container();

        }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(map["denumire"].toString()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(map["denumire"].toString(),style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'Demi')),
            SizedBox(height: 15,),
            Text("Post",style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'Demi')),
            SizedBox(height: 15,),
            Text(map["domeniu_activitate"].toString(),style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'Demi')),
            SizedBox(height: 15,),
            Text("Site",style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'Demi')),
            SizedBox(height: 15,),
            Text(map["site"].toString(),style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'Demi')),
            SizedBox(height: 15,),
            Text("Descriere",style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontFamily: 'Demi')),
            SizedBox(height: 15,),
            Text(map["descriere"].toString(),style: TextStyle(
                color: Colors.black54,
                fontSize: 20.0,
                fontFamily: 'Demi')),
            SizedBox(height: 25,),
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
          ],
        ),
      ),

    );
  }
}
