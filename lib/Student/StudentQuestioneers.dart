
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class Questionareview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Questionview();
  }
}


class Questionview extends StatefulWidget {
  @override
  _QuestionviewState createState() => _QuestionviewState();
}

class _QuestionviewState extends State<Questionview> {
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
        title: Text("Chestionare"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10.0, top: 10.0),
              child: Text('Chestiona 1'),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: Text('Chestiona 1 - Descriere Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris justo nisl, eleifend at vestibulum sit amet, bibendum id'),
            )

          ],
        ),
      ),

    );
  }
}
