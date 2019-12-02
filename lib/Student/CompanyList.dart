

import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../EVROMenu.dart';
import 'package:escouniv/Student/StudentFirmDetail.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
class Companylist extends StatelessWidget {
  UserType Strusertype;
  Companylist({Key key, @required this.Strusertype}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Companylistview(Strusertype: Strusertype);
  }
}

class Companylistview extends StatefulWidget {
  UserType Strusertype;
  Companylistview({Key key, @required this.Strusertype}) : super(key: key);
  @override
  _CompanylistviewState createState() => _CompanylistviewState(Strusertype);
}

class _CompanylistviewState extends State<Companylistview> {
  final TextEditingController _filter = new TextEditingController();
  UserType Strusertype;
  List _Firms = new List();
  List _FilterFirms = new List();
  String struserid;
  String _searchText = "";
  int counter = 0;
  bool _saving = true;
  _CompanylistviewState(this.Strusertype);
  //API Call (Get history list)----------------------
  Future<List> getHistory() async {
    final String url = API.Base_url + API.GetFirmList;
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
        if (Status != "200")
        {
          showMyDialog(context, map["message"].toString());
        }

        return map["firmList"];
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
//  _CompanylistviewState(UserType StrUsertype) {
//    _filter.addListener(() {
//      if (_filter.text.isEmpty) {
//        setState(() {
//          _searchText = "";
//          _FilterFirms = _Firms;
//        });
//      } else {
//        setState(() {
//          _searchText = _filter.text;
//        });
//      }
//    });
//  }

  //Private method to get History list
  void fetchData() {
    getHistory().then((res) {
      setState(() {
        _Firms.addAll(res);

      });
    });

    setState(() {
      List tempList = new List();
      for (int i = 0; i < _Firms.length; i++) {
        tempList.add(_Firms[i]);
      }
      _Firms = tempList;
      _Firms.shuffle();
      _FilterFirms = _Firms;
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
//Searching methods----------------------


  Widget _buildStudentList() {

    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < _FilterFirms.length; i++) {
        if (_FilterFirms[i]['functie_reprezentant'].toLowerCase().contains(_searchText.toLowerCase())|| _FilterFirms[i]['slug'].toLowerCase().contains(_searchText.toLowerCase()) ) {
          tempList.add(_FilterFirms[i]);
        }
      }
      _FilterFirms = tempList;
    }
    if (Strusertype == UserType.Student)
    {
      return ListView.separated(
       // shrinkWrap: true,
        itemCount: _Firms == null ? 0 : _FilterFirms.length,
        separatorBuilder: (BuildContext context, int index) => Divider(color: Colors.black38,),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(15),
            //color: Colors.black54,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_FilterFirms[index]["denumire"] == null?"":_FilterFirms[index]["denumire"] + " - " + _FilterFirms[index]["domeniu_activitate"] == null?"":_FilterFirms[index]["domeniu_activitate"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'Demi')),
                      SizedBox(height: 5,),
                      Text(_FilterFirms[index]["functie_reprezentant"] == null?"":_FilterFirms[index]["functie_reprezentant"],
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                              fontFamily: 'Demi')),
                      SizedBox(height: 10,),
                      Text(_FilterFirms[index]["site"] == null?"":_FilterFirms[index]["site"],
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontFamily: 'Demi'),maxLines: 3,)
                    ],
                  ),
                ),
                Container(
                  child:FlatButton(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black54,
                            )
                        )
                      ],
                    ),
                    //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    //  textColor: Colors.green,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FarmDetails(StrUserType: UserType.Student, map: _FilterFirms[index])));
                    }, //callback when button is clicked
                  ),
                )
                //  Ink.image(image: ""),
              ],
            ),
          );
        },
      );
    }else
    {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: _Firms == null ? 0 : _FilterFirms.length,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(15),
            //color: Colors.black54,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(_FilterFirms[index]["functie_reprezentant"] == null?"":_FilterFirms[index]["functie_reprezentant"] + " - " + _FilterFirms[index]["slug"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontFamily: 'Demi')),
                      SizedBox(height: 5,),
                      Text(_FilterFirms[index]["domeniu_activitate"] == null ?"":_FilterFirms[index]["domeniu_activitate"],
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                              fontFamily: 'Demi')),
                      SizedBox(height: 10,),
                      Text(_FilterFirms[index]["descriere"] == null?"":_FilterFirms[index]["descriere"],
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                            fontFamily: 'Demi'),maxLines: 3,)
                    ],
                  ),
                ),
                Container(
                  child:FlatButton(
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black54,
                            )
                        )
                      ],
                    ),
                    //shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                    //  textColor: Colors.green,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FarmDetails(StrUserType: UserType.Student, map: _FilterFirms[index])));
                    }, //callback when button is clicked
                  ),
                )
                //  Ink.image(image: ""),
              ],
            ),
          );
        },
      );
    }
  }

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
    //_filter.addListener(_searchPressed);
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _FilterFirms = _Firms;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
    super.initState();
    GetUserdata();

    BackButtonInterceptor.add(myInterceptor);
  }

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
        title: new Center(child: new Text('Lista Firme', textAlign: TextAlign.center)),
        elevation: 0,
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

                child: _buildStudentList()
            ),
            SizedBox(height:40),
          ],
        ),
      ),),
      drawer: Drawer(
        child: SideMenu(StrUserType: Strusertype),
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
