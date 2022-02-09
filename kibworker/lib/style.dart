import 'package:flutter/material.dart';

Color green = const Color(0xFF00AC7C);
Color light = const Color(0xFFFFFFFF);
Color dark = const Color(0xFF000000);

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
