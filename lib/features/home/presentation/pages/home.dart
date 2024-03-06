import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_flutter/features/qr_scan/presentation/pages/qr_scan.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
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
                          Icons.qr_code_scanner_rounded
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
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/bg.jpg"
                          ),
                          fit: BoxFit.cover
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat("EEEE, d MMMM yyyy", "id").format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: "Muli"
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              iconMenu(
                                const Icon(Icons.person_rounded), 
                                "Profile"
                              ),
                              iconMenu(
                                const Icon(Icons.gps_fixed_rounded), 
                                "GPS"
                              ),
                              iconMenu(
                                const Icon(Icons.home_rounded), 
                                "Route"
                              ),
                              iconMenu(
                                const Icon(Icons.gamepad_rounded), 
                                "Play"
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
                                const Icon(Icons.book_rounded), 
                                "Document"
                              ),
                              iconMenu(
                                const Icon(Icons.warning_rounded), 
                                "Warning"
                              ),
                              iconMenu(
                                const Icon(Icons.browser_updated_rounded), 
                                "Online"
                              ),
                              iconMenu(
                                const Icon(Icons.shopping_bag_rounded), 
                                "Shop"
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iconMenu(Icon icon, String label){
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            Ink(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))
                ),
                shadows: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(2, 3)
                  ),
                ],
              ),
              child: IconButton(
                style: IconButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  )
                ),
                onPressed:() {},
                icon: icon,
                iconSize: 32,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              label
            )
          ],
        ),
      ),
    );
  }
}