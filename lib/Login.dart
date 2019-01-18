import 'package:flutter/material.dart';
import 'Home.dart';
import 'DataManager.dart';
import 'Global.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //  本地主密码
  String _localPassWord;
  final TextEditingController _pwController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLocalPassWord();
  }

  @override
  void dispose() {
    _pwController.dispose();
    super.dispose();
  }

  _checkLocalPassWord() async {
    final String localPW = await DataManager().getMainPassword();
    setState(() {
      _localPassWord = localPW;
    });
  }

  _saveNewPW() async {
    await DataManager().saveMainPassword(_pwController.text);
    await Navigator.of(context).pushAndRemoveUntil(
        new MaterialPageRoute(builder: (context) => new Home()),
            (router) => router == null);
  }

  @override
  Widget build(BuildContext context) {
    final password = new TextField(
      controller: _pwController,
      decoration: new InputDecoration(
          hintText: 'Password',
          contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = new Padding(
      padding: new EdgeInsets.symmetric(vertical: 16.0),
      child: new MaterialButton(
      minWidth: 100.0,
      height: 42.0,
      onPressed: () {
        if(_pwController.text == ''){
          showDialog(
            context: context,
            child: new AlertDialog(
              title: new Text('输入不能为空！'),
            ),
          );
          return;
        }

        if(_localPassWord == null){
          //  注册密码
          _saveNewPW();
        }else{
          //  校验密码
          if(_pwController.text  == _localPassWord){
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => new Home()),
                    (router) => router == null);
          }else{
            showDialog(
              context: context,
              child: new AlertDialog(
                title: new Text('密码输入错误！'),
              ),
            );
          }
        }
      },
      color: LightColor,
      child: new Text(
        _localPassWord != null ? '登录' : '注册主密码',
        style: new TextStyle(color: Colors.white),
      ),
    )
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
        child: new Center(
          child: new ListView(
            shrinkWrap: true,
            padding: new EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              password,
              SizedBox(
                height: 24.0,
              ),
              loginButton,
            ],
          ),
        ),
      ),
    );
  }
}
