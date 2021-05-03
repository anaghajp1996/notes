import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/helpers/helper.dart';
import 'package:notes/main.dart';
import 'package:notes/view-models/authentication-viewmodel.dart';
import 'package:notes/view/screens/notes-list-screen.dart';
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
                        final authentication = await AuthenticationViewModel()
                            .signInUser(
                                emailController.text, passwordController.text);
                        if (!authentication.isAuthenticated) {
                          showSnackBar(authentication.errorMessage ??
                              'Something went wrong. Please try again.');
                        }
                      }
                    } else {
                      // Sign up user
                      if ((validateStructure(passwordController.text))) {
                        final authentication = await AuthenticationViewModel()
                            .createUser(
                                emailController.text, passwordController.text);
                        if (!authentication.isAuthenticated) {
                          showSnackBar(authentication.errorMessage ??
                              'Something went wrong. Please try again.');
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'lib/images/google_icon.jpg',
                            width: 24,
                          ),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      onPressed: () async {
                        final authentication =
                            await AuthenticationViewModel().signInWithGoogle();
                        if (!authentication.isAuthenticated) {
                          showSnackBar(authentication.errorMessage ??
                              'Something went wrong. Please try again.');
                        }
                      }),
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
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data != null) {
              return NotesListScreen();
            }
            return signInScreenScaffold;
          }
        });
  }
}
