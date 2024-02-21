import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  Barcode? scanResult;
  QRViewController? qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    } else if (Platform.isIOS) {
      qrController!.resumeCamera();
    }
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          // Container(
          //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       minimumSize: const Size.fromHeight(50),
          //       backgroundColor: Colors.white,
          //       foregroundColor: Colors.black,
          //       side: const BorderSide(
          //         color: Colors.red
          //       ),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10)
          //       )
          //     ),
          //     onPressed:() {
          //       String key = "ezObA8FY9zGpSa0Q1Ljgd1mXjvVRqq";
          //       _loginRequestApi("http://172.20.8.136:8000/api/login/mobile/scan/qrcode?key=$key&type=1");
          //     },
          //     child: const Text('QR SCAN LOGIN'),
          //   ),
          // ),
          Expanded(
            flex: 5,
            child: _buildQrView(context)
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 200 ||
            MediaQuery.of(context).size.height < 200)
        ? 250.0
        : 300.0;

    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blueAccent,
          borderRadius: 0,
          borderLength: 30,
          borderWidth: 15,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        scanResult = scanData;
        _loginRequestApi(scanResult!.code!);
      });
    });
  }

  void _loginRequestApi(String data) async {
    try{
      EasyLoading.show(
        status: "Please wait..."
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedToken = prefs.getString('token');

      Map<String, String> headers = {
        'userpasscode': storedToken!,
      };

      final response = await http.post(
        Uri.parse(data),
        headers: headers
      );

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        var loginQrApi = data['msg'];

        final responseQR = await http.post(
          Uri.parse(loginQrApi.toString()),
          headers: headers
        );

        if(responseQR.statusCode == 200){
          EasyLoading.showSuccess(
            'Login Success',
            dismissOnTap: true
          );
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        } else {
          EasyLoading.showError(
            'Failed to login',
            dismissOnTap: true
          );
        }
      }
    } catch (e){
      EasyLoading.showError(
        'Failed to login',
        dismissOnTap: true
      );
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      EasyLoading.showError(
        'No Permission',
        dismissOnTap: true
      );
    }
  }

  @override
  void dispose() {
    qrController!.dispose();
    super.dispose();
  }
}