import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'DBManager.dart';
import 'package:uuid/uuid.dart';

class DBQueries {

  static Future<int> insertRow(List<String> inp) async {
    Map<String, dynamic> row = {
      DBManager.columnKey : inp[0],
      DBManager.columnText : inp[1],
      DBManager.columnDate : inp[2],
      DBManager.columnTime : inp[3],
      DBManager.columnSilent : inp[4],
      DBManager.columnRepeat : inp[5],
    };
    return await _insert(row);
  }
  static Future<int> insertNote(String title, String text) async {
    var date = DateTime.now();
    var uuid = Uuid();
    Map<String, dynamic> row = {
      DBManager.columnKey : uuid.v4().toString(),
      DBManager.columnTitle : title,
      DBManager.columnText : text,
      DBManager.columnDate : DateFormat('yyyy-MM-dd').format(date),
      DBManager.columnTime : DateFormat.jms().format(date),
    };
    return await _insertNoteRow(row);
  }

  static Future<int> _insert(Map<String,dynamic> row) async {
    Database db = await DBManager().database;
    int id = await db.insert(DBManager.table, row);
    return id;
  }

  static Future<int> _insertNoteRow(Map<String,dynamic> row) async{
    Database db = await DBManager().database;
    int id = await db.insert(DBManager.notestable,row);
    return id;
  }

  static Future<int> deleteNote(String key) async {
    Database db = await DBManager().database;
    int id = await db.delete(DBManager.notestable,where: DBManager.columnKey + ' = ?', whereArgs: [key]);
    return id; 
  }

  static Future<int> deleteRow(String key) async {
    Database db = await DBManager().database;
    int id = await db.delete(DBManager.table,where: DBManager.columnKey + ' = ?', whereArgs: [key]);
    return id; 
  }

  static Future<List<List<String>>> getEvents() async {
    Database db = await DBManager().database;
    List<Map> results = await db.rawQuery("SELECT * FROM " + DBManager.table, null);
    return results.map((result) => [
      result[DBManager.columnKey].toString(), 
      result[DBManager.columnText].toString(), 
      result[DBManager.columnDate].toString(), 
      result[DBManager.columnTime].toString(),
      result[DBManager.columnSilent].toString(),
      result[DBManager.columnRepeat].toString()
    ]).toList();
  }

  static Future<List<List<String>>> getNotes() async {
    Database db = await DBManager().database;
    List<Map> results = await db.rawQuery("SELECT * FROM " + DBManager.notestable, null);
    return results.map((result) => [
      result[DBManager.columnKey].toString(), 
      result[DBManager.columnTitle].toString(), 
      result[DBManager.columnText].toString(), 
      result[DBManager.columnDate].toString(), 
      result[DBManager.columnTime].toString()
    ]).toList();
  }

  static Future<int> editNotes(String id, String title, String text) async {
    var date = DateTime.now();
    Map<String, dynamic> row = {
      DBManager.columnKey : id,
      DBManager.columnTitle : title,
      DBManager.columnText : text,
      DBManager.columnDate : DateFormat('yyyy-MM-dd').format(date),
      DBManager.columnTime : DateFormat.jms().format(date),
    };
    Database db = await DBManager().database;
    return await db.update(DBManager.notestable, row, where: DBManager.columnKey + '= ?', whereArgs: [id]); 
  }
}