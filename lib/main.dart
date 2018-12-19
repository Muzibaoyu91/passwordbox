import 'package:flutter/material.dart';
import 'Login.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: '密码盒子',
      home: new LoginPage(),
    );
  }
}
