import 'package:flutter/material.dart';
import 'package:notes/main.dart';

void showSnackBar(String content) {
  ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(SnackBar(
    content: Text(content),
    action: SnackBarAction(
      onPressed: () {
        ScaffoldMessenger.of(navigatorKey.currentContext).hideCurrentSnackBar();
      },
      label: 'OK',
    ),
  ));
}

bool validateStructure(String value) {
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = new RegExp(pattern);
  return regExp.hasMatch(value);
}

void showCircularIndicator() {
  showDialog(
      context: navigatorKey.currentContext,
      builder: (ctx) {
        return Center(child: CircularProgressIndicator());
      });
}
