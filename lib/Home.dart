import 'package:flutter/material.dart';
import 'PWModel.dart';
import 'CreatePW.dart';
import 'DataManager.dart';
import 'Global.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PWModel> dataSource;

  //  刷新数据
  _refreshData() async {
    List<PWModel> newList = await DataManager().getPWList();
    setState(() {
      if (dataSource != newList) {
        print('更新dataSource');
        dataSource.clear();
        dataSource.addAll(newList);
      }
    });
  }

  //  pushToCreate
  _pushToCreate(BuildContext context, PWModel pModel) async {
    PWModel newModel = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new CreatePW(originalPWModel: pModel)));
    if (newModel is PWModel) {
      print('Create返回并有新密码加入');
      setState(() {
        _refreshData();
      });
    }
  }

  //  删除pw
  _deletePW(PWModel pModel) async {
    await DataManager().deletePWModel(pModel);
    _refreshData();
  }

  @override
  void initState() {
    print('initState---HomeState');
    dataSource = [];
    _refreshData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build---HomeState');
    return new Scaffold(
      appBar: new AppBar(
        title: Text('密码盒子'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                _pushToCreate(context, null);
              })
        ],
      ),
      body: ListView.separated(
        itemCount: dataSource.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: new CircleAvatar(
                backgroundColor: LightColor,
                child: new Text(
                  '${dataSource[index].themeName[0].toUpperCase()}',
                  style: new TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                )),
            title: new Text(
              '${dataSource[index].themeName}',
              style: new TextStyle(fontSize: 17),
            ),
            subtitle: new Text(
              '${dataSource[index].userName}',
              style: new TextStyle(fontSize: 15),
            ),
            onTap: () {
              _pushToCreate(context, dataSource[index]);
            },
            onLongPress: () {
              showDialog(
                context: context,
                child: new AlertDialog(
                  title: new Text('确认要删除 ${dataSource[index].themeName} ？'),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("取消"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text("确定", style: new TextStyle(color: Colors.red),),
                      onPressed: () async {
                        await _deletePW(dataSource[index]);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              );
            },
          );
        },
        //分割器构造器
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: GloablColor,
          );
        },
        //列表尾部
      ),
    );
  }
}
