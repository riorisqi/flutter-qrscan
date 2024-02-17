import 'package:flutter/material.dart';
import 'package:test_flutter/qr_scan.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("QR Code Login App"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 40),
              ),
              textInputField(
                "Email", 
                false,
                (value){
                  email = value;
                }
              ),
              textInputField(
                "Password", 
                true,
                (value){
                  password = value;
                }
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Log In'),
                  onPressed: () {
                    loginButtonAction();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginButtonAction(){
    if (email!.isNotEmpty && password!.isNotEmpty){
        Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const QRScanPage()),
      );
    } else {
      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Email atau Password tidak boleh kosong'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget textInputField(String text, bool fieldStatus, Function(String) value){
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      child: TextField(
        onChanged: value,
        obscureText: fieldStatus,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(90.0),
          ),
          labelText: text,
        ),
      ),
    );
  }
}