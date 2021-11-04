import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intermediate/argument/adaptive_argument.dart';
import 'package:flutter_intermediate/customsplash_screen.dart';
import 'package:flutter_intermediate/screen/adaptive_screen.dart';
import 'package:flutter_intermediate/screen/auth_screen.dart';
import 'package:flutter_intermediate/screen/beranda_screen.dart';
import 'package:flutter_intermediate/screen/detaildevice_screen.dart';
import 'package:flutter_intermediate/screen/loginemailpass_screen.dart';
import 'package:flutter_intermediate/screen/loginmysql_screen.dart';
import 'package:flutter_intermediate/screen/loginphone_screen.dart';
import 'package:flutter_intermediate/screen/registeremailpass_screen.dart';
import 'package:flutter_intermediate/screen/registermysql_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        });
  }
}
