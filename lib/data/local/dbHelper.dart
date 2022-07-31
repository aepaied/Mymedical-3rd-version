import 'dart:io';


import 'package:my_medical_app/data/local/dbInfo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DbHelper {

  static void databaseLog(String functionName, String sql,
      [List<Map<String, dynamic>> selectQueryResult, int insertAndUpdateQueryResult, List<dynamic> params]) {
    print(functionName);
    print(sql);
    if (params != null) {
      print(params);
    }
    if (selectQueryResult != null) {
      print(selectQueryResult);
    } else if (insertAndUpdateQueryResult != null) {
      print(insertAndUpdateQueryResult);
    }
  }

  Future<String> getDatabasePath(String dbName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    //make sure the folder exists
    if (await Directory(dirname(path)).exists()) {
      //await deleteDatabase(path);
    } else {
      await Directory(dirname(path)).create(recursive: true);
    }
    return path;
  }

  Future<void> initDatabase() async {
    final path = await getDatabasePath(DbInfo.DB_NAME);
    db = await openDatabase(path,
        version: DbInfo.DB_VERSION, onCreate: onCreate);
    print(db);
  }

  Future<void> onCreate(Database db, int version) async {

    await createRecentSearchTable(db);
  }

  Future<void> createRecentSearchTable(Database db) async {
    final sql = "create table  if not exists " + DbInfo.RECENT_SEARCH +
        "(id INTEGER PRIMARY KEY AUTOINCREMENT," +
        "searchText TEXT)";

    await db.execute(sql);
  }


}
