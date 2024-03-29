import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter/features/auth/login/widgets/text_field_form.dart';
import 'package:test_flutter/features/bottom_navbar.dart';
import 'package:test_flutter/utils/background_widget.dart';
import 'package:test_flutter/utils/constant.dart' as constants;

// for workmanager schedule refresh token
// import 'package:workmanager/workmanager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    _checkToken(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              backgroundWidget(
                context,
                Container()
              ),
              loginForm(),
            ]
          ),
        ),
      ),
    );
  }

  Widget loginForm(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 5
          )
        ]
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: const Text(
              "Login",
              style: TextStyle(
                fontSize: 40,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: const Text(
              "Enter email and password",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  textFieldForm(
                    email,
                    (text){
                      final bool emailValid = 
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text!);

                      if(text.isEmpty){
                        return 'Email address can\'t be empty';
                      }

                      if(!emailValid){
                        return 'Email address is not valid';
                      }
                  
                      return null;
                    },
                    "Email",
                    const Icon(Icons.mail_outline_rounded),
                    false
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  textFieldForm(
                    password,
                    (text){
                      if(text!.isEmpty){
                        return 'Password can\'t be empty';
                      }
                      return null;
                    },
                    "Password",
                    const Icon(Icons.key_rounded),
                    true
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(right: 15),
          //   child: Align(
          //     alignment: Alignment.centerRight,
          //     child: TextButton(
          //       onPressed: (){}, 
          //       child: const Text("Recover Password")
          //     ),
          //   ),
          // ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: constants.COLOR,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              onPressed: () {
                if(_formkey.currentState!.validate()){
                  loginButtonAction(email.text, password.text);
                }
              },
              child: isLoading ?
                Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Text('LOGIN'),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.fromLTRB(30, 0, 30, 20),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Container(
          //           margin: const EdgeInsets.only(right: 10),
          //           child: const Divider()
          //         )
          //       ),
          //       const Text("OR"),
          //       Expanded(
          //         child: Container(
          //           margin: const EdgeInsets.only(left: 10),
          //           child: const Divider()
          //         )
          //       )
          //     ],
          //   )
          // ),
          // Container(
          //   margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       minimumSize: const Size.fromHeight(50),
          //       backgroundColor: Colors.white,
          //       foregroundColor: Colors.black,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10)
          //       )
          //     ),
          //     child: const Text('LOGIN WITH SSO'),
          //     onPressed: () {},
          //   ),
          // ),
        ],
      ),
    );
  }

  void loginButtonAction(String email, String password) async {
    setState(() {
      isLoading = true;
    });

    String url = "${constants.HTTP_API_HOST}/api/auth/login";
    
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {
          "email": email,
          "password": password
        }
      )
    );

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('access_token', data['access_token']);
      pref.setString('user_qr_passcode', data['user_qr_passcode']);
      isLoading = false;

      // for workmanager schedule refresh token
      // Workmanager().registerPeriodicTask(
      //   "tokenRefreshTask",
      //   "tokenRefresh",
      //   frequency: const Duration(days: 1),
      // );
      
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const BottomNavBar(),
          transitionDuration: const Duration(milliseconds: 500),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ),
      );

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Login Failed'),
      );
      
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      throw Exception('Failed to login');
    }
  }

  void _checkToken(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('access_token');

    if (storedToken != null && storedToken.isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => const BottomNavBar())
      );
    }
  }
}
