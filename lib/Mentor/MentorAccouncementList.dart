import 'package:flutter/material.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/Mentor/MentorAnnouncementDetail.dart';
import 'package:escouniv/EVROMenu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/Company Representative/AddAnnouncement.dart';


String StrUser;
class MentorAnnouncemntlist extends StatefulWidget {
  @override
  final UserType User;

  MentorAnnouncemntlist({Key key, @required this.User}) : super(key: key);
  _MentorAnnouncemntlistState createState() => _MentorAnnouncemntlistState(User);
}

class _MentorAnnouncemntlistState extends State<MentorAnnouncemntlist> {
  UserType User;
  String _searchText = "";
  bool _saving = true;
  final TextEditingController _filter = new TextEditingController();
  List _announcementList = new List();
  List _FilterannouncementList = new List();
  String struserid;

  Future<List> getinformation() async {
    final String url = API.Base_url + API.getMentorAnnouncement;
    final client = new http.Client();
    final streamedRest = await client.post(url,
        body: {'user_id' : struserid}, headers: {'End-Client': 'escon', 'Auth-Key': 'escon@2019'});
    print(streamedRest.body);
    if (streamedRest.statusCode == 200)
      {
        Map<dynamic, dynamic> map = json.decode(streamedRest.body);
        int status = map["status"] as int;
        setState(() {
          _saving = false;
        });

        return map["listAnnouncement"];
      }else
        {
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

  _MentorAnnouncemntlistState(this. User) {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _FilterannouncementList = _announcementList;
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
    getinformation().then((res) {
      setState(() {
        _announcementList.addAll(res);
      });
    });


    setState(() {
      List tempList = new List();
      for (int i = 0; i < _announcementList.length; i++) {
        tempList.add(_announcementList[i]);
      }
      _announcementList = tempList;
      _announcementList.shuffle();
      _FilterannouncementList = _announcementList;
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

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < _FilterannouncementList.length; i++) {
        if (_FilterannouncementList[i]['titlu'].toLowerCase().contains(
            _searchText.toLowerCase()) ||
            _FilterannouncementList[i]['localitate'].toLowerCase().contains(
                _searchText.toLowerCase())) {
          tempList.add(_FilterannouncementList[i]);
        }
      }
      _FilterannouncementList = tempList;
    }
    return  ListView.separated(
      padding: EdgeInsets.all(20),
      shrinkWrap: true,
      itemCount:  _announcementList == null ? 0 : _FilterannouncementList.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.black38,),
      itemBuilder: (context, index) {
        return Column(
//crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _FilterannouncementList[index]["titlu"],
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontFamily: "Demi"),
                        ),
                        SizedBox(height: 3),
                        Text(_FilterannouncementList[index]["localitate"] == null ?
                        "Nu e disponibil" : _FilterannouncementList[index]["localitate"]
                          ,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0),
                        ),
                        SizedBox(height: 10),
                        Text(
                          _FilterannouncementList[index]["descriere"],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16.0),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Container(
                    width: 50,
                    child: FlatButton(
                      onPressed: () {

                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddAnnouncement(User: User, forEdit: true, mdata: _FilterannouncementList[index],)));
                      }, //callback when button is clicked
                      child: Icon(Icons.arrow_forward_ios,color: Colors.grey,),

                    ),
                  )
                ]),
          ],
        );
      },
    );
  }



  //Life cycle ------------------View initiate here
  void initState() {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista Anunturi"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
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
                        hintText: "Cauta mesaj",
                        //  border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        fillColor: Colors.white
                    ),
                  ),
                )
            ),
            SizedBox(height:10),
            Expanded(child: _buildList())

          ],
        ),
      ),
      drawer: Drawer(
        child: SideMenu(StrUserType: User),
      ),
    );
  }
}


class SlideMenu extends StatefulWidget {
  final Widget child;
  final List<Widget> menuItems;

  SlideMenu({this.child, this.menuItems});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = new AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = new Tween(
        begin: const Offset(0.0, 0.0),
        end: const Offset(-0.2, 0.0)
    ).animate(new CurveTween(curve: Curves.decelerate).animate(_controller));

    return new GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta / context.size.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity > 2500)
          _controller.animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 || data.primaryVelocity < -2500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: new Stack(
        children: <Widget>[
          new SlideTransition(position: animation, child: widget.child),
          new Positioned.fill(
            child: new LayoutBuilder(
              builder: (context, constraint) {
                return new AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        new Positioned(
                          right: .0,
                          top: .0,
                          bottom: .0,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: new Container(
                            width: 200,
                            color: Colors.transparent,
                            child: new Row(
                              children: widget.menuItems.map((child) {
                                return new Expanded(
                                  child: child,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}