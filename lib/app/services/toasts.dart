import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class Toasts {
  static getErrorToast({required String? text, Toast toastLength = Toast.LENGTH_SHORT}) async {
    if (text == null) {
      return;
    }
    return await Fluttertoast.showToast(
        msg: text ?? "Please try again Toasts",
        toastLength: toastLength,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16);
  }

  static getSuccessToast({@required String? text, Toast toastLength = Toast.LENGTH_SHORT}) async {
    if (text == null) {
      return;
    }
    await Fluttertoast.showToast(
        msg: text ?? "Please try again Toasts",
        toastLength: toastLength,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Color(0xFFD42129),
        textColor: Colors.white,
        fontSize: 16);
  }

  static getWarningToast({@required String? text, Toast toastLength = Toast.LENGTH_SHORT}) async {
    if (text == null) {
      return;
    }
    await Fluttertoast.showToast(
        msg: text ?? "Please try again Toasts.",
        toastLength: toastLength,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 16);
  }
}