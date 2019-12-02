import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:escouniv/main.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class FCMNotificationManager {
final FCMTokenCallback callback;

FCMNotificationManager(this.callback);

configureFCMNotification() {
  _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      _handleNotification(message);

    },
    onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");

    },
  );

  _firebaseMessaging.getToken().then((String token) {
    assert(token != null);
     {

       print("Print device token here=$token");
     }
  });

  }


Future<void> _handleNotification (Map<dynamic, dynamic> message) async {
  var data = message['data'] ?? message;
  String expectedAttribute = data['expectedAttribute'];
  /// [...]
}

}