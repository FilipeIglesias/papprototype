import 'package:flutter/material.dart';

Widget InputField(
    String hint, IconData icon, TextEditingController controller,
    {bool obscureText = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    ),
  );
}