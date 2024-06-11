import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/main.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../configs.dart';

Future<void> initOneSignal() async {
  OneSignal.initialize(ONESIGNAL_APP_ID);
  OneSignal.Notifications.requestPermission(true);
  OneSignal.User.pushSubscription.optIn();
  saveOneSignalPlayerId();

  OneSignal.Notifications.addForegroundWillDisplayListener((event) {
    OneSignal.Notifications.displayNotification(event.notification.notificationId);
    return event.notification.display();
  });
  OneSignal.User.pushSubscription.addObserver((stateChanges) async {
    if (stateChanges.current.id.validate().isNotEmpty) {
      appStore.setPlayerId(stateChanges.current.id.validate());
    }
  });
}

Future<void> saveOneSignalPlayerId() async {
  if (appStore.isLoggedIn) {
    await OneSignal.login(appStore.userId.toString()).then((value) {
      if (OneSignal.User.pushSubscription.id.validate().isNotEmpty) {
        appStore.setPlayerId(OneSignal.User.pushSubscription.id.validate());
      }
    }).catchError((e) {
      log('Error saving subscription id - $e');
    });
  }
}
