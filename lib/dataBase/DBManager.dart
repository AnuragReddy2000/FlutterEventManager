import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;

class DBManager{
  static final _databaseName = "EventManager.db";
  static final _databaseVersion = 1;

  DBManager._();
  static final DBManager _instance = DBManager._();
  factory DBManager() => _instance;

  static final table = 'Events';
  static final notestable = 'Notes';
  static final columnKey = 'Id';
  static final columnText = 'Text';
  static final columnDate = 'Date';
  static final columnTime = 'Time';
  static final columnSilent = 'Silent';
  static final columnRepeat = 'Repeat';
  static final columnTitle = 'Title';

  static Database _db;
  Future<Database> get database async {
    if (_db != null) return _db;
    
    _db = await _initDatabase();
    return _db;
  }

  _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath,  _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $table ( $columnKey TEXT PRIMARY KEY, $columnText TEXT NOT NULL, $columnDate TEXT NOT NULL, $columnTime TEXT NOT NULL, $columnSilent TEXT NOT NULL, $columnRepeat TEXT NOT NULL)");
    await db.execute("CREATE TABLE $notestable ( $columnKey TEXT PRIMARY KEY, $columnTitle TEXT NOT NULL, $columnText TEXT NOT NULL, $columnDate TEXT NOT NULL, $columnTime TEXT NOT NULL)");
  }
}