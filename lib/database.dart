import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableUser = 'user';
  final String columnId = 'id';
  final String columnUsername = 'username';
  final String columnEmail = 'email';
  final String columnPassword = 'password';

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $tableUser('
              '$columnId INTEGER PRIMARY KEY AUTOINCREMENT, '
              '$columnUsername TEXT, '
              '$columnEmail TEXT, '
              '$columnPassword TEXT)',
        );
      },
    );
  }

  Future<int> saveUser(Map<String, dynamic> user) async {
    var dbClient = await db;
    return await dbClient.insert(tableUser, user);
  }

  Future<List<Map<String, dynamic>>> getUser(String username) async {
    var dbClient = await db;
    return await dbClient.query(tableUser,
        where: '$columnUsername = ?', whereArgs: [username]);
  }
}