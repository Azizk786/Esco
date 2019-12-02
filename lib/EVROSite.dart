import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class Evrositeview extends StatefulWidget {
  @override
  _EvrositeviewState createState() => _EvrositeviewState();
}

class _EvrositeviewState extends State<Evrositeview> {
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
       title: Text("Site Escouniv",
           style:
           TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'regular')),
     ),
body: Container(
  color: Colors.white,
  child: Text("Under Development",
      style:
      TextStyle(color: Appcolor.redHeader, fontSize: 20.0, fontFamily: 'regular'),textAlign: TextAlign.center,),
),
    );
  }
}
