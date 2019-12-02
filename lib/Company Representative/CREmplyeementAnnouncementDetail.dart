import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
class EMPAnnouncemntDetail extends StatefulWidget {
  @override
  final UserType User;

  EMPAnnouncemntDetail({Key key, @required this.User}) : super(key: key);
  _EMPAnnouncemntDetailState createState() => _EMPAnnouncemntDetailState(User);
}

class _EMPAnnouncemntDetailState extends State<EMPAnnouncemntDetail> {
  final UserType User;
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
  _EMPAnnouncemntDetailState(this.User);
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inginer de sistem.."),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Inginer de sistem petru retea Clienti",style: TextStyle(color: Colors.black), textAlign: TextAlign.left,),
            SizedBox(height: 15),
            Text("Post",style: TextStyle(color: Colors.black)),
            SizedBox(height: 10,),
            Text("Inginer de sistem pentru retea clienti in Cluj",style: TextStyle(color: Colors.grey)),
            SizedBox(height: 15,),
            Text("Localitate",style: TextStyle(color: Colors.black)),
            SizedBox(height: 10,),
            Text("Cluj",style: TextStyle(color: Colors.grey)),
            SizedBox(height: 15,),
            Text("Descriere",style: TextStyle(color: Colors.black)),
            SizedBox(height: 10,),
            Text("Compania ACME este o companie internaţională ce oferă servicii de tehnologia informaţiei,avand peste 2000 de angajati în Romania. Deservind clienţi la nivel global, asigură servicii de tranzacţii hi-tech, consultanţă, integrarea sistemelor şi servicii gestionate. Expertiza noastră acoperă o gamă largă de specialişti şi căutăm întotdeauna noi oportunităţi şi inovaţii. Încercăm să conducem prin puterea exemplului, aşa încât să contaţi pe noi pentru a ajunge la o firmă sustenabilă şi de succes a viitorului. Clientii ACME au incredere in companie pentr a dezvolta si livra cea mai buna calitate in domeniul software-ului de calitate, care le maximizeaza potentialul de venituri obtinute. ACME este un furnizor de solutii software flexibile, de o calitate superiora pentru companiile care folosesc tehnologia de inalta clasa. Compania ACME ofera clientilor sai posibilitatea de a-si imbunatati in mod semnificativ timpul pe piata, sporindu-le in acelasi timp profiturile din investitiilor realizate.",style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20,),
            btnDownloadFile,
            btnEdit
        ],
        ),
      ),
    );

  }
}
