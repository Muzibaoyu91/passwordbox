import 'package:flutter/material.dart';
import 'package:fl_pwbox/PWModel.dart';
import 'DataManager.dart';
import 'Global.dart';

class CreatePW extends StatefulWidget {
  CreatePW({Key key, this.originalPWModel}) : super(key: key);
  final PWModel originalPWModel;

  @override
  State<StatefulWidget> createState() {
    return _CreatePWState();
  }
}

class _CreatePWState extends State<CreatePW> {

  //  主题
  final TextEditingController _themeNameController =
      new TextEditingController();
  //  用户名
  final TextEditingController _userNameController = new TextEditingController();
  //  密码
  final TextEditingController _passwordController = new TextEditingController();

  //储存数据
  Future<int> _saveModel(PWModel newModel) async {
    print('开始储存~~~~~~~~~~~~~~~~~~~');
    return await DataManager().savePWModel(newModel);
  }

  //更新数据
  Future<int> _updateModel(PWModel oriModel, PWModel newModel) async{
    return await DataManager().updatePWModel(oriModel, newModel);
  }

  //弹出toast
  Future _showToast(BuildContext context, String msg) async {
    print('toast: $msg');
    showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text(msg),
      ),
    );
    return Future.delayed(Duration(seconds: 1), () {
      //  移除Dialog
      Navigator.pop(context);
    });
  }

  //返回Home
  _popToHome(BuildContext context, PWModel newModel) {
    print('返回Home页面');
    Navigator.pop(context, newModel);
  }

  //初始化数据
  _initData(){
    if(this.widget.originalPWModel != null){
      _themeNameController.text = this.widget.originalPWModel.themeName.toString();
      _userNameController.text = this.widget.originalPWModel.userName.toString();
      _passwordController.text = this.widget.originalPWModel.passsword.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    _themeNameController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('创建密码'),
        ),
        body: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(left: 10, right: 20, top: 20),
              child: new TextField(
                controller: _themeNameController,
                decoration: new InputDecoration(
                    icon: new Icon(Icons.title),
                    labelText: "请输入主题",
                    helperText: "例如：AppleID"),
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: new TextField(
                controller: _userNameController,
                decoration: new InputDecoration(
                    icon: new Icon(Icons.perm_identity),
                    labelText: "请输入登录名/用户名/手机号",
                    helperText: "例如：186XXXX"),
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: new TextField(
                controller: _passwordController,
                decoration: new InputDecoration(
                    icon: new Icon(Icons.lock),
                    labelText: "请输入密码",
                    helperText: "例如：186XXXX"),
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(left: 100, top: 50, right: 100),
              child: new Builder(builder: (BuildContext context) {
                return new RaisedButton(
                    onPressed: () async {
                      //  判断是否为空
                      if (_themeNameController.text.toString() != '' &&
                          _userNameController.text.toString() != '' &&
                          _passwordController.text.toString() != '') {

                        PWModel newPWModel = new PWModel()
                          ..themeName = _themeNameController.text.toString()
                          ..userName = _userNameController.text.toString()
                          ..passsword = _passwordController.text.toString();

                        if(this.widget.originalPWModel != null){
                          print('更新model');
                          await _updateModel(this.widget.originalPWModel, newPWModel);
                          await _showToast(context, '更新成功！');
                          _popToHome(context, newPWModel);
                        }else{
                          print('添加model');
                          await _saveModel(newPWModel);
                          await _showToast(context, '保存成功！');
                          _popToHome(context, newPWModel);
                        }
                      } else {
                        //  有空
                        Scaffold.of(context).showSnackBar(
                            new SnackBar(content: new Text("输入不能为空")));
                      }
                    },
                    color: LightColor,
                    highlightColor: LightColor,
                    disabledColor: LightColor,
                    child: new Text(
                      "完成",
                      style: new TextStyle(color: Colors.white),
                    ));
              }),
            )
          ],
        ));
    ;
  }
}
