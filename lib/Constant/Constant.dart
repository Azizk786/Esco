import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}


class Appcolor
{
  static const Color redHeader = const Color(0xFFA4292A);
  static const Color AppGreen = const Color(0xFF43B757);
}
var aVerticalLine = Container(color: Colors.grey.withOpacity(0.8), width: 1,);
var aGreyHorizonalLine = Container(color: Colors.grey.withOpacity(0.8), width: double.infinity, height: 1.0);


var aLine = Container(color: Colors.red.withOpacity(0.8), width: double.infinity, height: 1.0);

//new url static const String developmentBase_url = 'http://192.168.1.111/eeesv/api/';


//http://192.168.1.111/eeesv/api/Plancv/addPlancv
class API {
  static const String LiveImageBaseurl = 'http://escouniv.ro/upload/users/';
  static const String liveBase_url = 'https://api.escouniv.ro/';
  static const String developmentBase_url = 'http://192.168.1.111/eeesv/api/';
  static const String Base_url = liveBase_url;
  static const String GetUserHistory = 'User/historyProgram';
  static const String GetCounsellorHistory = 'User/historyProgram';
  static const String BookAppointement = 'User/bookProgram'; //type:carrier
  static const String GetBookingList = 'User/listProgram'; //usetype:carrierr_id:120
  static const String GetFaqList = 'User/faqList'; //user_id:120
  static const String GetMentorList = 'User/mentorList'; //user_id:120
  static const String GetFirmList = 'User/firmList'; //user_id:120
  static const String Dashboard = 'User/dashBoard'; //user_id:120
  static const String GetSuccessStory = 'User/succesStory'; //user_id:120
  static const String GetTutorialList = 'User/tutoarialsList'; //user_id:120

  //static const String WebrtcServerAddress = '103.9.1';
 static const String WebrtcServerAddress = '78.46.43.213';

  static const String GetReceivedList = 'User/receivedMessage';
  static const String GetSentList = 'User/sentMessage';
  static const String GetDeletedList = 'User/deletedMessage';
  static const String GetUnreadmessage = 'User/unreadMessage';
  static const String GetComposemessage = 'User/composeMessage';


  static const String GetCheckExist = 'User/checkExist';
  static const String saveCareerPlan = 'Plancv/addPlancv';
  static const String saveLoI = 'Plancv/addPlancv';
  static const String saveCV = 'Plancv/addOnlineCV';
  static const String UpdateCVPlan = 'Plancv/updatePlancv';
  static const String GetCVPlan = 'Plancv/getPlan';
  static const String GetLOI = 'Plancv/getletterOfIntent';
  static const String GetCV = 'Plancv/getOnlineCV';
  static const String saveLetterofIntent = 'Plancv/addlaterOfIntent';
  static const String getUserAnnouncement = 'User/annoucement';
  static const String getMentorAnnouncement = 'User/getAnnouncement';
  static const String getUserInformation = 'User/informationList';
  static const String AddAvailability = 'User/addAvailability';
  static const String EditAvailability = 'User/editAvailability';
  static const String AvailabilityList = 'User/addedAvailabilityLists';
  static const String LetterOfIntentList = 'Plancv/laterIntentRequestList';
  static const String OnlineCVRequestList = 'Plancv/onlineCVRequestList';
  static const String PlancvRequestList = 'Plancv/Plancvlist';
  static const String AcceptCV = 'Plancv/acceptCv';
  static const String AddInformation = 'User/addInformation';
  static const String UserAddedInformation = 'User/addedInformationList';
  static const String UpdateUserprofile = 'User/updateProfile';
  static const String AcceptBooking = 'User/accpetBooking';
  static const String CancelBooking = 'User/cancelBooking';
  static const String GetUserProfile = 'User/getUserProfile';
  static const String AddMentorAnnouncement = 'User/addAnnouncement';
  static const String UpdateMentorAnnouncement = 'User/updateAnunt';
  static const String SendCareerplanCorrectRquest = 'Plancv/reqForCorrectionCv';
//
  //Letter of intent cv---------------
  static const String SendLoiCorrectRquest = 'Plancv/reqOfCorrLOI';
  static const String AcceptLoiCorrectRquest = 'Plancv/acceptLOI';
  static const String CorrectLoIRquest = 'Plancv/correctLOIReq';


  static const String SendCVCorrectRquest = 'Plancv/OnlineCVReqForCorr';
  static const String AcceptCVCorrectRquest = 'Plancv/OnlineCVAcceptForCorr';
  static const String CorrectCVRquest = 'Plancv/updateOnlineCV';
//For cancel all cv request----------------------
  static const String CancelCVCorrectRquest = 'Plancv/OnlineCVCorrReqCancel';
  static const String CancelLOICorrectRquest = 'Plancv/LOICorrReqCancel';
  static const String CancelCVPlanCorrectRquest = 'Plancv/PlancvCorrReqCancel';

  static const String DeleteAccountRequest = 'User/deleteAccReq';
  static const String UpdateDeviceToken = 'User/deviceAdded';
  static const String GetFaculty = 'User/facultyLists';
  static const String isreadMessage = 'User/isreadMessage';

  //Chat
  static const String GetAllChathistory = 'User/getallChat';
  static const String SendChat = 'User/chating';
}
enum UserType {
  CP,
  Mentor,
  Pupil,
  Student,
  Pcounsellor,
  CCounsellor
}

class APIErrorMsg
{
  static const String ERROR_MESSAGE_FOR_400 = "Cerere greșită";
  static const String ERROR_CODE_401 = "Acces neautorizat";
  static const String ERROR_MESSAGE_FOR_500 = "Eroare interna a serverului. Vă rugăm să încercați din nou";
  static const String ERROR_MESSAG_NO_INTERNETCONNECTION = "Verificați conexiunea dvs. și încercați din nou";
  static const String ERROR_MESSAGE_FOR_UNKNOWN = "Conexiunea sigură a eșuat dintr-un motiv necunoscut";
  static const String ERROR_MESSAGE_FOR_1001 = "Solicitați timp";
  static const String ERROR_MESSAGE_FOR_1005 = "Conexiunea la Internet a fost pierdută";
  static const String ERROR_MESSAGE_FOR_999 = "Solicitarea a fost anulată";
  static const String ERROR_MESSAGE_DEFAULT = "Nicio inregistrare gasita";
}



//#B3A4292A

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

 //API Constant------------------------------------
class AppState {
  final int count;
  final bool isLoading;

  AppState({this.count = 0, this.isLoading = false});

  AppState copyWith({int count, bool isLoading}) {
    return new AppState(
        count: count ?? this.count,
        isLoading: isLoading ?? this.isLoading
    );
  }

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, count: $count}';
  }
}