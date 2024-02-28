import 'package:flutter/material.dart';
import 'package:test_flutter/features/qr_scan/presentation/pages/qr_scan.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 30, right: 30, top: 80),
            alignment: Alignment.topCenter,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg.jpg"
                ),
                fit: BoxFit.cover
              )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed:() {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => const QRScanPage())
                        );
                      },
                      iconSize: 35,
                      color: Colors.white,
                      icon: const Icon(
                        Icons.qr_code_scanner
                      )
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                        "assets/images/cat.jpg"
                      )
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 170,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
                )
              ),
              child: Column(
                children: [
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          iconMenu(
                            const Icon(Icons.person), 
                            "Profile"
                          ),
                          iconMenu(
                            const Icon(Icons.gps_fixed), 
                            "GPS"
                          ),
                          iconMenu(
                            const Icon(Icons.home_filled), 
                            "Route"
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          iconMenu(
                            const Icon(Icons.book), 
                            "Document"
                          ),
                          iconMenu(
                            const Icon(Icons.warning), 
                            "Warning"
                          ),
                          iconMenu(
                            const Icon(Icons.browser_updated), 
                            "Online"
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ),
          )
        ],
      ),
    );
  }

  Widget iconMenu(Icon icon, String label){
    return Column(
      children: [
        IconButton(
          onPressed:() {},
          icon: icon,
          iconSize: 40,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          label
        )
      ],
    );
  }
}