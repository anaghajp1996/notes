import 'package:flutter/material.dart';

class NotesTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isPasswordField;
  final String hintText;
  final Function validate;

  NotesTextField(
      {this.controller,
      this.isPasswordField = false,
      @required this.hintText,
      this.validate});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(
          color: Colors.black,
        ));
    final enabledBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(
          color: Colors.yellow,
        ));
    final GlobalKey<FormState> _formKey = GlobalKey();
    return Form(
      key: _formKey,
      child: TextFormField(
        onChanged: (String _) {
          _formKey.currentState.validate();
        },
        validator: (String text) {
          if (validate == null) {
            return null;
          }
          return validate(text);
        },
        controller: controller,
        obscureText: isPasswordField,
        decoration: InputDecoration(
            hintText: hintText,
            errorMaxLines: 5,
            border: border,
            enabledBorder: border,
            focusedBorder: enabledBorder),
      ),
    );
  }
}
