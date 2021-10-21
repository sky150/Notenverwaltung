import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notenverwaltung/UI/home/home_screen.dart';
//import 'package:notenverwaltung/UI/TextFields/MyTextFormField.dart';
import 'package:notenverwaltung/authentication_service.dart';
import 'package:notenverwaltung/global.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController emailAdress = TextEditingController();
  TextEditingController password = TextEditingController();
  User user;

  @override
  Widget build(BuildContext context) {
    void click() {
      signInWithGoogle().then((user) => {this.user = user});
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            Hero(
              tag: 'hero',
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 48.0,
                child: Image.asset('assets/icons/logo.png'),
              ),
            ),
            SizedBox(height: 48.0),
            TextFormField(
              controller: emailAdress,
              keyboardType: TextInputType.emailAddress,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Email',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Gib die Email ein';
                }
                return null;
              },
              onChanged: (text) {
                print(text);
              },
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: password,
              autofocus: false,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)),
              ),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Gib den Password ein';
                }
                return null;
              },
              onChanged: (text) {
                print(text);
              },
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                onPressed: () {
                  context.read<AuthenticationService>().signIn(
                      email: emailAdress.text.trim(),
                      password: password.text.trim());
                },
                padding: EdgeInsets.all(12),
                color: kButtonColor,
                child: Text('Log In', style: TextStyle(color: Colors.white)),
              ),
            ),
            FlatButton(
              child: Text(
                'Forgot password?',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {},
            ),
            OutlineButton(
              onPressed: () {
                signInWithGoogle().then((user) => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen())));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45)),
              splashColor: Colors.grey,
              borderSide: BorderSide(color: Colors.grey),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(
                        image: AssetImage("assets/icons/google_logo.png"),
                        height: 35.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
            /*RaisedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                  email: emailAdress.text.trim(),
                  password: password.text.trim());
            },
            child: Text("Sign in"),
          )*/
          ],
        ),
      ),
    );
  }
}
