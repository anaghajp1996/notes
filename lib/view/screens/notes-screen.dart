import 'package:flutter/material.dart';
import 'package:notes/helpers/helper.dart';
import 'package:notes/main.dart';
import 'package:notes/models/note.dart';
import 'package:notes/view-models/notes-viewmodel.dart';

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(auth.currentUser.email ?? ''),
              decoration: BoxDecoration(
                color: Colors.yellow,
              ),
            ),
            ListTile(
              title: Text('Reset Password'),
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        content: Text(
                            'A password reset link will be sent to your email ID, ${auth.currentUser.email}. You will be signed out so you can sign back in with your new password.'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                showCircularIndicator();
                                await auth.sendPasswordResetEmail(
                                    email: auth.currentUser.email);
                                Navigator.of(context).pop();
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        content: Text(
                                            'A password reset link has been sent to your email ID, ${auth.currentUser.email}. Follow the instructions in the email to reset your password.'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                auth.signOut();
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: Colors.yellow),
                                              ))
                                        ],
                                      );
                                    });
                              },
                              child: Text('OK'))
                        ],
                      );
                    });
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () {
                auth.signOut();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
          future: NotesViewModel().getNotes(),
          builder: (context, AsyncSnapshot<List<Note>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {
              return snapshot.data.length == 0
                  ? Center(
                      child: Text(
                      'No notes found\nCreate a note from the + button!',
                      textAlign: TextAlign.center,
                    ))
                  : ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (_, index) {
                        return Container();
                      });
            }
          }),
    );
  }
}
