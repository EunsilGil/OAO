import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

Logger logger = Logger();

class FirebaseProvider with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseUser _user;
  String _lastFirebaseResponse = "";

  FirebaseProvider(){
    logger.d("init FirebaseProvider");
    _prepareUser();
  }
  FirebaseUser getUser(){
    return _user;
  }

  void setUser(FirebaseUser value){
    _user = value;
    notifyListeners();
  }

  _prepareUser(){
    firebaseAuth.currentUser().then((FirebaseUser currentUser) {
      setUser(currentUser);
    });
  }

  Future<bool> signUpWithEmail (String email, String password) async{
    try{
      AuthResult result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        result.user.sendEmailVerification(); //인증메일 발송
        signOut();
        return true;
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }
  Future<bool> signInWithEmail(String email, String password) async{
    try{
      var result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result != null) {
        setUser(result.user);
        logger.d(getUser());
        return true;
      }
      return false;
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }
  Future<bool> signInWithGoogleAccount() async{
    try{
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final FirebaseUser user = (await firebaseAuth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);
      setUser(user);
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);
      return false;
    }
  }
  //firebase log out
  signOut() async{
    await firebaseAuth.signOut();
    setUser(null);
  }
  //password 재설정 메일 발송
  sendPasswordResentEmail() async{
    firebaseAuth.sendPasswordResetEmail(email: getUser().email);
  }
  sendPasswordResentEmailByEnglish() async{
    await firebaseAuth.setLanguageCode("en");
    sendPasswordResentEmail();
  }
  sendPasswordResentEmailByKorean() async{
    await firebaseAuth.setLanguageCode("ko");
    sendPasswordResentEmail();
  }
  //firebase 회원탈퇴
  withdrawalAccount() async{
    await getUser().delete();
    setUser(null);
  }
  setLastFBMessage(String msg) {
    _lastFirebaseResponse = msg;
  }
  getLastFBMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }
}