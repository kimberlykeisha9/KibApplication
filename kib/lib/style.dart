import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
