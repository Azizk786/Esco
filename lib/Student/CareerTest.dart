import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../EVROMenu.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class CareerTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CareerTestView();
  }
}

class CareerTestView extends StatefulWidget {
  @override
  _CareerTestViewState createState() => _CareerTestViewState();
}

class _CareerTestViewState extends State<CareerTestView> {
   Duration delay = const Duration(milliseconds: 2000);

  void initState() {
    super.initState();
    Future.delayed(delay);
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
    bool _saving  = true;

    Future.delayed(Duration(milliseconds: 2000), () {
      setState(() {
        setState(() {
          //_saving = false;
        });
      });
    });
   return  Scaffold(
     body: ModalProgressHUD(inAsyncCall: _saving, child: new Container(
      // url: "http://192.168.1.18:8000/eveniment/eveniment-2018",
     ),color:Colors.blue,),

     appBar: new AppBar(
       title: new Text("Teste vocationale"),
       backgroundColor: Appcolor.redHeader,
     ),

    );
  }
}

