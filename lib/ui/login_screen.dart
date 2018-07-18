import 'dart:async';
import 'package:flutter/material.dart';
import '../ui/jobs.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginState();
  }
}

class LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("Login"),
        centerTitle: true,
        backgroundColor: highlineBlue,
      ),
      backgroundColor: highlineBlue,
      body: new ListView(
        children: <Widget>[
          new Container(
            height: 800.0,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("images/studyGroup.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: new Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(top: 15.0, bottom: 30.0),
                  //color: Colors.white,
                  alignment: Alignment.center,
                  child: new Image.asset(
                    "images/case-logo.png",
                    color: const Color(0xFF6EBD6D),
                    width: 300.0,
                  ),
                ),
                new Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 15.0),
                  padding: const EdgeInsets.all(10.0),
                  width: 300.0,
                  decoration: new BoxDecoration(color: const Color(0xFFCD4438)),
                  child: new FlatButton(
                      onPressed: () {
                        _handleSignIn();
                      },
                      child: new Text(
                        "Sign in with Google",
                        style:
                            new TextStyle(color: Colors.white, fontSize: 18.0),
                      )),
                ),
                new FlatButton(
                    onPressed: () {
                      _showDisclaimer(context);
                    },
                    child: new Text(
                      "By signing in, you agree to our terms of service",
                      style: new TextStyle(color: Colors.white, fontSize: 15.0),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//}

var highlineBlue = const Color(0xFF35556D);

var highlineGreen = const Color(0xFF6EBD6D);

void _showDisclaimer(BuildContext context) {
  var alert = new AlertDialog(
    title: new Text("Disclaimer"),
    content: new Text(
        "We have some rules. You need to follow them. Just agree to what we say"),
    actions: <Widget>[
      new FlatButton(
          onPressed: () {
            if (googleSignIn.currentUser != null) {
              Navigator
                  .of(context)
                  .pushNamedAndRemoveUntil("/jobs", (_) => false);
            } else {
              var signInAlert = new AlertDialog(
                content: new Text("Please sign in before agreeing"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: new Text("Ok"))
                ],
              );
              showDialog(context: context, builder: (context) => signInAlert);
            }
          },
          child: new Text("Ok")),
      new FlatButton(
          onPressed: () => Navigator.pop(context), child: new Text("Close"))
    ],
  );
  showDialog(context: context, builder: (context) => alert);
}

GoogleSignIn googleSignIn = new GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

Future<Null> _handleSignIn() async {
  try {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    await googleSignInAccount.authentication;
  } catch (error) {
    print(error);
  }
}

Future<Null> handleSignOut() async {
  try {
    await googleSignIn.disconnect();
    print("signed out");
  } catch (error) {
    print(error);
  }
}
