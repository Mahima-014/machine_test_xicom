import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB{
  var databasesPath;
  String path;
  static Database database;

  static initialize() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "mahima.db");
    database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE FormDetails(id INTEGER PRIMARY KEY, "
              "first_name varchar, "
              "last_name varchar, "
              "email varchar, "
              "phone varchar, "
              "imagePath varchar "
              ")"
      );
    });
  }

  isTablePresentInDBOrNot(String tableName) async {
    var sql ="SELECT * FROM sqlite_master WHERE TYPE = 'table' AND NAME = '$tableName'";
    var res = await database.rawQuery(sql);
    var returnRes = res!=null && res.length > 0;
    return returnRes;
  }

  createTableIfNotExists(String tableName, String query) async {
    var sql = query;
    if (await isTablePresentInDBOrNot(tableName) == true) {
      return;
    }
    await database.execute(sql);
  }


  insertDataInDB(String tableName, Map map) async {
    if (await isTablePresentInDBOrNot(tableName) != true) {
      return;
    }
    await database.insert(tableName, map);
  }


  Future<List<Map>> getRecordsFromDB(String query) async
  {
    List<Map> list=null;
    try{
      list = await database.rawQuery(query);
      print(json.encode(list.toString()));
    }
    catch(e)
    {
      return null;
    }

    return list;
  }

}