import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/main.dart';
import 'package:notes/models/note.dart';

class NotesViewModel {
  List<Note> getNotes(QuerySnapshot notesSnapshot) {
    List<Note> notes = [];
    final notesMap = notesSnapshot.docs;
    notesMap.forEach((key) {
      final createdOn = key['createdOn'] as Timestamp;
      final lastEditedOn = key['lastEditedOn'] as Timestamp;
      final note = Note(
          id: key.id,
          content: key['content'],
          title: key['title'],
          createdOn: DateTime.fromMicrosecondsSinceEpoch(
              createdOn.microsecondsSinceEpoch),
          lastEditedOn: DateTime.fromMicrosecondsSinceEpoch(
              lastEditedOn.microsecondsSinceEpoch));
      notes.add(note);
    });
    return notes ?? [];
  }

  Future createNote(String title, String content) async {
    final _ = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('notes')
        .add({
      'title': title,
      'content': content,
      'createdOn': DateTime.now(),
      'lastEditedOn': DateTime.now()
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
