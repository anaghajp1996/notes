import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/main.dart';
import 'package:notes/models/note.dart';

class NotesViewModel {
  Future<List<Note>> getNotes() async {
    List<Note> notes = [];
    final notesSnapshot =
        await firestore.collection('users').doc(auth.currentUser.uid).get();
    final notesMap = notesSnapshot.data();
    notesMap.forEach((key, value) {
      final notesList = value as List;
      if (notesList != null) {
        if (notesList.isNotEmpty) {
          //
        }
      }
    });
    return notes ?? [];
  }
}
