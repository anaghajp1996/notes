import 'package:flutter/material.dart';
import 'package:notes/helpers/helper.dart';
import 'package:notes/main.dart';
import 'package:notes/models/note.dart';
import 'package:notes/view-models/notes-viewmodel.dart';
import 'package:notes/view/screens/notes-screen.dart';

class NotesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          final titleController = TextEditingController();
          final formKey = GlobalKey<FormState>();
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('Enter the title of the note:'),
                  content: Form(
                    key: formKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                      controller: titleController,
                      validator: (String text) {
                        if (text.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          if (titleController.text.isEmpty) {
                            formKey.currentState.validate();
                          } else {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => NotesScreen(
                                      title: titleController.text,
                                    )));
                          }
                        },
                        child: Text('OK')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ))
                  ],
                );
              });
        },
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
              return Center(child: CircularProgressIndicator());
            } else {
              return snapshot.data.length == 0
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No notes found!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          Text(
                            'You can create one by using the + icon below',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, height: 2),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) {
                            final notes = snapshot.data;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notes[index].title.isEmpty
                                        ? notes[index].content
                                        : notes[index].title,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      notes[index].content,
                                      style: TextStyle(fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                    indent: 4,
                                    endIndent: 4,
                                  )
                                ],
                              ),
                            );
                          }),
                    );
            }
          }),
    );
  }
}
