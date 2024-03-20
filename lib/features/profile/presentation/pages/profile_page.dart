import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:test_flutter/features/auth/presentation/pages/login.dart';
import 'package:test_flutter/features/profile/presentation/pages/profile_detail_page.dart';
import 'package:test_flutter/utils/background_widget.dart';
import 'package:test_flutter/utils/constant.dart' as constants;

// for workmanager cancel schedule refresh token
// import 'package:workmanager/workmanager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // add singlechildscrollview when content already a lot
        children: [
          backgroundWidget(
            context,
            Container(
              margin: const EdgeInsets.only(top: 70),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CircleAvatar(
                      radius: 38,
                      backgroundImage: AssetImage(
                        "assets/images/cat.jpg"
                      )
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Rio Risqi Akbar Herlambang",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Programmer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 170),
            height: MediaQuery.of(context).size.height, // delete/comment this when the content already a lot
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              )
            ),
            child: ListView(
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                listTile(Icons.person, "Profile", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileDetailPage())
                  );
                }),
                const SizedBox(height: 8),
                listTile(Icons.settings, "Settings", () {}),
                const SizedBox(height: 8),
                listTile(Icons.exit_to_app, "Logout", () {
                  showAlertDialog(context);
                })
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget listTile(IconData icon, String text, void Function()? onTap){
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: constants.COLOR,),
          title: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500
            ),
          ),
          trailing: const Icon(Icons.keyboard_arrow_right)
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Yes"),
      onPressed:  () {
        logoutButtonAction();
      },
    );

    AlertDialog alert = AlertDialog(
      icon: const Icon(Icons.warning_rounded, color: Colors.red,),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void logoutButtonAction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('access_token');

    EasyLoading.show(
      status: "Please wait..."
    );

    String url = "${constants.HTTP_API_HOST}/api/auth/logout";

    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $accessToken'
    };

    var response = await http.post(
      Uri.parse(url),
      headers: headers
    );

    if(response.statusCode == 200) {
      prefs.clear();
      
      // for workmanager cancel schedule refresh token
      // Workmanager().cancelAll();

      EasyLoading.showSuccess(
        'Logout Success',
        dismissOnTap: true
      );

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else if(response.statusCode == 401) {
      _refreshToken(accessToken!);
    } else {
      EasyLoading.showError(
        'Logout Failed',
        dismissOnTap: true
      );
    }
  }

  void _refreshToken(String jwtToken) async {
    String url = "${constants.HTTP_API_HOST}/api/auth/refreshToken";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $jwtToken"
      }
    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('access_token', data['access_token']);

      logoutButtonAction();
    } else {
      EasyLoading.showError(
        'Failed to login',
        dismissOnTap: true
      );
    }
  }
}