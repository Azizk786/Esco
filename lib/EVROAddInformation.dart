import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class AddAnnouncement extends StatefulWidget {
  @override
  _AddAnnouncementState createState() => _AddAnnouncementState();
}

class _AddAnnouncementState extends State<AddAnnouncement> {
  String dropdownValue = 'One';
  final btnUploadFile = Material(

      color: Colors.transparent,
      child:OutlineButton(
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                widthFactor: 6,
                child: Text(
                  "Upload file",
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
        title: Text("Adauga anunt"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 0,left: 25,right: 25,bottom: 25),
        //color: Colors.red
        //
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Titlu'
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Localitate'
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Descriere",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 10,
              ),
              SizedBox(height: 10),
              Text(
                "Tip anunt",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),

              ),
              Container(
                color: Colors.red,
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Row(
                    children: <Widget>[
//                      TextFormField(
//                        decoration: InputDecoration(
//                          labelText: 'Tara',
//                          suffixIcon: const Icon(
//                            Icons.keyboard_arrow_down,
//                            color: Colors.red,
//                          ),
//                        ),
//                      ),
                    ]
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Vizibilitate",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),

              ),
              Container(
                color: Colors.red,
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Row(
                    children: <Widget>[

                    ]
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Fisier detalii",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),
              ),
              btnUploadFile,
              SizedBox(height: 10),
              Text(
                "Pentru",
                // textAlign: TextAlign.left,textDirection: TextDirection.ltr,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0 ),
              ),
              Container(
                color: Colors.transparent,
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: Row(
                    children: <Widget>[

                    ]
                ),
              ),
            ]
        ),
      ),
    );
  }
}
