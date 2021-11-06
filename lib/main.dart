import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/argument/adaptive_argument.dart';
import 'package:flutter_intermediate/customsplash_screen.dart';
import 'package:flutter_intermediate/screen/adaptive_screen.dart';
import 'package:flutter_intermediate/screen/auth_screen.dart';
import 'package:flutter_intermediate/screen/beranda_screen.dart';
import 'package:flutter_intermediate/screen/chat_screen.dart';
import 'package:flutter_intermediate/screen/detaildevice_screen.dart';
import 'package:flutter_intermediate/screen/loginemailpass_screen.dart';
import 'package:flutter_intermediate/screen/loginmysql_screen.dart';
import 'package:flutter_intermediate/screen/loginphone_screen.dart';
import 'package:flutter_intermediate/screen/registeremailpass_screen.dart';
import 'package:flutter_intermediate/screen/registermysql_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: (settings) {
          if (settings.name == DetailDeviceScreen.id) {
            AdaptiveArgument argument = settings.arguments as AdaptiveArgument;
            return MaterialPageRoute(builder: (contxt) {
              return DetailDeviceScreen(
                deviceType: argument.deviceType,
                joke: argument.joke,
              );
            });
          }
        },
        initialRoute: CustomSplashScreen.id,
        routes: {
          CustomSplashScreen.id: (context) => const CustomSplashScreen(),
          AuthScreen.id: (context) => AuthScreen(),
          LoginEmailPassScreen.id: (context) => const LoginEmailPassScreen(),
          LoginPhoneScreen.id: (context) => const LoginPhoneScreen(),
          LoginMysqlScreen.id: (context) => const LoginMysqlScreen(),
          RegisterEmailPassScreen.id: (context) =>
              const RegisterEmailPassScreen(),
          RegisterMysqlSCreen.id: (context) => const RegisterMysqlSCreen(),
          BerandaScreen.id: (context) => const BerandaScreen(),
          AdaptiveScreen.id: (context) => const AdaptiveScreen(),
          ChatScreen.id: (context) => const ChatScreen(),
        });
  }
}
