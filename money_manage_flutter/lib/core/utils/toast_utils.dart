import 'package:fluttertoast/fluttertoast.dart';

import 'package:flutter/material.dart';

class ToastUtils {
  static showToastSuccess(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_LONG
    );
  }

  static showToastFailed(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: Colors.red,
      toastLength: Toast.LENGTH_LONG
    );
  }

  static showToastLoadingData(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      backgroundColor: Colors.orange,
      toastLength: Toast.LENGTH_LONG
    );
  }
}
