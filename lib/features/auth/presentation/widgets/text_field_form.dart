import 'package:flutter/material.dart';

Widget textFieldForm(
  TextEditingController controller,
  String? Function(String?)? validator,
  String label, Widget icon, bool obscureText
){
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      labelText: label,
      prefixIcon: icon,
    ),
  );
}