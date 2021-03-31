import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DartHelper {

  static void showToast({String message}) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black.withOpacity(0.6),
        textColor: Colors.white);
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static String getCurrentDate() {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return formattedDate;
  }

  static String geDateFrom(int timeStamp) {
    var date = DateTime.fromMicrosecondsSinceEpoch(timeStamp);
    var dateParse = DateTime.parse(date.toString());
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return formattedDate;
  }

  static int getCurrentTimeStamp() {
    return DateTime.now().microsecondsSinceEpoch;
  }
}
