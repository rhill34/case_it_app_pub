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
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/disclaimer", (_) => false);
                      },
                      child: new Text(
                        "Sign in with Google",
                        style:
                            new TextStyle(color: Colors.white, fontSize: 18.0),
                      )),
                ),
//                new FlatButton(
//                    onPressed: () {
//                      _showDisclaimer(context);
//                    },
//                    child: new Text(
//                      "By signing in, you agree to our terms of service",
//                      style: new TextStyle(color: Colors.white, fontSize: 15.0),
//                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
//}

class Disclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("CASE IT"),
        backgroundColor: highlineBlue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: new ListView(
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.all(10.0),
            child: new Text(
              "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
              style: new TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
            canvasColor: highlineBlue,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
            primaryColor: highlineGreen,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: highlineBlue))), // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(Icons.not_interested, color: highlineGreen,),
                title: new Text("Disagree".toUpperCase(),
                  style: new TextStyle(
                      color: highlineGreen,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                )),
            new BottomNavigationBarItem(
                icon: new Icon(Icons.check, color: highlineGreen,),
                title: new Text(
                  "Agree".toUpperCase(),
                  style: new TextStyle(
                      color: highlineGreen,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold),
                )),
          ],
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushNamedAndRemoveUntil("/", (_) => false);
            } else if (index == 1 && googleSignIn.currentUser != null) {
              Navigator
                  .of(context)
                  .pushNamedAndRemoveUntil("/jobs", (_) => false);
            } else {
              var signInAlert = new AlertDialog(
                content: new Text("Please sign in before agreeing"),
                actions: <Widget>[
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _handleSignIn();
                      },
                      child: new Text("Ok"))
                ],
              );
              showDialog(context: context, builder: (context) => signInAlert);
            }
          },
        ),
      ),

    );
  }
}

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
