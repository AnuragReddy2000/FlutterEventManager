import 'package:sqflite/sqflite.dart';
import 'DBManager.dart';
import 'package:uuid/uuid.dart';

class DBQueries {

  void insertRow(List<String> inp) async {
    var uuid = Uuid();
    Map<String, dynamic> row = {
      DBManager.columnKey : uuid.v4().toString(),
      DBManager.columnText : inp[0],
      DBManager.columnDate : inp[1],
      DBManager.columnTime : inp[2],
      DBManager.columnSilent : inp[3],
      DBManager.columnRepeat : inp[4],
    };
    _insert(row);
  }

  Future<int> _insert(Map<String,dynamic> row) async {
    Database db = await DBManager().database;
    int id = await db.insert(DBManager.table, row);
    return id;
  }

  Future<int> deleteRow(String key) async {
    Database db = await DBManager().database;
    int id = await db.delete(DBManager.table,where: '$DBManager.columnId = ?', whereArgs: [key]);
    return id; 
  }

  /*Future<List>*/void getEvents(String date) async {
    Database db = await DBManager().database;
    List<Map> results = await db.query(DBManager.table, where : '$DBManager.columnDate = ?', whereArgs: [date]);
    print(results.map((result) => [
      result[DBManager.columnKey], 
      result[DBManager.columnText], 
      result[DBManager.columnDate], 
      result[DBManager.columnTime],
      result[DBManager.columnSilent],
      result[DBManager.columnRepeat]
    ]).toList());
  }
}