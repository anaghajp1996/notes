import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/helpers/helper.dart';
import 'package:notes/models/note.dart';
import 'package:notes/view-models/notes-viewmodel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class NotesScreen extends StatefulWidget {
  final String title;
  final Note note;
  NotesScreen({this.title, this.note});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final picker = ImagePicker();

  File _imageFile;
  Image _image;

  Future getImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _image = Image.file(_imageFile);
      } else {
        showSnackBar('No image selected');
      }
    });
  }

  final contentController = TextEditingController();
  bool init = true;

  @override
  Widget build(BuildContext context) {
    if (init) {
      contentController.text = widget.note == null ? '' : widget.note.content;
      init = false;
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () {
          getImage();
        },
        child: Icon(
          Icons.image,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
        title: Text(
          widget.note == null ? widget.title ?? '' : widget.note.title,
          style: TextStyle(color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.done),
              onPressed: () async {
                String uploadedImagePath;
                showCircularIndicator();
                if (_image != null) {
                  final reference = firebase_storage.FirebaseStorage.instance
                      .ref(_imageFile.path);
                  final uploadedFile = firebase_storage.FirebaseStorage.instance
                      .ref(reference.fullPath)
                      .putFile(_imageFile);
                  uploadedImagePath = reference.fullPath;
                }
                if (widget.note == null) {
                  NotesViewModel().createNote(
                      widget.title, contentController.text, uploadedImagePath);
                } else {
                  widget.note.content = contentController.text;
                  NotesViewModel().updateNote(widget.note);
                }
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              })
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              widget.note == null
                  ? _image == null
                      ? Container()
                      : Expanded(child: Image.file(_imageFile))
                  : FutureBuilder(
                      future: firebase_storage.FirebaseStorage.instance
                          .ref(widget.note.imagePath)
                          .getDownloadURL(),
                      builder: (_, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          return snapshot.data == null
                              ? Container()
                              : Expanded(
                                  flex: 1, child: Image.network(snapshot.data));
                        }
                      }),
              SizedBox(
                height: 16,
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: contentController,
                  cursorColor: Colors.black,
                  decoration: InputDecoration.collapsed(hintText: ''),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
