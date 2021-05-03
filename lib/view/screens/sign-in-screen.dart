import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
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
                'Notes',
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                '\nSave your notes and access then from anywhere!',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 64),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: NotesTextField(
                  controller: emailController,
                  hintText: 'Email',
                  validate: (String text) {
                    if (signInScreen) {
                      return null;
                    }
                    if (EmailValidator.validate(text)) {
                      return null;
                    } else {
                      return 'Please enter a valid email ID';
                    }
                  },
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
              signInScreen
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: TextButton(
                            onPressed: () {
                              final emailController = TextEditingController();
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text(
                                          'Please enter the email ID to which a password resent link should be sent:'),
                                      content: TextFormField(
                                        decoration: InputDecoration(
                                            border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black))),
                                        controller: emailController,
                                        validator: (String text) {
                                          if (text.isEmpty) {
                                            return 'Please enter an email ID.';
                                          } else if (!EmailValidator.validate(
                                              text)) {
                                            return 'Please enter a valid email ID.';
                                          }
                                          return null;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Cancel',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )),
                                        TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              auth.sendPasswordResetEmail(
                                                  email: emailController.text);
                                            },
                                            child: Text('OK'))
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                            )),
                      ),
                    )
                  : Container(),
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
