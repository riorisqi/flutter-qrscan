import 'package:auto_height_grid_view/auto_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_flutter/features/qr_scan/presentation/pages/qr_scan.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_flutter/utils/constant.dart' as constants;

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
        child: Stack( // add singlechildscrollview when content already a lot
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
                      fontSize: 30,
                      fontWeight: FontWeight.bold
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
            Container(
              margin: const EdgeInsets.only(top: 150),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
                      color: constants.COLOR
                      // image: DecorationImage(
                      //   image: AssetImage(
                      //     "assets/images/bg.jpg"
                      //   ),
                      //   fit: BoxFit.cover
                      // ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat("EEEE, d MMMM yyyy", "id").format(DateTime.now()),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20 
                            ),
                          ),
                        ),
                        // Expanded(
                        //   child: Row(
                        //     children: [
                        //       const Expanded(
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               "Check in",
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 20,
                        //                 fontWeight: FontWeight.bold
                        //               ),
                        //             ),
                        //             Text(
                        //               "07:15",
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 20,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       const Expanded(
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.start,
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               "Check out",
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 20,
                        //                 fontWeight: FontWeight.bold
                        //               ),
                        //             ),
                        //             Text(
                        //               "-",
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 20,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       Expanded(
                        //         child: Container(
                        //           margin: const EdgeInsets.only(left: 10),
                        //           child: ElevatedButton(
                        //             style: ElevatedButton.styleFrom(
                        //               backgroundColor: Colors.white,
                        //               foregroundColor: constants.COLOR,
                        //               shape: RoundedRectangleBorder(
                        //                 borderRadius: BorderRadius.circular(20)
                        //               )
                        //             ),
                        //             onPressed: () {},
                        //             child: Container(
                        //               margin: const EdgeInsets.symmetric(vertical: 10),
                        //               child: const Text(
                        //                 "Check Out",
                        //                 textAlign: TextAlign.center,
                        //                 style: TextStyle(
                        //                   fontSize: 15
                        //                 ),
                        //               ),
                        //             )
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
                    child: AutoHeightGridView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 5,
                      crossAxisCount: 4,
                      itemCount: constants.allMenuItems.length,
                      builder:(context, index) {
                        final menuItem = constants.allMenuItems[index];
                        
                        return Material(
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Ink(
                                width: 70,
                                height: 70,
                                decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: const Color.fromARGB(255, 151, 133, 133).withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: const Offset(0, 5)
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                    )
                                  ),
                                  onPressed:() {
                                    Navigator.pushNamed(context, menuItem.routePage);
                                  },
                                  icon: Icon(menuItem.icon),
                                  iconSize: 36,
                                  color: constants.COLOR,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                menuItem.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}