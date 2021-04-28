import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/TextFields/MyTextFormField.dart';
import 'package:notenverwaltung/authentication_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailAdress = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Email',
          ),
          MyTextFormField(
            controller: emailAdress,
            labelText: 'Email',
            validator: (String value) {
              if (value.isEmpty) {
                return 'Gib die Email ein';
              }
              return null;
            },
            textAlign: TextAlign.left,
            autocorrect: false,
            onChanged: (text) {
              print(text);
            },
          ),
          MyTextFormField(
            controller: password,
            labelText: 'Password',
            validator: (String value) {
              if (value.isEmpty) {
                return 'Gib den Password ein';
              }
              return null;
            },
            textAlign: TextAlign.left,
            autocorrect: false,
            onChanged: (text) {
              print(text);
            },
          ),
          RaisedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                  email: emailAdress.text.trim(),
                  password: password.text.trim());
            },
            child: Text("Sign in"),
          )
        ],
      ),
    );
  }
}
