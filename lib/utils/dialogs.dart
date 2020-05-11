import 'package:flutter/material.dart';

class AlertDialogApp {
  static showSnackBar(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }

  static showAlertDialog(
      String title, String message, BuildContext context, Function successFn,
      [Function cancelFn]) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                successFn();
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                if (cancelFn != null) {
                  cancelFn();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
