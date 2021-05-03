import 'package:flutter/material.dart';
import 'package:notes/helpers/helper.dart';
import 'package:notes/view-models/notes-viewmodel.dart';

class NotesScreen extends StatelessWidget {
  final String title;
  NotesScreen({this.title});

  @override
  Widget build(BuildContext context) {
    final contentController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title ?? '',
          style: TextStyle(color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                showCircularIndicator();
                NotesViewModel().createNote(title, contentController.text);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: contentController,
                cursorColor: Colors.black,
                decoration: InputDecoration.collapsed(hintText: ''),
              ),
            )
          ],
        ),
      ),
    );
  }
}
