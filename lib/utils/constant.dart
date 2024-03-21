// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'package:test_flutter/utils/menu_item.dart';

// const String HTTP_API_HOST_EMU = "http://10.0.2.2:8000";
const String HTTP_API_HOST = "http://10.0.2.2:8000";
const String BACKGROUND_IMG = "assets/images/bg.jpg";
const Color COLOR = Color.fromARGB(255, 4, 77, 162);

// for search test
final List<MenuItem> allMenuItems = [
  MenuItem(name: 'Profile', icon: Icons.person, routePage: "/profile"),
  MenuItem(name: 'QR Login', icon: Icons.qr_code_scanner, routePage: "/qrlogin"),
  MenuItem(name: 'Authenticator', icon: Icons.key_rounded, routePage: "/authenticator"),
  MenuItem(name: 'Play', icon: Icons.gamepad_rounded, routePage: "/play"),
  MenuItem(name: 'Document', icon: Icons.book_rounded, routePage: "/document"),
  MenuItem(name: 'Warning', icon: Icons.warning_rounded, routePage: "/warning"),
  MenuItem(name: 'Online', icon: Icons.browser_updated_rounded, routePage: "/online"),
  MenuItem(name: 'Shop', icon: Icons.shopping_bag_rounded, routePage: "/shop"),
];