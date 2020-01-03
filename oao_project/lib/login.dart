import 'global.dart';
import 'item.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly'
    ]
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('구글 로그인'),
              onPressed: () async {
                final GoogleSignInAccount googleUser = await googleSignIn.signIn();
                final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
                final AuthCredential credential = GoogleAuthProvider.getCredential(
                  accessToken: googleAuth.accessToken,
                  idToken: googleAuth.idToken,
                );
                final FirebaseUser user = (await firebaseAuth.signInWithCredential(credential)).user;
                print(user.email);
                print(user.uid);
                Global.currentUser = await firebaseAuth.currentUser();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => Item()
                ));
              },
            ),
            SizedBox(height: 10.0),
            RaisedButton(
              child: Text('익명 로그인'),
              onPressed: () async {
                FirebaseUser user = (await firebaseAuth.signInAnonymously()).user;
                print(user.email);
                print(user.uid);
                Global.currentUser = await firebaseAuth.currentUser();
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (_) => Item()
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}