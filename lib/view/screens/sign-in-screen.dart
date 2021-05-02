import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/helpers/helper.dart';
import 'package:notes/main.dart';
import 'package:notes/view/screens/notes-screen.dart';
import 'package:notes/view/widgets/notes-flat-button.dart';
import 'package:notes/view/widgets/notes-text-field.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool signInScreen = true;
  bool isPasswordValidated = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final signInScreenScaffold = Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 64),
              Text(
                'Hello!',
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 64),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: NotesTextField(
                  controller: emailController,
                  hintText: 'Email',
                ),
              ),
              NotesTextField(
                controller: passwordController,
                isPasswordField: true,
                hintText: 'Password',
                validate: (String text) {
                  if (signInScreen) {
                    return null;
                  }
                  if (validateStructure(text)) {
                    return null;
                  } else {
                    return 'Your password should be more than 8 characters long, and contain at least one uppercase, lowercase, numberic, and special character.';
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: NotesFlatButton(
                  onPressed: () async {
                    showCircularIndicator();
                    if (signInScreen) {
                      // Sign in user
                      if (passwordController.text.isNotEmpty) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            showSnackBar('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            showSnackBar(
                                'Wrong password provided for that user.');
                          }
                        } catch (e) {
                          showSnackBar('Something went wrong!');
                        }
                      }
                    } else {
                      // Sign up user
                      if ((validateStructure(passwordController.text))) {
                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showSnackBar('Password is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            showSnackBar(
                                'An account already exists for that email.');
                          }
                        } catch (e) {
                          showSnackBar(e);
                        }
                      }
                    }
                    passwordController.clear();
                    Navigator.of(context).pop();
                  },
                  title: signInScreen ? 'Sign In' : 'Sign Up',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(signInScreen
                      ? 'Don\'t have an account? '
                      : 'Already have an account?'),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          signInScreen = !signInScreen;
                        });
                      },
                      child: Text(
                        signInScreen ? 'Sign Up' : 'Sign In',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );

    return StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data != null) {
              return NotesScreen();
            }
            return signInScreenScaffold;
          }
        });
  }
}
