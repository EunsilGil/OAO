import 'package:oao_project/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Global {
  static FirebaseUser currentUser;
  static FirebaseStorage storage;
  static Product currentProduct;
  static final String defaultImage =
      'gs://oao-project-e8b9d.appspot.com/logo/OAO_real_logo.png';
}