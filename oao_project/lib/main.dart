import 'global.dart';
import 'signin.dart.';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'OAO-project',
    options: FirebaseOptions(
      googleAppID: '1:871087443278:android:c2b31298ae03f6d681221f',
      //gcmSenderID: '993907262456',
      apiKey: 'AIzaSyAqEb-tCXXyrL7OjQ4a_Gbg5OoSs5ZdRxA',
      projectID: 'oao-project-e8b9d'
    )
  );
  final FirebaseStorage storage = FirebaseStorage(
    app: app,
    storageBucket: 'gs://oao-project-e8b9d.appspot.com'
  );

  Global.storage = storage;

  runApp(Final(storage: storage));
}

class Final extends StatelessWidget {
  final FirebaseStorage storage;
  const Final({Key key, this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //debug 표시 삭제
      home: SignInPage(),
    );
  }
}