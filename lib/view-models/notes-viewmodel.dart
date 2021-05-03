import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/main.dart';
import 'package:notes/models/note.dart';

class NotesViewModel {
  Future<List<Note>> getNotes() async {
    List<Note> notes = [];
    final notesSnapshot = await firestore
        .collection('users')
        .doc(auth.currentUser.uid)
        .collection('notes')
        .get();
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
}
