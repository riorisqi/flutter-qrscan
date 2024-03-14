import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:test_flutter/features/auth/presentation/pages/login.dart';
import 'package:test_flutter/utils/background_widget.dart';
// import 'package:workmanager/workmanager.dart';
import 'package:test_flutter/utils/constant.dart' as constants;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
        elevation: 4,
        onPressed: () {
          logoutButtonAction();
        },
        icon: const Icon(Icons.exit_to_app),
        label: const Text("Logout"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: SingleChildScrollView(
        child: Stack(
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
                              fontSize: 16
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
            Positioned(
              top: 180,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)
                  )
                ),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text("Profile"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                    const Divider(height: 1,),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text("Settings"),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void logoutButtonAction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('access_token');

    try{
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
      } else {
        EasyLoading.showError(
          'Logout Failed',
          dismissOnTap: true
        );
      }
    } catch (e) {
      EasyLoading.showError(
        'Logout Failed',
        dismissOnTap: true
      );
      
      return null;
    }
  }
}