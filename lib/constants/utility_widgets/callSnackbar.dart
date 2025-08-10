import 'package:flutter/material.dart';

class CallSnackbar {
  void callSnackbar(BuildContext context, String content) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(content)));
  }
}
