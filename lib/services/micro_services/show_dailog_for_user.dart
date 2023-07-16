import 'package:flutter/material.dart';

Future<dynamic> showStateDialog(
    BuildContext context, String state, String message, Color color) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(state, style: TextStyle(color: color)),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
