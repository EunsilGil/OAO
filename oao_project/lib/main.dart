import 'global.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'final',
    options: FirebaseOptions(
      googleAppID: '1:993907262456:android:b1d72a2ec696b450',
      gcmSenderID: '993907262456',
      apiKey: 'AIzaSyBTdeK4f1u2cLOFVO71kbh3dVCP9F-BhfY',
      projectID: 'classwork-3ced3'
    )
  );
  final FirebaseStorage storage = FirebaseStorage(
    app: app,
    storageBucket: 'gs://classwork-3ced3.appspot.com'
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
      home: Login(),
    );
  }
}