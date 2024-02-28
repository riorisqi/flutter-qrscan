import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter/features/bottom_navbar.dart';

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
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/bg.jpg"
                    ),
                    fit: BoxFit.cover
                  )
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
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 30, 0, 10),
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
                          "Enter username and password",
                          style: TextStyle(
                            fontSize: 16,
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
                        margin: const EdgeInsets.only(right: 15),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: (){}, 
                            child: const Text("Recover Password")
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                          : const Text('Login'),
                          onPressed: () {
                            loginButtonAction(context, email!, password!);
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(30, 0, 30, 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Divider()
                              )
                            ),
                            const Text("or"),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: const Divider()
                              )
                            )
                          ],
                        )
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          child: const Text('Login with SSO'),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ]
          ),
        ),
      ),
    );
  }

  void loginButtonAction(BuildContext context, String email, password) async {
    setState(() {
      isLoading = true;
    });

    String url = "http://10.0.2.2:8000/api/auth/login";
    try{
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
        pref.setString('user_qr_token', data['user_qr_token']);
        isLoading = false;
        
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavBar()),
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

      var snackBar = SnackBar(
        content: Text('Failed to login: $e'),
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
  String? storedToken = prefs.getString('access_token');

  if (storedToken != null && storedToken.isNotEmpty) {
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const BottomNavBar())
    );
  }
}