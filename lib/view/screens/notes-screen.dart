import 'package:flutter/material.dart';
import 'package:notes/helpers/helper.dart';
import 'package:notes/models/note.dart';
import 'package:notes/view-models/notes-viewmodel.dart';

class NotesScreen extends StatelessWidget {
  final String title;
  final Note note;
  NotesScreen({this.title, this.note});

  @override
  Widget build(BuildContext context) {
    final contentController = TextEditingController();
    if (note != null) {
      contentController.text = note.content;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          note == null ? title ?? '' : note.title,
          style: TextStyle(color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () {
                showCircularIndicator();
                if (note == null) {
                  NotesViewModel().createNote(title, contentController.text);
                } else {
                  note.content = contentController.text;
                  NotesViewModel().updateNote(note);
                }
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
