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

  @override
  Widget build(BuildContext context){
    fp = Provider.of<FirebaseProvider>(context);

    logger.d(fp.getUser());
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("로그인",)),
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Email',
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Password'
                        ),
                        obscureText: true,
                      )
                    ].map((c) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                        child: c,
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          //로그인
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RaisedButton(
              color: Color.fromARGB(254, 99, 86, 1),
              child: Text(
                "로그인",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode()); //키보드 감추기
                _signIn();
              },
            ),
          ),
          //회원가입
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: OutlineButton(
              color: Color.fromARGB(254, 99, 86, 1),
              child: Text(
                "회원가입",
                style: TextStyle(color: Color.fromARGB(254, 99, 86, 1)),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
            ),
          ),
          //구글 계정으로 가입하기
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: RaisedButton(
              color: Color.fromARGB(250, 250, 250, 1),
              child: Text(
                "구글 계정으로 가입하기",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode()); //키보드 감추기
                _signInWithGoogle();
              },
            ),
          ),
          //자동로그인
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              children: <Widget>[
                Checkbox(value: doRemember,
                    checkColor: Color.fromARGB(134, 134, 134, 1),
                    onChanged: (newValue) {
                      setState(() {
                        doRemember = newValue;
                      });
                    }),
                Text("자동로그인",
                  style: TextStyle(
                      color: Color.fromARGB(134, 134, 134, 1)),
                ),
              ],
            ),
          ),

          //Alert Box
          (fp.getUser() != null && fp.getUser().isEmailVerified == false)
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  decoration: BoxDecoration(color: Color.fromARGB(254, 99, 86, 1),),
                  child: Column(
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Mail authentication did not complete."
                        "\nPlease check your verification email.",
                        style: TextStyle(color: Color.fromARGB(250, 250, 250, 1)
                          ),
                        ),
                      ),
                      RaisedButton(
                        color: Color.fromARGB(254, 99, 86, 1),
                        textColor: Color.fromARGB(250, 250, 250, 1),
                        child: Text("Resend Verify Email"),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode()); //키보드 감추기
                          fp.getUser().sendEmailVerification();
                        },
                      ),
                    ],
                  ),
              )
              :Container(),
        ],
      ),
    );
  }

  void _signIn() async {
    _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: Duration(seconds: 10),
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("로그인 중입니다 :)")
            ],
          ),
        ));
    bool result = await fp.signInWithEmail(_emailController.text, _pwController.text);
    _scaffoldKey.currentState.hideCurrentSnackBar();
    if(result == false) showLastFBMessage();
  }
  void _signInWithGoogle() async {
    _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          duration: Duration(seconds: 10),
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("로그인 중입니다 :)")
            ],
          ),
        ));
    bool result = await fp.signInWithGoogleAccount();
    _scaffoldKey.currentState.hideCurrentSnackBar();
    if(result == false) showLastFBMessage();
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
          backgroundColor: Color.fromARGB(254, 99, 86, 1),
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