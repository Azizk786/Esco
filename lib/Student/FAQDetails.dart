
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../EVROMenu.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class FAQDetails extends StatelessWidget {
  UserType StrUserType;
  Map map;
  FAQDetails({Key key, @required this.StrUserType,  @required this.map}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FAQDetailsView(User: StrUserType, map: map);
  }
}

class FAQDetailsView extends StatefulWidget {
  final UserType User;
  Map map;
  FAQDetailsView({Key key, @required this.User,  @required this.map}) : super(key: key);
  FAQDetailsViewState createState() => FAQDetailsViewState(User, map);
}

class FAQDetailsViewState extends State<FAQDetailsView> {
  final UserType User;
  Map map;
  FAQDetailsViewState(this.User,this.map);
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


  List _FaqList = new List();
  Widget _buildList() {

    return ListView.separated(
      shrinkWrap: true,
      // itemCount: _Faq == null ? 0 : _FilterFaq.length,
      itemCount: 5,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        return Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                 title: HtmlTextView(data: map['titlu'].toString(),),
                subtitle: HtmlTextView(data: map['continut_principal'].toString(),), ),
            ],
          ),
        );
      },
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( map['titlu'].toString()),
        centerTitle: true,
      ),
      body: Container(
        child: _buildList(),
      ),

    );
  }
}
