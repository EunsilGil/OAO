import 'global.dart';
import 'item.dart';
import 'firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

SignUpPageState pageState;

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() {
    pageState = SignUpPageState();
    return pageState;
  }
}

class SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(fp == null){
      fp = Provider.of<FirebaseProvider>(context);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text("회원가입"),),
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
            child: Column(
              children: <Widget>[
                Text("이름"),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '이름을 입력해주세요',
                  ),
                ),
                Text("닉네임"),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '닉네임을 입력해주세요',
                  ),
                ),
                Text("이메일"),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '이메일을 입력해주세요',
                  ),
                ),
                Text("휴대폰 번호"),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '-을 제외한 휴대폰 번호를 입력해주세요',
                  ),
                ),
                Text("비밀번호"),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '******',
                  ),
                ),
                Text("비밀번호 확인"),
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    hintText: '******',
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
