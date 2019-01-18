import 'package:flutter/material.dart';
import 'Login.dart';
import 'Global.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: '密码盒子',
      theme: new ThemeData(
        primaryColor: GloablColor,
      ),
      home: new LoginPage(),
    );
  }
}
