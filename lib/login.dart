import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? email;
  String? password;
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
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    image: AssetImage("assets/images/flutter-icon.png")
                  )
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
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
                height: MediaQuery.of(context).size.height-250,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                        child: const Text(
                          "QR Login App",
                          style: TextStyle(
                            fontSize: 40,
                          ),
                        ),
                      ),
                      textInputField(
                        "Email", 
                        false,
                        (value){
                          email = value;
                        },
                        const Icon(Icons.mail_outline_rounded)
                      ),
                      textInputField(
                        "Password", 
                        true,
                        (value){
                          password = value;
                        },
                        const Icon(Icons.key_rounded)
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
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
                          : const Text('LOG IN'),
                          onPressed: () {
                            loginButtonAction(context, email!, password!);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ),
          ]
        ),
      ),
    );
  }

  void loginButtonAction(BuildContext context, String email, password) async {
    setState(() {
      isLoading = true;
    });

    try{
      String url = "http://172.20.8.136:8000/api/login/mobile";

      var response = await http.post(
        Uri.parse(url),
        body: {
          "email": email,
          "password": password
        }
      );

      if(response.statusCode == 200) {
        var data = jsonDecode(response.body);
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString('token', data['userId']);
        isLoading = false;
        
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Failed to login');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      const snackBar = SnackBar(
        content: Text('Failed to login'),
      );
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      
      return null;
    }
  }

  Widget textInputField(String text, bool fieldStatus, Function(String) value, Icon icon){
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: TextField(
        onChanged: value,
        obscureText: fieldStatus,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelText: text,
          prefixIcon: icon,
        ),
      ),
    );
  }
}

void _checkToken(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? storedToken = prefs.getString('token');

  if (storedToken != null && storedToken.isNotEmpty) {
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const HomeScreen())
    );
  }
}