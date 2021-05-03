import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/main.dart';
import 'package:notes/models/note.dart';

class NotesViewModel {
  List<Note> getNotes(QuerySnapshot notesSnapshot) {
    List<Note> notes = [];
    final notesMap = notesSnapshot.docs;
    for (var key in notesMap) {
      final data = key.data();
      final createdOn = data['createdOn'] as Timestamp;
      final lastEditedOn = data['lastEditedOn'] as Timestamp;
      String imagePath;
      try {
        imagePath = data['imagePath'];
      } catch (e) {
        print(e);
      }
      final note = Note(
          id: key.id,
          content: data['content'],
          title: data['title'],
          createdOn: DateTime.fromMicrosecondsSinceEpoch(
              createdOn.microsecondsSinceEpoch),
          lastEditedOn: DateTime.fromMicrosecondsSinceEpoch(
              lastEditedOn.microsecondsSinceEpoch),
          imagePath: imagePath);
      notes.add(note);
    }
    return notes ?? [];
  }

  Future createNote(String title, String content, String imagePath) async {
    final _ = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('notes')
        .add({
      'title': title,
      'content': content,
      'createdOn': DateTime.now(),
      'lastEditedOn': DateTime.now(),
      'imagePath': imagePath
    });
  }

  Future updateNote(Note note) async {
    final _ = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('notes')
        .doc(note.id)
        .update({
      'title': note.title,
      'content': note.content,
      'createdOn': note.createdOn,
      'lastEditedOn': DateTime.now()
    });
  }
}
