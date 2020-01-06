import 'global.dart';
import 'item.dart';
import 'firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SignInPageState pageState;

class SignInPage extends StatefulWidget {
  @override
  SignInPageState createState() {
    pageState = SignInPageState();
    return pageState;
  }
}

class SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();
  bool doRemember = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  void initState(){
    super.initState();
    getRememberInfo();
  }
  @override
  void dispose(){
    setRememberInfo();
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }


  getRememberInfo() async{
    logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool("deRemember") ?? false);
    });
    if(doRemember) {
      setState(() {
        _emailController.text = (prefs.getString("userEmail") ?? "");
        _pwController.text = (prefs.getString("userPassword") ?? "");
      });
    }
  }
  setRememberInfo() async{
    logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("doRemember", doRemember);
    if(doRemember) {
      prefs.setString("userEmail", _emailController.text);
      prefs.setString("userPassword", _pwController.text);
    }
  }
  showLastFBMessage() {
    _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          backgroundColor: Color.red[400],
          duration: Duration(seconds: 10),
          content: Text(fp.getLastFBMessage()),
          action: SnackBarAction(
            label: "Done",
            textColor: Colors.white,
            onPressed: () {},
          )
        ));
  }
}