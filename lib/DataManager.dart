import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fl_pwbox/PWModel.dart';

final String kMainPassword = 'kMainPassword';
final String kThemename ='kThemename';
final String kUsername = 'kUsername';
final String kPassword = 'kPassword';

class DataManager {

  Map<String, dynamic> toMap(PWModel pwModel) {
    var map = <String, dynamic>{
      kThemename: pwModel.themeName,
      kUsername: pwModel.userName,
      kPassword: pwModel.passsword,
    };
    if (pwModel.id != null) {
      map['id'] = pwModel.id;
    }
    return map;
  }

  PWModel fromMap(Map<String, dynamic> map) {
    PWModel pwModel = PWModel();
    pwModel.id = map['id'];
    pwModel.themeName = map[kThemename];
    pwModel.userName = map[kUsername];
    pwModel.passsword = map[kPassword];
    return pwModel;
  }

  Future<String> get _dbPath async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "password.db");
    print('存储地址：$path');
    return path;
  }

  Future<String> get _mainDBPath async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    print('主密码地址：$path');
    return path;
  }

  //  主密码
  Future<Database> get _mainFile async {
    final path = await _mainDBPath;
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE mainFile (id INTEGER PRIMARY KEY, $kMainPassword TEXT)");
        });
    return database;
  }

  Future<int> saveMainPassword(String mainPW) async {
    final db = await _mainFile;
    return  db.transaction((trx) {
      trx.rawInsert(
          'INSERT INTO mainFile($kMainPassword) VALUES("$mainPW")');
    });
  }

  Future<String> getMainPassword() async {
    final db = await _mainFile;
    List<Map> list = await db.rawQuery('SELECT * FROM mainFile ');
    if(list.length > 0){
      print('本地密码： ${list[0][kMainPassword].toString()}');
      return list[0][kMainPassword].toString();
    }else{
      return null;
    }
  }

  Future<int> updateMainPassword(String mainPW) async {
    final db = await _mainFile;
    return db.transaction((trx){
      trx.rawInsert(
          'UPDATE mainFile SET kMainPassword = "$mainPW"');
    });
  }

  //  其他数据
  Future<Database> get _localFile async {
    final path = await _dbPath;
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE passwords (id INTEGER PRIMARY KEY, $kThemename TEXT, $kUsername TEXT, $kPassword TEXT)");
    });
    return database;
  }

  Future<int> savePWModel(PWModel newModel) async {
    final db = await _localFile;
    final String themename = newModel.themeName;
    final String username = newModel.userName;
    final String password = newModel.passsword;
    print('保存新密码：$themename');
    return  db.transaction((trx) {
      trx.rawInsert(
          'INSERT INTO passwords($kThemename,$kUsername,$kPassword) VALUES("$themename","$username","$password")');
    });
  }

  Future<int> updatePWModel(PWModel oriModel, PWModel newModel) async {
    final db = await _localFile;
    final String themename = newModel.themeName;
    final String username = newModel.userName;
    final String password = newModel.passsword;
    final int id = oriModel.id;
    return db.transaction((trx){
      trx.rawInsert(
          'UPDATE passwords SET $kThemename = "$themename", $kUsername = "$username", $kPassword = "$password" WHERE id = $id');
    });
  }

  Future<List<PWModel>> getPWList() async {
    final db = await _localFile;
    List<Map> list = await db.rawQuery('SELECT * FROM passwords');
    List<PWModel> modelList = new List();
    list.forEach((map) {
      PWModel newModel = new PWModel()
        ..themeName = map[kThemename]
        ..userName = map[kUsername]
        ..passsword = map[kPassword]
        ..id = map['id'];
      modelList.add(newModel);
    });
    return modelList;
  }

  Future<int> deletePWModel (PWModel pwModel) async {
    final db = await _localFile;
    final int id = pwModel.id;
    return db.transaction((trx){
      trx.rawInsert(
          'DELETE FROM passwords WHERE id = $id');
    });
  }
}

