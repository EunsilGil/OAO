import 'global.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                builder: (_) => Login()
              ), (_) => false);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200.0,
              height: 200.0,
              child: Image.network(Global.currentUser.photoUrl ?? Global.defaultImage)
            ),
            SizedBox(height: 10.0,),
            Text(Global.currentUser.uid),
            SizedBox(height: 10.0,),
            Text(Global.currentUser.email ?? 'anonymous')
          ],
        ),
      ),
    );
  }
}