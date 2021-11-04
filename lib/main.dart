import 'package:flutter/material.dart';
import 'package:flutter_intermediate/customsplash_screen.dart';
import 'package:flutter_intermediate/screen/auth_screen.dart';
import 'package:flutter_intermediate/screen/beranda_screen.dart';
import 'package:flutter_intermediate/screen/loginemailpass_screen.dart';
import 'package:flutter_intermediate/screen/logingoogle_screen.dart';
import 'package:flutter_intermediate/screen/loginmysql_screen.dart';
import 'package:flutter_intermediate/screen/loginphone_screen.dart';
import 'package:flutter_intermediate/screen/registeremailpass_screen.dart';
import 'package:flutter_intermediate/screen/registermysql_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: CustomSplashScreen.id, routes: {
      CustomSplashScreen.id: (context) => const CustomSplashScreen(),
      AuthScreen.id: (context) => const AuthScreen(),
      LoginEmailPassScreen.id: (context) => const LoginEmailPassScreen(),
      LoginGoogleScreen.id: (context) => const LoginGoogleScreen(),
      LoginPhoneScreen.id: (context) => const LoginPhoneScreen(),
      LoginMysqlScreen.id: (context) => const LoginMysqlScreen(),
      RegisterEmailPassScreen.id: (context) => const RegisterEmailPassScreen(),
      RegisterMysqlSCreen.id: (context) => const RegisterMysqlSCreen(),
      BerandaScreen.id: (context) => const BerandaScreen(),
    });
  }
}
