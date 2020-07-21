import 'package:flutter/material.dart';

class PushToNextPage {
  static Future<void> push(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }
}
