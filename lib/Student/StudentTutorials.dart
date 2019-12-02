

import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../EVROMenu.dart';
import 'package:escouniv/Student/StudentTutorialDetails.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html_textview/flutter_html_textview.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class StudentTutorials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StudentTutorialsview();
  }
}

class StudentTutorialsview extends StatefulWidget {
  @override
  StudentTutorialsviewState createState() => StudentTutorialsviewState();
}

class StudentTutorialsviewState extends State<StudentTutorialsview> {
  final TextEditingController _filter = new TextEditingController();

  List _Tutorial = new List();
  List _FilterTutorial = new List();
  String struserid;
  String _searchText = "";
  bool _saving = true;
  int counter = 0;
  @override
  //API Call (Get history list)----------------------
  Future<List> getTutorial() async {
    _saving = true;
    final String url = API.Base_url + API.GetTutorialList;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id': struserid},
        headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);

    if(streamedRest.statusCode == 200)
      {
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        String Status = map["status"].toString();
        setState(() {
          _saving = false;
        });

        return map["tutoarialsList"];
      }

    else {
    setState(() {
    _saving = false;
    });
    if (streamedRest.statusCode == 400)
    {
    showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_400);
    }
    else if (streamedRest.statusCode == 401)
    {
    showMyDialog(context, APIErrorMsg.ERROR_CODE_401);
    }
    else if (streamedRest.statusCode == 500)
    {
    showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_500);
    }
    else if (streamedRest.statusCode == 1001)
    {
    showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1001);
    }
    else if (streamedRest.statusCode == 1005)
    {
    showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_1005);
    }
    else if (streamedRest.statusCode == 999)
    {
    showMyDialog(context, APIErrorMsg.ERROR_MESSAGE_FOR_999);
    }
    else
    {
      Map<dynamic, dynamic> map = json.decode(streamedRest.body);
      showMyDialog(context, map["romanMsg"].toString());
    }

    }



  }

  StudentTutorialsviewState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _FilterTutorial = _Tutorial;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  //Private method to get History list
  void fetchData() {
    getTutorial().then((res) {
      setState(() {
        _Tutorial.addAll(res);

      });
    });
    List tempList = new List();
    for (int i = 0; i < _Tutorial.length; i++) {
      tempList.add(_Tutorial[i]);
    }
    setState(() {
      _Tutorial = tempList;
      _Tutorial.shuffle();
      _FilterTutorial = _Tutorial;
    });
  }
  GetUserdata() async
  {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Userdata') ?? '';
    Map userdata = json.decode(myString);
    setState(() {
      struserid = userdata["userid"].toString();
      fetchData();
    });
    print("Print userdata in Side menu");
    print(userdata);

  }

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < _FilterTutorial.length; i++) {
        if (_FilterTutorial[i]['titlu'].toLowerCase().contains(_searchText.toLowerCase())|| _FilterTutorial[i]['continut_principal'].toLowerCase().contains(_searchText.toLowerCase()) ) {
          tempList.add(_FilterTutorial[i]);
        }
      }
      _FilterTutorial = tempList;
    }
    //    return ListView.builder(
//      itemCount: _Firms == null ? 0 : _FilterFirms.length,
//      itemBuilder: (BuildContext context, int index) {
//        return new ListTile(
//          title: Text(_FilterFirms[index]['name']),
//          onTap: () => print(_FilterFirms[index]['name']),
//        );
//      },
//    );
    return ListView.separated(
      shrinkWrap: true,
      itemCount: _Tutorial == null ? 0 : _FilterTutorial.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        return Container(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text( _FilterTutorial[index]['titlu'].toString(),
                  style: TextStyle(fontSize: 20,color: Colors.black,fontFamily: 'Demi'),),
                subtitle: HtmlTextView(data: _FilterTutorial[index]['continut_principal'].toString()),
                isThreeLine: true,
                //  trailing: Icon(Icons.keyboard_arrow_right),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TutorialDetails(StrUserType: UserType.Student, map: _FilterTutorial[index])),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

  }

  void _searchPressed() {

  }
  //
  showMyDialog(BuildContext context, String strmsg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Text(
              strmsg,
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  //Life cycle ------------------View initiate here

  @override
  void initState() {
    _filter.addListener(_searchPressed);
    super.initState();
    GetUserdata();
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
        title: new Center(child: new Text('Tutoriale', textAlign: TextAlign.center)),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          new Stack(
            children: <Widget>[
              new IconButton(icon: Icon(Icons.notifications), onPressed: () {
                setState(() {
                  counter = 0;
                });
              }),
              counter != 0 ? new Positioned(
                right: 11,
                top: 11,
                child: new Container(
                  padding: EdgeInsets.all(2),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '$counter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ) : new Container()
            ],
          ),
          SizedBox(width: 20),

        ],
      ),
      body: ModalProgressHUD(inAsyncCall: _saving, child: Container(
        child: Column(
          children: <Widget>[

            Container(
              // color: Appcolor.redHeader,
                alignment: Alignment.center,
                height: 80.0,
                decoration: new BoxDecoration(
                    color: Appcolor.redHeader,
                    border: new Border.all(
                        color: Appcolor.redHeader,
                        width: 4.0
                    ),
                    borderRadius: new BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10))
                ),
                padding: EdgeInsets.all(15.0),
                child: Container(

                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.all(const Radius.circular(10.0))),
                  child:
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Cauta",
                      //  border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                      fillColor: Colors.white,
                    ),
                    controller: _filter,

                  ),
                )
            ),
            SizedBox(height:10),
            Expanded(

                child: _buildList()
            ),
          ],
        ),
      ),),
      drawer: Drawer(
        child: StudentSideDrawer(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

//class SlideMenu extends StatefulWidget {
//  final Widget child;
//  final List<Widget> menuItems;
//
//  SlideMenu({this.child, this.menuItems});
//
//  @override
//  _SlideMenuState createState() => new _SlideMenuState();
//}
//
//class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
//  AnimationController _controller;
//
//  @override
//  initState() {
//    super.initState();
//    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
//  }
//
//  @override
//  dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    final animation = new Tween(
//        begin: const Offset(0.0, 0.0),
//        end: const Offset(-0.2, 0.0)
//    ).animate(new CurveTween(curve: Curves.decelerate).animate(_controller));
//
//    return new GestureDetector(
//      onHorizontalDragUpdate: (data) {
//        // we can access context.size here
//        setState(() {
//          _controller.value -= data.primaryDelta / context.size.width;
//        });
//      },
//      onHorizontalDragEnd: (data) {
//        if (data.primaryVelocity > 2500)
//          _controller.animateTo(.0); //close menu on fast swipe in the right direction
//        else if (_controller.value >= .5 || data.primaryVelocity < -2500) // fully open if dragged a lot to left or on fast swipe to left
//          _controller.animateTo(1.0);
//        else // close if none of above
//          _controller.animateTo(.0);
//      },
//      child: new Stack(
//        children: <Widget>[
//          new SlideTransition(position: animation, child: widget.child),
//          new Positioned.fill(
//            child: new LayoutBuilder(
//              builder: (context, constraint) {
//                return new AnimatedBuilder(
//                  animation: _controller,
//                  builder: (context, child) {
//                    return new Stack(
//                      children: <Widget>[
//                        new Positioned(
//                          right: .0,
//                          top: .0,
//                          bottom: .0,
//                          width: constraint.maxWidth * animation.value.dx * -1,
//                          child: new Container(
//                            width: 200,
//                            color: Colors.transparent,
//                            child: new Row(
//                              children: widget.menuItems.map((child) {
//                                return new Expanded(
//                                  child: child,
//                                );
//                              }).toList(),
//                            ),
//                          ),
//                        ),
//                      ],
//                    );
//                  },
//                );
//              },
//            ),
//          )
//        ],
//      ),
//    );
//  }
//}



