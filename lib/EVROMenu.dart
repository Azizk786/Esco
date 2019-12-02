import 'package:flutter/material.dart';
import 'package:escouniv/Profile.dart';
import 'package:escouniv/Constant/Constant.dart';
import 'package:escouniv/Mentor/MentorAddInformation.dart';
import 'package:escouniv/Dashboard.dart';
import 'package:escouniv/Message.dart';
import 'package:escouniv/EVROSite.dart';
import 'package:escouniv/Company Representative/AddAnnouncement.dart';
import 'package:escouniv/Mentor/MentorBriefingList.dart';
import 'package:escouniv/Psychological Counselor/PCounsellorAppointmentHistory.dart';
import 'package:escouniv/Career Counsellor/CCAvailability.dart';
import 'package:escouniv/Career Counsellor/CCDocumentReview.dart';
import 'Student/StudentFAQ.dart';
import 'Student/StudentTutorials.dart';
import 'Student/SuccessStoriesList.dart';
import 'package:escouniv/Student/CCAppointmentList.dart';
import 'package:escouniv/Student/StudentFacultyStudyCounsellor.dart';
import 'package:escouniv/Student/MentorList.dart';
import 'package:escouniv/main.dart';
import 'package:escouniv/Student/CompanyList.dart';
import 'package:escouniv/Mentor/MentorAccouncementList.dart';
import 'package:escouniv/AboutUs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:escouniv/WebViewContainer.dart';
import 'package:escouniv/InformationList.dart';
import 'package:escouniv/StudentHistory.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:escouniv/Student/UserAnnouncement.dart';
import 'package:escouniv/Student/EmployementAnnouncementList.dart';
import 'package:escouniv/Student/StudentRedactareCV.dart';
import 'package:escouniv/VideoChat.dart';
import 'package:escouniv/EVROChat.dart';

//import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class SideMenu extends StatelessWidget {
  UserType StrUserType;
  SideMenu({Key key, @required this.StrUserType}) : super(key: key);
  Widget GetUserdrawer() {
    // if (StrUser != null) {
    switch (StrUserType) {
      case UserType.CP:
        {
          return CompanyRepresentiveSideDrawer();
        }
        break;
      case UserType.Mentor:
        {
          return MentorSideDrawer();
        }
        break;
      case UserType.Pupil:
        {
          return PupilSideDrawer();
        }
        break;
      case UserType.Student:
        {
          return StudentSideDrawer();
        }
        break;
      case UserType.Pcounsellor:
        {
          return PhycologicalCounsellorSideDrawer();
        }
        break;
      case UserType.CCounsellor:
        {
          return CareerCounsellorSidedrawer(User: StrUserType);
        }
        break;
      default:
        {
          return StudentSideDrawer();
        }
        break;
    }
    //}
  }

  Widget build(BuildContext context) {
    return GetUserdrawer();
  }
}

//Career Counsellor---------------------------------------------
class CareerCounsellorSidedrawer extends StatefulWidget {
  final UserType User;
  CareerCounsellorSidedrawer({Key key, @required this.User}) : super(key: key);
  @override
  _CareerCounsellorSidedrawerState createState() =>
      _CareerCounsellorSidedrawerState(User);
}

class _CareerCounsellorSidedrawerState
    extends State<CareerCounsellorSidedrawer> {
  @override
  UserType User;
  String Strname = "";
  double _animatedHeight = 0.0;
  String StrArrow = 'Assets/Images/Compressarrow.png';
  Map userdata;
  _CareerCounsellorSidedrawerState(this.User);
  final _links = 'https://escouniv.ro/despre';
  final _linkSite = 'https://escouniv.ro/home';
  SharedPreferences prefss;
String imgURL;


  void _handleURLButtonPress(BuildContext context, String url, String title ) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url,title)));
  }
  _clearLoggedInUserdata() async {
    await prefss.clear();
  }

  GetUserdata() async
  {
    prefss = await SharedPreferences.getInstance();
    final myString = prefss.getString('Userdata') ?? '';

    final profileString = prefss.getString('Profiledata') ?? '';
    Map profiledata = json.decode(profileString);

    userdata = json.decode(myString);
    setState(() => this.Strname = userdata["fullname"].toString());
    setState(() {
      String  struserfolder = profiledata["userFolder"];
      Strname = userdata["fullname"].toString();
      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+profiledata["listUser"][0]["picture"];
      imgURL = _imgURL;
    });
  }
  @override
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
                child: const Text('YES'),
                onPressed: () {
                  _clearLoggedInUserdata();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyApp(prefss),
                      ),
                      ModalRoute.withName('/'));
                },
              ),
              FlatButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
  Widget build(BuildContext context) {
    print("CC Side Drawer");
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
          image: new DecorationImage(
        image: new AssetImage("Assets/Images/DrawerBg.png"),
        fit: BoxFit.cover,
      )),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[

              Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 54, left: 15),
                      width: 80,
                      height: 80,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: new BorderRadius.all(const Radius.circular(60))
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 70, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Strname,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                  fontFamily: 'Demi'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Consilier Cariera",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: 'Demi'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            new GestureDetector(
                                onTap: () {
                                showMyDialog(context, "Sunteți sigur că doriți să vă deconectați?");
                                },
                                child:  Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Image.asset('Assets/Images/redlogout.png'),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Iesire",
                                    style: TextStyle(
                                        color: Appcolor.redHeader,
                                        fontSize: 18.0,
                                        fontFamily: 'Demi'))
                              ],
                            )),
                          ],
                        ))
                  ])),

            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard(StrUserType: User)),
                );
              },
              child: new Container(
                color: Colors.black,
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset('Assets/Images/Menuhome.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Panou Principal",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CareerCounsellor()),
                );
              },
              child: new Container(
                color: Colors.black,
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset('Assets/Images/Person.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Profil",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Messageview(StrUserType: User)),
                );
              },
              child: new Container(
                color: Colors.black,
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                            new Image.asset('Assets/Images/Menumessage.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Mesaje",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PCAppointmentHistory(User: UserType.CCounsellor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset('Assets/Images/Istoric.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Istoric Programari",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CCDocumentReview(User: UserType.CCounsellor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset(
                            'Assets/Images/MenuDocumentReview.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Corectare Documente",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CCAvailability(User: UserType.CCounsellor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset(
                            'Assets/Images/MenuAvailability.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Disponibilitati",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () => setState(() {
                _animatedHeight != 0.0
                    ? _animatedHeight = 0.0
                    : _animatedHeight = 102.0;
                StrArrow != 'Assets/Images/Compressarrow.png'
                    ? StrArrow = 'Assets/Images/Compressarrow.png'
                    : StrArrow = 'Assets/Images/expandarrow.png';
              }),
              child: new Container(
                color: Appcolor.redHeader.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                            new Image.asset('Assets/Images/MenuBriefing.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Informari",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            Container(
              height: _animatedHeight,
              child: Column(
                children: <Widget>[
                  aLine,
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddInformation(User: UserType.CCounsellor,forEdit: false,)),
                      );
                    },
                    child: new Container(
                      color: Appcolor.redHeader.withOpacity(0.95),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 12),
                              child: Text("- Adaugati",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'regular')))
                        ],
                      ),
                    ),
                  ),
                  aLine,
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                userinformation(User: User)),
                      );
                    },
                    child: new Container(
                      color: Appcolor.redHeader.withOpacity(0.95),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text("- Lista Informari",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'regular')))
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                _handleURLButtonPress(context, _linkSite,"Site ESCOUNIV");
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                        new Image.asset('Assets/Images/Menuescouniv.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Site ESCOUNIV",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
                onTap: () {
                  _handleURLButtonPress(context, _links,"About");
                },
                child:  new Container(
              color: Colors.black.withOpacity(0.95),
              height: 250,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 200),
                  Text("Copyright © 2017 EscoUniv - About",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontFamily: 'regular'))
                ],
              ),
            )
      )
          ],
        ),
      ),
    );
  }
}

class PhycologicalCounsellorSideDrawer extends StatefulWidget {
  @override
  final UserType User;
  PhycologicalCounsellorSideDrawer({Key key, @required this.User})
      : super(key: key);
  _PhycologicalCounsellorSideDrawerState createState() =>
      _PhycologicalCounsellorSideDrawerState();
}

class _PhycologicalCounsellorSideDrawerState
    extends State<PhycologicalCounsellorSideDrawer> {
  double _animatedHeight = 0.0;
  String Strname = "";
  String StrArrow = 'Assets/Images/Compressarrow.png';
  Map userdata;


  final _links = 'https://escouniv.ro/despre';
  final _linkSite = 'https://escouniv.ro/home';
  SharedPreferences prefss;
  String imgURL;

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url,title)));
  }

  GetUserdata() async
  {
    prefss = await SharedPreferences.getInstance();
    final myString = prefss.getString('Userdata') ?? '';

    final profileString = prefss.getString('Profiledata') ?? '';
    Map profiledata = json.decode(profileString);

    userdata = json.decode(myString);
    setState(() => this.Strname = userdata["fullname"].toString());
    setState(() {
      String  struserfolder = profiledata["userFolder"];
      Strname = userdata["fullname"].toString();
      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+profiledata["listUser"][0]["picture"];
      imgURL = _imgURL;
    });
  }
  _clearLoggedInUserdata() async {
    await prefss.clear();
  }
  @override
  void initState() {
    super.initState();
    GetUserdata();

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
                child: const Text('YES'),
                onPressed: () {
                  _clearLoggedInUserdata();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyApp(prefss),
                      ),
                      ModalRoute.withName('/'));
                },
              ),
              FlatButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
  Widget build(BuildContext context) {
    print("CP Side Drawer");
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("Assets/Images/DrawerBg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
              Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.95),
                  ),
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 54, left: 15),
                      width: 80,
                      height: 80,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: new BorderRadius.all(const Radius.circular(60))
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 70, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                             Strname,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                  fontFamily: 'Demi'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Consilier Psihologic",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: 'Demi'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            new GestureDetector(
                                onTap: () {
                                  showMyDialog(context, "Sunteți sigur că doriți să vă deconectați?");
                                },
                                child:  Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Image.asset('Assets/Images/redlogout.png'),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Iesire",
                                    style: TextStyle(
                                        color: Appcolor.redHeader,
                                        fontSize: 18.0,
                                        fontFamily: 'Demi'))
                              ],
                            ))
                          ],
                        ))
                  ])),
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Dashboard(StrUserType: UserType.Pcounsellor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 55,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset('Assets/Images/Menuhome.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Panou Principal",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PhsycologicalProfile()),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 55,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset('Assets/Images/Person.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Profil",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Messageview(StrUserType: UserType.Pcounsellor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 55,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                            new Image.asset('Assets/Images/Menumessage.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Mesaje",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PCAppointmentHistory(User: UserType.Pcounsellor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 55,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset(
                            'Assets/Images/MenuappointmentHistory.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text(
                          "Istoric Programari",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CCAvailability(User: UserType.Pcounsellor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 55,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset(
                            'Assets/Images/MenuAvailability.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Disponibilitati",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                _handleURLButtonPress(context, _linkSite,"Informari Esco");
              },
              child: new Container(
                color: Colors.black.withOpacity(0.90),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset(
                            'Assets/Images/MenuEscobriefings.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Informari Esco",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,

            new GestureDetector(
              onTap: () => setState(() {
                _animatedHeight != 0.0
                    ? _animatedHeight = 0.0
                    : _animatedHeight = 102.0;
                StrArrow != 'Assets/Images/Compressarrow.png'
                    ? StrArrow = 'Assets/Images/Compressarrow.png'
                    : StrArrow = 'Assets/Images/expandarrow.png';
              }),
              child: new Container(
                color: Appcolor.redHeader.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                        new Image.asset('Assets/Images/MenuBriefing.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Informari",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            Container(
              height: _animatedHeight,
              child: Column(
                children: <Widget>[
                  aLine,
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddInformation(User: UserType.Pcounsellor,forEdit: false,)),
                      );
                    },
                    child: new Container(
                      color: Appcolor.redHeader.withOpacity(0.95),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 12),
                              child: Text("- Adaugati",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'regular')))
                        ],
                      ),
                    ),
                  ),
                  aLine,
                  new GestureDetector(
                    onTap: () {
                      /*
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                userinformation(User: User)),
                      );
                      * */
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                userinformation(User: UserType.Pcounsellor)),
                      );
                    },
                    child: new Container(
                      color: Appcolor.redHeader.withOpacity(0.95),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text("- Lista Informari",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'regular')))
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
               _handleURLButtonPress(context, _linkSite,"Site ESCOUNIV");
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 55,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                            new Image.asset('Assets/Images/Menuescouniv.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Site ESCOUNIV",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            //    aLine,
            new GestureDetector(
                onTap: () {
                  _handleURLButtonPress(context, _links, "About");
                },
                child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 250,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 170),
                  Text("Copyright © 2017 EscoUniv - About",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontFamily: 'regular'))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class CompanyRepresentiveSideDrawer extends StatefulWidget {
  @override
  _CompanyRepresentiveSideDrawerState createState() =>
      _CompanyRepresentiveSideDrawerState();
}

class _CompanyRepresentiveSideDrawerState
    extends State<CompanyRepresentiveSideDrawer> {
  Map userdata;
  String Strname = "";
  final _links = 'https://escouniv.ro/despre';
  final _linkSite = 'https://escouniv.ro/home';
  SharedPreferences prefss;
String imgURL;

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url,title)));
  }
  _clearLoggedInUserdata() async {
    await prefss.clear();
  }

  GetUserdata() async
  {
    prefss = await SharedPreferences.getInstance();
    final myString = prefss.getString('Userdata') ?? '';

    final profileString = prefss.getString('Profiledata') ?? '';
    Map profiledata = json.decode(profileString);

    userdata = json.decode(myString);
    setState(() => this.Strname = userdata["fullname"].toString());
    setState(() {
      String  struserfolder = profiledata["userFolder"];
      Strname = userdata["fullname"].toString();
      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+profiledata["listUser"][0]["picture"];
      imgURL = _imgURL;
    });
  }
  @override
  void initState() {
    super.initState();
    GetUserdata();

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
                child: const Text('YES'),
                onPressed: () {
                  _clearLoggedInUserdata();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyApp(prefss),
                      ),
                      ModalRoute.withName('/'));
                },
              ),
              FlatButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
  Widget build(BuildContext context) {
    print("CR Side Drawer");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("Assets/Images/DrawerBg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
           Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.95),
                  ),
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 54, left: 15),
                      width: 80,
                      height: 80,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: new BorderRadius.all(const Radius.circular(60))
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 70, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Strname,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                  fontFamily: 'Demi'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Reprezentant Firma",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: 'Demi'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            new GestureDetector(
                                onTap: () {
                                  showMyDialog(context, "Sunteți sigur că doriți să vă deconectați?");
                                },
                                child:  Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Image.asset('Assets/Images/redlogout.png'),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Iesire",
                                    style: TextStyle(
                                        color: Appcolor.redHeader,
                                        fontSize: 18.0,
                                        fontFamily: 'Demi'))
                              ],
                            ))
                          ],
                        ))
                  ])),

            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Dashboard(StrUserType: UserType.CP)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset('Assets/Images/Menuhome.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Panou Principal",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CompanyRepresentative()),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
//                      alignment: Alignment.centerLeft,
                        child: new Image.asset('Assets/Images/Person.png')),
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Profil",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Messageview(StrUserType: UserType.CP)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                            new Image.asset('Assets/Images/Menumessage.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Mesaje",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EmployeeAnnouncemntlist(User: UserType.CP)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset(
                            'Assets/Images/MenuempAnnouncement.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Anunturi Angajare",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context) =>
//                          MentorAnnouncemntlist(User: UserType.CP)),
//                );
              },
              child: new Container(
                color: Appcolor.redHeader.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset(
                            'Assets/Images/MenucomAnnouncement.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Anunturi Firma",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                print(" add announcement");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAnnouncement(User: UserType.CP, forEdit: false)),
                );
              },
              child: new Container(
                color: Appcolor.redHeader.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Text("- Adaugati",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                         Companylist(Strusertype: UserType.CP)),
                );
              },
              child: new Container(
                color: Appcolor.redHeader.withOpacity(0.95),
                height: 55,
                child: Row(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 12),
                        child: Text("- Lista Anunturi",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
              _handleURLButtonPress(context, _linkSite,"Site ESCOUNIV");
              },
              child: new Container(
                color: Colors.black.withOpacity(0.90),
                height: 55,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                            new Image.asset('Assets/Images/Menuescouniv.png')),
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Site ESCOUNIV",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            //  aLine,
            new GestureDetector(
                onTap: () {
                  _handleURLButtonPress(context, _links,"About");
                },
                child:  new Container(
              color: Colors.black.withOpacity(0.90),
              height: 200,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 130),
                  Text("Copyright © 2017 EscoUniv - About",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontFamily: 'regular'))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class MentorSideDrawer extends StatefulWidget {
  @override
  _MentorSideDrawerState createState() => _MentorSideDrawerState();
}

class _MentorSideDrawerState extends State<MentorSideDrawer> {
  double _animatedHeight = 0.0;
  String Strname = "";
  String StrArrow = 'Assets/Images/Compressarrow.png';
  double _animatedHeight1 = 0.0;
  String StrArrow1 = 'Assets/Images/Compressarrow.png';
  Map userdata;

  final _links = 'https://escouniv.ro/despre';
  final _linkSite = 'https://escouniv.ro/home';
  SharedPreferences prefss;
String imgURL;


  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url,title)));
  }
  _clearLoggedInUserdata() async {
    await prefss.clear();
  }
  GetUserdata() async
  {
    prefss = await SharedPreferences.getInstance();
    final myString = prefss.getString('Userdata') ?? '';

    final profileString = prefss.getString('Profiledata') ?? '';
    Map profiledata = json.decode(profileString);

    userdata = json.decode(myString);
    setState(() => this.Strname = userdata["fullname"].toString());
    setState(() {
      String  struserfolder = profiledata["userFolder"];

        Strname = userdata["fullname"].toString();

      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+profiledata["listUser"][0]["picture"];
      imgURL = _imgURL;
    });
  }
  @override
  void initState() {
    super.initState();
    GetUserdata();

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
                child: const Text('YES'),
                onPressed: () {
                  _clearLoggedInUserdata();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyApp(prefss),
                      ),
                      ModalRoute.withName('/'));
                },
              ),
              FlatButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
  Widget build(BuildContext context) {
    print("Mentor Side Drawer");
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage("Assets/Images/DrawerBg.png"),
          fit: BoxFit.cover,
        ),
      ),
      //color: Colors.black.withOpacity(0.75),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
             Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.90),
                  ),
                  child: Row(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 54, left: 15),
                      width: 80,
                      height: 80,
                      decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: new BorderRadius.all(const Radius.circular(60))
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 70, left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Strname,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20.0,
                                  fontFamily: 'Demi'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Mentor",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: 'Demi'),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            new GestureDetector(
                                onTap: () {
                                  showMyDialog(context, "Sunteți sigur că doriți să vă deconectați?");
                                },
                                child:   Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Image.asset('Assets/Images/redlogout.png'),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Iesire",
                                    style: TextStyle(
                                        color: Appcolor.redHeader,
                                        fontSize: 18.0,
                                        fontFamily: 'Demi'))
                              ],
                            ))
                          ],
                        ))
                  ])),

            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Dashboard(StrUserType: UserType.Mentor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.90),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset('Assets/Images/Menuhome.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5.0),
                        child: Text("Panou Principal",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MentorProfileView()),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.90),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset('Assets/Images/Person.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5.0),
                        child: Text("Profil",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Messageview(StrUserType: UserType.Mentor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.90),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                            new Image.asset('Assets/Images/Menumessage.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5.0),
                        child: Text("Mesaje",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EmployeeAnnouncemntlist(User: UserType.Mentor)),
                );
              },
              child: new Container(
                color: Colors.black.withOpacity(0.90),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset(
                            'Assets/Images/MenuempAnnouncement.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5.0),
                        child: Text(
                          "Anunturi Angajare",
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                        ))
                  ],
                ),
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () => setState(() {
                _animatedHeight1 != 0.0
                    ? _animatedHeight1 = 0.0
                    : _animatedHeight1 = 102.0;
                StrArrow1 != 'Assets/Images/Compressarrow.png'
                    ? StrArrow1 = 'Assets/Images/Compressarrow.png'
                    : StrArrow1 = 'Assets/Images/expandarrow.png';
              }),
              child: new Container(
                color: Appcolor.redHeader.withOpacity(0.90),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child: new Image.asset(
                            'Assets/Images/MenucomAnnouncement.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5.0),
                        child: Text("Anunturi Mentorat",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            aLine,
            Container(
              height: _animatedHeight1,
              child: Column(
                children: <Widget>[

                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddAnnouncement(User: UserType.Mentor, forEdit: false)),
                      );
                    },
                    child: new Container(
                      color: Appcolor.redHeader.withOpacity(0.95),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text("- Adaugati",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'regular')))
                        ],
                      ),
                    ),
                  ),
                  aLine,
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MentorAnnouncemntlist(User: UserType.Mentor)),
                      );
                    },
                    child: new Container(
                      color: Appcolor.redHeader.withOpacity(0.95),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 12),
                              child: Text("- Lista Anunturi",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'regular')))
                        ],
                      ),
                    ),
                  ),
                  aLine,
                ],
              ),
            ),
            new GestureDetector(
              onTap: () => setState(() {
                _animatedHeight != 0.0
                    ? _animatedHeight = 0.0
                    : _animatedHeight = 102.0;
                StrArrow != 'Assets/Images/Compressarrow.png'
                    ? StrArrow = 'Assets/Images/Compressarrow.png'
                    : StrArrow = 'Assets/Images/expandarrow.png';
              }),
              child: new Container(
                color: Appcolor.redHeader.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                        new Image.asset('Assets/Images/MenuBriefing.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5),
                        child: Text("Informari",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            Container(
              height: _animatedHeight,
              child: Column(
                children: <Widget>[
                  aLine,
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddInformation(User: UserType.Mentor,forEdit: false,)),
                      );
                    },
                    child: new Container(
                      color: Appcolor.redHeader.withOpacity(0.95),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 12),
                              child: Text("- Adaugati",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'regular')))
                        ],
                      ),
                    ),
                  ),
                  aLine,
                  new GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                userinformation(User: UserType.Mentor)),
                      );
                    },
                    child: new Container(
                      color: Appcolor.redHeader.withOpacity(0.95),
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text("- Lista Informari",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: 'regular')))
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            aLine,
            new GestureDetector(
              onTap: () {
               _handleURLButtonPress(context, _linkSite,"Site ESCOUNIV");
              },
              child: new Container(
                color: Colors.black.withOpacity(0.95),
                height: 50,
                child: Row(
                  children: <Widget>[
                    Container(
                        height: 24.0,
                        width: 24.0,
                        margin: EdgeInsets.only(left: 12),
                        child:
                            new Image.asset('Assets/Images/Menuescouniv.png')),
                    Container(
                        margin: EdgeInsets.only(left: 16, top: 5.0),
                        child: Text("Site ESCOUNIV",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))
                  ],
                ),
              ),
            ),
            //   aLine,
        new GestureDetector(
          onTap: () {
            _handleURLButtonPress(context, _links,"About");
          },
          child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 250,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 170),
                  Text("Copyright © 2017 EscoUniv - About",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontFamily: 'regular'))
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

class StudentSideDrawer extends StatefulWidget {
  @override
  _StudentSideDrawerState createState() => _StudentSideDrawerState();
}

class _StudentSideDrawerState extends State<StudentSideDrawer> {
  double _animatedHeight = 0.0;
  double _animatedHeight1 = 0.0;
  double _animatedHeight2 = 0.0;
  String Strname = "";
  final _links = ['https://escouniv.ro/despre'];
  final _linkVocational = 'https://escouniv.ro/despre';
  final _Questionarilink = 'https://escouniv.ro/chestionare';
  final _linkSite = 'https://escouniv.ro/home';
  final _Facultylink = 'https://escouniv.ro/student/consilieri-studii-pe-facultati';
  String StrArrow1 = 'Assets/Images/Compressarrow.png';
  String StrArrow2 = 'Assets/Images/Compressarrow.png';
  String StrArrow3 = 'Assets/Images/Compressarrow.png';
  SharedPreferences prefss;
  String imgURL;
  Map userdata;

/*
final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myString = prefs.getString('Profiledata') ?? '';
    setState(() {


     Map profiledata = json.decode(myString);
      struserfolder = profiledata["userFolder"];
      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+profiledata["listUser"][0]["picture"];
      imgURL = _imgURL;
* */

  GetUserdata() async
  {
    prefss = await SharedPreferences.getInstance();
    final myString = prefss.getString('Userdata') ?? '';

    final profileString = prefss.getString('Profiledata') ?? '';
    Map profiledata = json.decode(profileString);

    userdata = json.decode(myString);
    setState(() => this.Strname = userdata["fullname"].toString());
    setState(() {
      String  struserfolder = profiledata["userFolder"];
      Strname = userdata["fullname"].toString();
      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+profiledata["listUser"][0]["picture"];
      imgURL = _imgURL;
    });
  }
  _clearLoggedInUserdata() async {
    await prefss.clear();
  }
  @override
  void initState() {
    super.initState();
    GetUserdata();

  }
  Widget _urlButton(BuildContext context, String url) {
    return Container(
        padding: EdgeInsets.all(20.0),
        child: FlatButton(
        //  color: Theme.of(context).primaryColor,
       //   padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
          child:Text("Copyright © 2017 EscoUniv - About",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontFamily: 'regular')),
          onPressed: () => _handleURLButtonPress(context, url,"About us"),
        ));
  }


  void _handleURLButtonPress(BuildContext context, String url,String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url,title)));
//    Navigator.push(
//        context,
//        MaterialPageRoute(builder: (context) => ChatMessage(User: UserType.Student,Senderid: "118")));
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
                child: const Text('YES'),
                onPressed: () {
                  _clearLoggedInUserdata();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => MyApp(prefss),
                      ),
                      ModalRoute.withName('/'));
                },
              ),
              FlatButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }
  Widget build(BuildContext context) {
    print("Student Side Drawer");
    return Container(
      decoration: new BoxDecoration(
        // color: Colors.black.withOpacity(0.90),
        image: new DecorationImage(
          image: new AssetImage("Assets/Images/DrawerBg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.95),
                ),
                child: Row(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 54, left: 15),
                    width: 80,
                    height: 80,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: new BorderRadius.all(const Radius.circular(60))
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 70, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Strname,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                                fontFamily: 'Demi'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Student",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'Demi'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          new GestureDetector(
                              onTap: () {
                                showMyDialog(context, "Sunteți sigur că doriți să vă deconectați?");
                              },
                              child:   Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Image.asset('Assets/Images/redlogout.png'),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Iesire",
                                  style: TextStyle(
                                      color: Appcolor.redHeader,
                                      fontSize: 18.0,
                                      fontFamily: 'Demi'))
                            ],
                          ))
                        ],
                      ))
                ])),
           //Header
          //   aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Dashboard(StrUserType: UserType.Student)),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/Menuhome.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Panou Principal",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Dashboard
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentProfile()),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/Person.png')),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Profil",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Profile
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Messageview(StrUserType: UserType.Student)),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/Menumessage.png')),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Mesaje",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Message
          aLine,
          new GestureDetector(
            onTap: () => setState(() {
                  _animatedHeight != 0.0
                      ? _animatedHeight = 0.0
                      : _animatedHeight = 160.0;
                  StrArrow1 != 'Assets/Images/Compressarrow.png'
                      ? StrArrow1 = 'Assets/Images/Compressarrow.png'
                      : StrArrow1 = 'Assets/Images/expandarrow.png';
                }),
            child: new Container(
              color: Appcolor.redHeader.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/RedactiveCV.png')),
                  Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      alignment: Alignment.centerLeft,
                      child: Text("Redactare CV",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'))),
                  SizedBox(
                    width: 80,
                  ),
                  Container(
                      height: 15,
                      width: 15,
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      alignment: Alignment.centerLeft,
                      child: new Image.asset(StrArrow1)),
                ],
              ),
            ),
          ),
          new Container(
            height: _animatedHeight,
            color: Appcolor.redHeader.withOpacity(0.95),
            child: Column(
              children: <Widget>[
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RedatareCV(
                                  User: UserType.Student,cVType: "1",)));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- CV",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RedatareCV(
                                User: UserType.Student,cVType: "2",)));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- Scrisoare de Intentie",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RedatareCV(
                                User: UserType.Student,cVType: "3",)));

                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- Plan Cariera",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
              ],
            ),
          ), // CV section-------------
          aLine,
          new GestureDetector(
            onTap: () => setState(() {
                  _animatedHeight1 != 0.0
                      ? _animatedHeight1 = 0.0
                      : _animatedHeight1 = 310.0;
                  StrArrow2 != 'Assets/Images/Compressarrow.png'
                      ? StrArrow2 = 'Assets/Images/Compressarrow.png'
                      : StrArrow2 = 'Assets/Images/expandarrow.png';
                }),
            child: new Container(
              color: Appcolor.redHeader.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/Consiliere.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Text("Consilier Cariera",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'))),
                  SizedBox(
                    width: 50,
                  ),
                  Container(
                      height: 15,
                      width: 15,
                      margin: EdgeInsets.only(left: 35),
                      alignment: Alignment.centerLeft,
                      child: new Image.asset(StrArrow2)),
                ],
              ),
            ),
          ),
          aLine,
          new Container(
            height: _animatedHeight1,
            color: Appcolor.redHeader.withOpacity(0.95),
            child: Column(
              children: <Widget>[
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      _handleURLButtonPress(context, _linkVocational,"Teste Vocationale");
                    },
                    child: Container(
                        color: Appcolor.redHeader.withOpacity(0.95),
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- Teste Vocationale",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentTutorials()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- Tutoriale",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>CCAppointmentList(counsellorType: 'carrier')));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- Programare Consiliere",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StudentFacultyStudyCounsellor()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- Consilieri de studii pe facultati",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentFaqs()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- FAQ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuccessStoriesList()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- Povesti de succes",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
              ],
            ),
          ),
          aLine,
          new GestureDetector(
            onTap: () => setState(() {
                  _animatedHeight2 != 0.0
                      ? _animatedHeight2 = 0.0
                      : _animatedHeight2 = 110.0;
                  StrArrow3 != 'Assets/Images/Compressarrow.png'
                      ? StrArrow3 = 'Assets/Images/Compressarrow.png'
                      : StrArrow3 = 'Assets/Images/expandarrow.png';
                }),
            child: new Container(
              color: Appcolor.redHeader.withOpacity(0.95),
              height: 46,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/MenuPC.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Text("Consiliere Psihologica",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'))),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 15,
                      width: 15,
                      margin: EdgeInsets.only(left: 35),
                      alignment: Alignment.centerLeft,
                      child: new Image.asset(StrArrow3)),
                ],
              ),
            ),
          ),
          new Container(
            color: Appcolor.redHeader.withOpacity(0.95),
            height: _animatedHeight2,
            child: Column(
              children: <Widget>[
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CCAppointmentList(counsellorType: 'phy')));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- Programare Consiliere",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentFaqs()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 20),
                        child: Text("- FAQ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontFamily: 'regular')))),
                aLine,
              ],
            ),
          ),
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => studentAppointmentHistory(User: UserType.Student)),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/Istoric.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Istoric Programari",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'regular'),
                        softWrap: true,
                      ))
                ],
              ),
            ),
          ), //Informe selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => information()),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/MenuBriefing.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Informari",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Istoric selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Mentorlist()),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/MenuMentor.png')),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Mentor",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Mentor
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Companylist(Strusertype: UserType.Student)),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 60,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/Firme.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Firme",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Firme selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmployeeAnnouncemntlist(User: UserType.Student)),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset(
                          'Assets/Images/MenuempAnnouncement.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Anunturi Angajare",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Anuntare selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
           //   _links.map((link) => _urlButton(context, link)).toList();
              _handleURLButtonPress(context, _Questionarilink,"Chestionare");

            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/Chestionare.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Chestionare",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'))
                  )
                ],
              ),
            ),
          ), //Chestinonare selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
              _handleURLButtonPress(context, _linkSite,"Site ESCOUNIV");
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/Menuescouniv.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Site ESCOUNIV",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Site ESCOUNIV selection from side drawer-------------------------------
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsview()),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.92),
              height: 150,
              width: double.infinity,
              child: Column(
                //children: <Widget>[
                 // SizedBox(height: 70),
                  children: _links.map((link) => _urlButton(context, link)).toList(),
                //],
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class PupilSideDrawer extends StatefulWidget {
  @override
  _PupilSideDrawerState createState() => _PupilSideDrawerState();
}

class _PupilSideDrawerState extends State<PupilSideDrawer> {
  double _animatedHeight = 0.0;
  double _animatedHeight1 = 0.0;
  String StrArrow1 = 'Assets/Images/Compressarrow.png';
  String StrArrow2 = 'Assets/Images/Compressarrow.png';
  Map userdata;
  String Strname = "";
  final _links = 'https://escouniv.ro/despre';
  final _linkSite = 'https://escouniv.ro/home';
  final _linkVocational = 'https://escouniv.ro/despre';
  final _Questionarilink = 'https://escouniv.ro/chestionare';
  SharedPreferences prefss;
  String imgURL;

  getPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  void _handleURLButtonPress(BuildContext context, String url,String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url,title)));
  }
  GetUserdata() async
  {
    prefss = await SharedPreferences.getInstance();
    final myString = prefss.getString('Userdata') ?? '';

    final profileString = prefss.getString('Profiledata') ?? '';
    Map profiledata = json.decode(profileString);

    userdata = json.decode(myString);
    setState(() => this.Strname = userdata["fullname"].toString());
    setState(() {
      String  struserfolder = profiledata["userFolder"];
      Strname = userdata["fullname"].toString();
      String _imgURL = API.LiveImageBaseurl+struserfolder+'/'+profiledata["listUser"][0]["picture"];
      imgURL = _imgURL;
    });
  }


  _clearLoggedInUserdata() async {
    await prefss.clear();
  }
  @override
  void initState() {
    super.initState();
    GetUserdata();
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
                child: const Text('YES'),
                onPressed: () {
                 _clearLoggedInUserdata();

                 Navigator.pushAndRemoveUntil(
                     context,
                     MaterialPageRoute(
                       builder: (BuildContext context) => MyApp(prefss),
                     ),
                     ModalRoute.withName('/'));
                },
              ),
              FlatButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    print("PUPIL Side Drawer");
    var aLine = Container(
      color: Colors.red.withOpacity(0.8),
      width: MediaQuery.of(context).size.width,
      height: 1.0,
      margin: EdgeInsets.only(left: 0),
    );
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        image: new DecorationImage(
          image: new AssetImage("Assets/Images/DrawerBg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Container(
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.95),
                ),
                child: Row(children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 54, left: 15),
                    width: 80,
                    height: 80,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: imgURL == null ? AssetImage("Assets/Images/DefaultUser.png") : new NetworkImage(imgURL),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: new BorderRadius.all(const Radius.circular(60))
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 70, left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Strname,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                                fontFamily: 'Demi'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Elev",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'Demi'),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          new GestureDetector(
                              onTap: () {
                                showMyDialog(context, "Sunteți sigur că doriți să vă deconectați?");
                              },
                              child:  Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Image.asset('Assets/Images/redlogout.png'),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Iesire",
                                  style: TextStyle(
                                      color: Appcolor.redHeader,
                                      fontSize: 18.0,
                                      fontFamily: 'Demi'))
                            ],
                          ))
                        ],
                      ))
                ])),
           //Header
          //   aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Dashboard(StrUserType: UserType.Pupil)),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/Menuhome.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Panou Principal",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Dashboard
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PupilProfile()),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/Person.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Profil",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Profile
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Messageview(StrUserType: UserType.Pupil)),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/Menumessage.png')),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Mesaje",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Message
          aLine,
          new GestureDetector(
            onTap: () => setState(() {
                  _animatedHeight != 0.0
                      ? _animatedHeight = 0.0
                      : _animatedHeight = 170.0;
                  StrArrow1 != 'Assets/Images/Compressarrow.png'
                      ? StrArrow1 = 'Assets/Images/Compressarrow.png'
                      : StrArrow1 = 'Assets/Images/expandarrow.png';
                }),
            child: new Container(
              color: Appcolor.redHeader.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/RedactiveCV.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text(
                        "Redactare CV",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'regular'),
                        softWrap: true,
                      )),
                  SizedBox(
                    width: 80,
                  ),
                  Container(
                      height: 15,
                      width: 15,
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: new Image.asset(StrArrow1)),
                ],
              ),
            ),
          ),
          Container(
            height: _animatedHeight,
            color: Appcolor.redHeader.withOpacity(0.95),
            child: Column(
              children: <Widget>[
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RedatareCV(
                                User: UserType.Pupil,cVType: "1",)));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 12),
                        child: Text(
                          "- CV",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RedatareCV(
                                User: UserType.Pupil,cVType: "2",)));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 12),
                        child: Text(
                          "- Scrisoare de intentie",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RedatareCV(
                                User: UserType.Student,cVType: "3",)));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 12),
                        child: Text(
                          "- Plan cariera",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))),
              ],
            ),
          ),
          aLine,
          new GestureDetector(

            onTap: () => setState(() {
              _animatedHeight1 != 0.0
                  ? _animatedHeight1 = 0.0
                  : _animatedHeight1 = 310.0;
              StrArrow2 != 'Assets/Images/Compressarrow.png'
                  ? StrArrow2 = 'Assets/Images/Compressarrow.png'
                  : StrArrow2 = 'Assets/Images/expandarrow.png';
            }),
            child: new Container(
              height: 50,
              color: Appcolor.redHeader.withOpacity(0.95),
              child: Row(
                children: <Widget>[
                  Container(
                      height: 24.0,
                      width: 24.0,
                      margin: EdgeInsets.only(left: 12),
                      child: new Image.asset('Assets/Images/Consiliere.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text(
                        "Consiliere Cariera",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'regular'),
                        softWrap: true,
                      )),
                  SizedBox(width: 70,),
                  Container(
                    height: 15,
                      width: 15,
                      child:
                          new Image.asset(StrArrow2)),
                ],
              ),
            ),
          ),
          Container(
            height: _animatedHeight1,
            color: Appcolor.redHeader.withOpacity(0.95),
            child: Column(
              children: <Widget>[
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      _handleURLButtonPress(context, _linkVocational,"Teste Vocatinale");
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 12),
                        child: Text(
                          "- Teste Vocatinale",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentTutorials()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 12),
                        child: Text(
                          "- Tutorials",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CCAppointmentList()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 12),
                        child: Text(
                          "- Counseling Appointment",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  StudentFacultyStudyCounsellor()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 12),
                        child: Text(
                          "- Faculty Study Counselors List",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentFaqs()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 12),
                        child: Text(
                          "- FAQ",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))),
                aLine,
                new GestureDetector(
                    //Message selection from side drawer-------------------------------
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SuccessStoriesList()));
                    },
                    child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 12),
                        child: Text(
                          "- Success Stories",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular'),
                          softWrap: true,
                        ))),
              ],
            ),
          ),
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => studentAppointmentHistory(User: UserType.Pupil)),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/Istoric.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Istoric Programari",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'regular'),
                        softWrap: true,
                      ))
                ],
              ),
            ),
          ), //Informe selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => information()),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/MenuBriefing.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Informari",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Istoric selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Companylist()),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 60,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/Firme.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Firme",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Firme selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EmployeeAnnouncemntlist(User: UserType.Pupil)),
              );
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset(
                          'Assets/Images/MenuempAnnouncement.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Anunturi Angajare",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Anuntare selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
              _handleURLButtonPress(context, _Questionarilink,"Chestionare");
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/Chestionare.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Chestionare",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Chestinonare selection from side drawer-------------------------------
          aLine,
          new GestureDetector(
            onTap: () {
              _handleURLButtonPress(context, _linkSite,"Site ESCOUNIV");
            },
            child: new Container(
              color: Colors.black.withOpacity(0.95),
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(left: 12),
                      height: 24.0,
                      width: 24.0,
                      child: new Image.asset('Assets/Images/Menuescouniv.png')),
                  Container(
                      margin: EdgeInsets.only(left: 16, top: 5.0),
                      child: Text("Site ESCOUNIV",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontFamily: 'regular')))
                ],
              ),
            ),
          ), //Site ESCOUNIV selection from side drawer-------------------------------
          //   aLine,
          new GestureDetector(
            onTap: () {
              _handleURLButtonPress(context, _links,"About");
            },
            child: new Container(
            color: Colors.black.withOpacity(0.92),
            height: 150,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                SizedBox(height: 70),
                Text("Copyright © 2017 EscoUniv - About",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                        fontFamily: 'regular'))
              ],
            ),
          ))
        ],
      )),
    );
  }
}
