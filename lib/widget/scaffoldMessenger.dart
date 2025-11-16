import 'package:flutter/material.dart';

class MySnackbar {
  static void popUp(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(msg)),
    );
  }
}
