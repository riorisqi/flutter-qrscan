import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Scan QR Code"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 200 ||
            MediaQuery.of(context).size.height < 100)
        ? 250.0
        : 330.0;

    return QRView(
      key: _qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blueAccent,
        borderRadius: 15,
        borderLength: 30,
        borderWidth: 15,
        cutOutSize: scanArea
      ),
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
    qrController!.pauseCamera();

    String scanTime = DateTime.now().toString();
    String? deviceId = await _getId();

    EasyLoading.show(
      status: "Please wait..."
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    String? storedUserQrPasscode = prefs.getString('user_qr_passcode');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'userpasscode': storedUserQrPasscode!
    };

    final response = await http.post(
      Uri.parse("$data&scanTime=$scanTime&deviceInfo=$deviceId"),
      headers: headers
    );

    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      var loginQrApi = data['msg'];

      final responseQR = await http.post(
        Uri.parse(loginQrApi.toString()),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken'
        }
      );

      if(responseQR.statusCode == 200){
        qrController!.resumeCamera();

        EasyLoading.showSuccess(
          'Login Success',
          dismissOnTap: true
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        qrController!.resumeCamera();

        EasyLoading.showError(
          'Failed to login',
          dismissOnTap: true
        );
      }
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

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
    
    return null;
  }

  @override
  void dispose() {
    qrController!.dispose();
    super.dispose();
  }
}