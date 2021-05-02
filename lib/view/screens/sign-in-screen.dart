import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (ctx, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Container()
            : Scaffold(
                appBar: AppBar(
                  title: Text('Sign In'),
                ),
              );
      },
    );
  }
}
