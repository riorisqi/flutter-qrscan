import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:test_flutter/features/auth/authenticator/authenticator.dart';
import 'package:test_flutter/features/auth/login/login.dart';
import 'package:test_flutter/features/auth/qr_login/qr_login.dart';
import 'package:test_flutter/utils/constant.dart' as constants;

// for workmanager schedule refresh token
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';
// import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
  configEasyLoading();

  // for workmanager schedule refresh token
  // Workmanager().initialize(callbackDispatcher);
}

// for workmanager schedule refresh token
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     String url = "http://10.0.2.2:8000/api/auth/refreshToken";
    
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     String? token = pref.getString('access_token');

//     var response = await http.post(
//       Uri.parse(url),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token"
//       }
//     );
    
//     if(response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       pref.setString('access_token', data['access_token']);
//     }

//     return Future.value(true);
//   });
// }

void configEasyLoading(){
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..maskType = EasyLoadingMaskType.black;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: constants.COLOR,
        useMaterial3: true,
      ),
      // darkTheme: ThemeData(
      //   useMaterial3: true,
      //   brightness: Brightness.dark,
      //   colorSchemeSeed: constants.COLOR
      // ),
      // themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      builder: EasyLoading.init(),
      routes: {
        '/qrlogin': (context) => const QRLoginPage(),
        '/authenticator': (context) => const AuthenticatorPage()
      },
    );
  }
}
