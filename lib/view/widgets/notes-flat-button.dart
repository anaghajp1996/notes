import 'package:flutter/material.dart';

class NotesFlatButton extends StatelessWidget {
  final Function onPressed;
  final String title;
  NotesFlatButton({@required this.onPressed, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onPressed,
            child: Text(title),
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.yellow,
              primary: Colors.black,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32))),
            ),
          ),
        ),
      ],
    );
  }
}
