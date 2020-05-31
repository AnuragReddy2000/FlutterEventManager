import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:uuid/uuid.dart';

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
    var date = DateTime.now();
    var uuid = Uuid();
    Map<String, dynamic> row = {
      columnKey : uuid.v4().toString(),
      columnTitle : "Welcome Note",
      columnText : "Hi! Welcome to Event Manager, the one app to plan your day! \n\nThis app features three reminder types i.e Normal or Ring Alert, Silent Notification, Repeating Reminder. There is also a Notes feature where one can add, edit, delete notes. So, get started and explore the app to better know its functionality. \n\nPS. If you are using Xiaomi phones with MIUI, Please enable the Autostart, Display pop-up windows from background, Show on Lock screen and Permanent notification permissions for this app, in the settings",
      columnDate : DateFormat('yyyy-MM-dd').format(date),
      columnTime : DateFormat.jms().format(date),
    };
    await db.insert(notestable, row);
  }
}