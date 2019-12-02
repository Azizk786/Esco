import 'dart:async';

import 'package:escouniv/Constant/Constant.dart';
import 'package:flutter/material.dart';

enum KeyBoardType {
  numeric,
  email,
  phone
}

class Selector extends StatefulWidget {

  List  selectorTypes;
  String placeHolder;
  KeyBoardType keyboardType;

  Selector({Key key, @required this.selectorTypes, @required this.placeHolder, @required this.keyboardType}) : super(key: key);

  SelectorState st;
  @override
  SelectorState createState() => st = SelectorState(selectorTypes, placeHolder, keyboardType);

  setSelectedSelector(List selectedList, List keys) {
    st.setSelectedSelectors(selectedList, keys);
  }

  getSelectedSelector(List keys) {
    return st.getSelectedSelector(keys);
  }
}

class SelectorState extends State<Selector> {

  ContactNumber contactNumber_1;
  ContactNumber contactNumber_2;
  ContactNumber contactNumber_3;
  ContactNumber contactNumber_4;
  KeyBoardType keyBoardType;
  List selectorTypes = [];
  String placeHolder;


  int rowCount = 1;

  List<DropdownMenuItem<ContactNumber>> _dropdownMenuItems;
  List<ContactNumber> _users = [];

  List<TextEditingController> _controllers = new List();
  List<FocusNode> _focusNodes = new List();

  List<ContactNumber> _phonetypecontroller = new List();

  SelectorState(this.selectorTypes, this.placeHolder, this.keyBoardType);

  @override
  void initState() {
    super.initState();
    _users = ContactNumber.addSelectors(selectorTypes);
    _dropdownMenuItems = buildDropdownMenuItems(_users);
  }


  @override
  Widget build(BuildContext context) {

    if(KeyBoardType.email == keyBoardType) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: rowCount,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              _controllers.add(new TextEditingController());
              _focusNodes.add(new FocusNode());
              return Container(
                height: 65,
                child:  _forLastinde(index, true),
              );
            },
          ),
          KeyBoardType.email == keyBoardType ? OutlineButton(
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.center,
                    child: Text("Adauga alta platforma")
                )
              ],
            ),
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            textColor: Colors.green,
            onPressed: () {
              addSocialMediaField();
            }, //callback when button is clicked
            borderSide: BorderSide(
              color: Colors.green, //Color of the border
              style: BorderStyle.solid, //Style of the border
              width: 1, //width of the border
            ),
          ) : null
        ]);
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
        SizedBox(height: 10),
        ListView.builder(
      shrinkWrap: true,
      itemCount: rowCount,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        _controllers.add(new TextEditingController());
        _focusNodes.add(new FocusNode());
        return Container(
          height: 65,
          child:  _forLastinde(index, false),
        );
      },
    )]);
  }

  addSocialMediaField() {
    this.setState(() {
      int _inx = rowCount - 1;

      ContactNumber cntN = null;

      switch (_inx) {
        case 0:
          cntN = contactNumber_1;
          break;
        case 1:
          cntN = contactNumber_2;
          break;
        case 2:
          cntN = contactNumber_3;
          break;
        case 3:
          cntN = contactNumber_4;
          break;
      }


      TextEditingController ctrl = _controllers[rowCount - 1];
      if (cntN != null) {
        if (ctrl.text.length > 0 && _users.length > rowCount) {
          rowCount = rowCount + 1;
          _controllers.add(new TextEditingController());
          _focusNodes.add(new FocusNode());


          switch (_inx + 1) {
            case 1:
              for (int i = 0; i < _dropdownMenuItems.length; i++) {
                if (_dropdownMenuItems[i].value.name != contactNumber_1.name) {
                  contactNumber_2 = _dropdownMenuItems[i].value;
                  _phonetypecontroller[1].name =
                      _dropdownMenuItems[i].value.name;
                  break;
                }
              }

              break;
            case 2:
              for (int i = 0; i < _dropdownMenuItems.length; i++) {
                if (_dropdownMenuItems[i].value.name != contactNumber_2.name &&
                    _dropdownMenuItems[i].value.name != contactNumber_1.name) {
                  contactNumber_3 = _dropdownMenuItems[i].value;
                  _phonetypecontroller[2].name =
                      _dropdownMenuItems[i].value.name;
                  break;
                }
              }
              break;
            case 3:
              for (int i = 0; i < _dropdownMenuItems.length; i++) {
                if (_dropdownMenuItems[i].value.name != contactNumber_3.name &&
                    _dropdownMenuItems[i].value.name != contactNumber_2.name &&
                    _dropdownMenuItems[i].value.name != contactNumber_1.name) {
                  contactNumber_4 = _dropdownMenuItems[i].value;
                  _phonetypecontroller[3].name =
                      _dropdownMenuItems[i].value.name;
                  break;
                }
              }
              break;
          }

          Timer(Duration(milliseconds: 100), () {
            FocusScope.of(context).requestFocus(_focusNodes[rowCount-1]);
          });

        } else {
          if(ctrl.text.length == 0) {
            showMyDialog(context, "Vă rugăm să adăugați o adresă de e-mail");
          } else {
            showMyDialog(context, "Vi s-au adăugat toate platformele disponibile");
          }
        }
      } else {
        showMyDialog(context, "Vă rugăm să selectați platforma");
      }
    });
  }

  Widget _forLastinde(int _inx, isEmail)
  {
    ContactNumber cntN = null;

    switch(_inx) {
      case 0:
        cntN = contactNumber_1;
        break;
      case 1:
        cntN = contactNumber_2;
        break;
      case 2:
        cntN = contactNumber_3;
        break;
      case 3:
        cntN = contactNumber_4;
        break;
    }

    if(_inx == rowCount-1)
    {

      return  Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // new Flexible(
          Container(
            margin: EdgeInsets.only(top: 25),
            //width: double.infinity,
            child: DropdownButton(items: _dropdownMenuItems,
                onChanged: (ContactNumber user){
                  onChangeDropdownItem(user, _inx);
                },
                icon:Icon(Icons.keyboard_arrow_down, color: Appcolor.redHeader),
                value: cntN,
                hint: placeHolder == "Id" ? Text('Furnizer',) : Text('Tip de telefon',)),
          ),
          //),
          SizedBox(width: 20),
          new Flexible(
            child: new  TextFormField(
              focusNode: _focusNodes[_inx],
              controller: _controllers[_inx],
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 10),
                  labelText: placeHolder,
                  suffixIcon: IconButton(icon: Icon(KeyBoardType.email == keyBoardType ? null : Icons.add_circle,color: Appcolor.redHeader,),  onPressed: () {
                    this.setState(() {
                      if(KeyBoardType.email != keyBoardType) {

                        if(cntN != null) {
                          TextEditingController ctrl = _controllers[rowCount -
                              1];
                          if (ctrl.text.length > 0 &&
                              _users.length > rowCount) {
                            _controllers.add(new TextEditingController());
                            _focusNodes.add(new FocusNode());
                            rowCount = rowCount + 1;
                            switch (_inx + 1) {
                              case 1:
                                for (int i = 0; i <
                                    _dropdownMenuItems.length; i++) {
                                  if (_dropdownMenuItems[i].value.name !=
                                      contactNumber_1.name) {
                                    contactNumber_2 =
                                        _dropdownMenuItems[i].value;
                                    _phonetypecontroller[1].name =
                                        _dropdownMenuItems[i].value.name;
                                    break;
                                  }
                                }

                                break;
                              case 2:
                                for (int i = 0; i <
                                    _dropdownMenuItems.length; i++) {
                                  if (_dropdownMenuItems[i].value.name !=
                                      contactNumber_2.name &&
                                      _dropdownMenuItems[i].value.name !=
                                          contactNumber_1.name) {
                                    contactNumber_3 =
                                        _dropdownMenuItems[i].value;
                                    _phonetypecontroller[2].name =
                                        _dropdownMenuItems[i].value.name;
                                    break;
                                  }
                                }
                                break;
                              case 3:
                                for (int i = 0; i <
                                    _dropdownMenuItems.length; i++) {
                                  if (_dropdownMenuItems[i].value.name !=
                                      contactNumber_3.name &&
                                      _dropdownMenuItems[i].value.name !=
                                          contactNumber_2.name &&
                                      _dropdownMenuItems[i].value.name !=
                                          contactNumber_1.name) {
                                    contactNumber_4 =
                                        _dropdownMenuItems[i].value;
                                    _phonetypecontroller[3].name =
                                        _dropdownMenuItems[i].value.name;
                                    break;
                                  }
                                }
                                break;
                            }
                          }else {
                            if(ctrl.text.length == 0) {
                              showMyDialog(context, "Please add telephone");
                            } else {
                              showMyDialog(context, "Vi s-au adăugat toate telefoanele disponibile");
                            }
                          }
                        } else {
                          showMyDialog(context, "Vă rugăm să selectați tipul de telefon");
                        }
                      }

                      Timer(Duration(milliseconds: 100), () {
                        FocusScope.of(context).requestFocus(_focusNodes[rowCount-1]);
                      });


                    });
                  },)
              ),
              keyboardType: setKeyboardType(keyBoardType),

            ),
          ),
        ],
      );
    }else
    {
      return   Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 25),
            //width: double.infinity,
            child: DropdownButton(items: _dropdownMenuItems,elevation: 1,isDense: false,
                onChanged:  (ContactNumber user){
                  onChangeDropdownItem(user, _inx);
                },icon:Icon(Icons.keyboard_arrow_down,
                    color: Appcolor.redHeader),value:  cntN,
                hint: placeHolder == "Id" ? Text('Furnizer',) : Text('Tip de telefon',)),
          ),
          SizedBox(width: 20),
          new Flexible(
            child: new  TextFormField(
              focusNode: _focusNodes[_inx],
              controller: _controllers[_inx],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 10),
                  labelText: placeHolder,
                  suffixIcon: IconButton(icon: Icon(Icons.remove_circle,color: Appcolor.redHeader,),  onPressed: () {
                    this.setState(() {
                      if (rowCount>1) {

                        switch(_inx) {
                          case 0:
                            for(int i = 0; i < _dropdownMenuItems.length; i++) {
                              if(_dropdownMenuItems[i].value.name == contactNumber_1.name ) {
                                contactNumber_1 = contactNumber_2;
                                _phonetypecontroller[0].name = _phonetypecontroller[1].name;
                                contactNumber_2 = null;
                                _phonetypecontroller[1].name = "";
                                if(contactNumber_3 != null) {
                                  contactNumber_2 = contactNumber_3;
                                  _phonetypecontroller[1].name = _phonetypecontroller[2].name;
                                  contactNumber_3 = null;
                                  _phonetypecontroller[2].name = "";
                                }

                                if(contactNumber_4 != null) {
                                  contactNumber_3 = contactNumber_4;
                                  _phonetypecontroller[2].name = _phonetypecontroller[3].name;
                                  contactNumber_4 = null;
                                  _phonetypecontroller[3].name = "";
                                }
                                break;
                              }
                            }

                            break;
                          case 1:
                            for(int i = 0; i < _dropdownMenuItems.length; i++) {
                              if(_dropdownMenuItems[i].value.name == contactNumber_2.name ) {
                                contactNumber_2 = contactNumber_3;
                                _phonetypecontroller[1].name = _phonetypecontroller[2].name;
                                contactNumber_3 = null;
                                _phonetypecontroller[2].name = "";

                                if(contactNumber_4 != null) {
                                  contactNumber_3 = contactNumber_4;
                                  _phonetypecontroller[2].name = _phonetypecontroller[3].name;
                                  contactNumber_4 = null;
                                  _phonetypecontroller[3].name = "";
                                }
                                break;
                              }

                            }
                            break;
                          case 2:
                            for(int i = 0; i < _dropdownMenuItems.length; i++) {
                              if(_dropdownMenuItems[i].value.name == contactNumber_3.name ) {
                                contactNumber_3 = contactNumber_4;
                                _phonetypecontroller[2].name = _phonetypecontroller[3].name;
                                contactNumber_4 = null;
                                _phonetypecontroller[3].name = "";
                                break;
                              }
                            }
                            break;
                        }
                        rowCount = rowCount-1;
                        _controllers.removeAt(_inx);
                        _focusNodes.removeAt(_inx);
                      }


                    });
                  },)
              ),
              keyboardType: setKeyboardType(keyBoardType),

            ),
          ),
        ],
      );
    }
  }

  setKeyboardType(KeyBoardType keyBoardType) {
    TextInputType type;
    switch(keyBoardType) {
      case KeyBoardType.numeric:
        type = TextInputType.number;
        break;
      case KeyBoardType.email:
        type = TextInputType.emailAddress;
        break;
      case KeyBoardType.phone:
        type = TextInputType.phone;
        break;
    }
    return type;
  }

  onChangeDropdownItem(ContactNumber SelectedUser, int rowIndex) {

    if((contactNumber_1 != null && SelectedUser.name == contactNumber_1.name && rowIndex != 0) || (contactNumber_2 != null && SelectedUser.name == contactNumber_2.name && rowIndex != 1) || (contactNumber_3 != null && SelectedUser.name == contactNumber_3.name && rowIndex != 2) || (contactNumber_4 != null && SelectedUser.name == contactNumber_4.name && rowIndex != 3)) {

      showMyDialog(context, "You can't select as you have selected it already!");
      // Show dialog
      return;
    }

    setState(() {

      switch(rowIndex) {
        case 0:
          contactNumber_1 = SelectedUser;
          _phonetypecontroller[0].name = SelectedUser.name;
          break;
        case 1:
          contactNumber_2 = SelectedUser;
          _phonetypecontroller[1].name = SelectedUser.name;
          break;
        case 2:
          contactNumber_3 = SelectedUser;
          _phonetypecontroller[2].name = SelectedUser.name;
          break;
        case 3:
          contactNumber_4 = SelectedUser;
          _phonetypecontroller[3].name = SelectedUser.name;
          break;
      }
    });
  }

  List<DropdownMenuItem<ContactNumber>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<ContactNumber>> items = List();
    for (ContactNumber user in _users) {
      _phonetypecontroller.add(ContactNumber(user.id, ""));

      items.add(
        DropdownMenuItem(
          value: user,
          child: Text(user.name.toString()),
        ),
      );
    }
    return items;
  }

  showMyDialog(BuildContext context, String strmsg) {
    showDialog(
        context: context,
        builder: (BuildContext context){
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
        }
    );
  }

  setSelectedSelectors(List selectedList, List keys) {

    setState(() {

      _controllers = [];
      _focusNodes = [];

      int _rowCount = selectedList != null ? selectedList.length : 0;
    if(_rowCount == 0) {
      rowCount = 1;
      final _cont = TextEditingController();
      _controllers.add(_cont);
      _focusNodes.add(new FocusNode());
      contactNumber_1 = _dropdownMenuItems[0].value;
      _phonetypecontroller[0].name = _dropdownMenuItems[0].value.name;
    }

    for (var i = 0; i < _rowCount; i++) {
      rowCount = _rowCount;
      final _cont = TextEditingController();
      _cont.text = selectedList[i][keys[1]];
      _controllers.add(_cont);
      _focusNodes.add(new FocusNode());


      for(int j = 0; j < _dropdownMenuItems.length; j++) {
        if(selectedList[i][keys[0]] == _dropdownMenuItems[j].value.name) {

          switch(i) {
            case 0:
              contactNumber_1 = _dropdownMenuItems[j].value;
              _phonetypecontroller[0].name = _dropdownMenuItems[j].value.name;
              break;
            case 1:
              contactNumber_2 = _dropdownMenuItems[j].value;
              _phonetypecontroller[1].name = _dropdownMenuItems[j].value.name;
              break;
            case 2:
              contactNumber_3 = _dropdownMenuItems[j].value;
              _phonetypecontroller[2].name = _dropdownMenuItems[j].value.name;
              break;
            case 3:
              contactNumber_4 = _dropdownMenuItems[j].value;
              _phonetypecontroller[3].name = _dropdownMenuItems[j].value.name;
              break;
          }
        }
      }
    }
    });
  }

  getSelectedSelector(List keys) {
    List <Map> arr = [];

    for(int i = 0; i < _phonetypecontroller.length; i++) {
      if(_phonetypecontroller[i].name != "" ) {
        TextEditingController cou =  _controllers[i];
        if(cou.text.length != 0) {
          Map cc ={keys[1]: cou.text.toString(), keys[0]: _phonetypecontroller[i].name};
          arr.add(cc);
        }
      }
    }
    return arr;
  }

}

class ContactNumber {
  int id;
  String name;
  ContactNumber(this.id, this.name);

  static addSelectors(List selectorTypes) {

    List<ContactNumber> lst= [];
    for(int i = 0; i < selectorTypes.length; i++) {
      lst.add(ContactNumber(i, selectorTypes[i]));
    }
    return lst;
  }
}