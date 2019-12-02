
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class AboutUsview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Aboutview();
  }
}


class Aboutview extends StatefulWidget {
  @override
  _AboutviewState createState() => _AboutviewState();
}

class _AboutviewState extends State<Aboutview> {
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
  }  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child : Container(
//            url: "https://escouniv.ro/despre",
//            withJavascript: true,
//            withLocalUrl: true,
//            appBar: new AppBar(
//              title: new Text("About Us"),
//            ),
//            withZoom: true,
//            withLocalStorage: true,
          )
      ),
    );
  }
}
