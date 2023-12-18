import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class NoteDbHelper {
  static const dbname = 'notes.db';
  static const dvversion = 1;
  static const tablename = 'notes';
  static const colid = 'id';
  static const coltittle = 'title';
  static const coldescription = 'description';
  static const coldate = 'date';

  static final NoteDbHelper instance = NoteDbHelper();
  static Database? niranjandb;

  Future<Database?> get db async {
    niranjandb ??= await _initDb();
    return niranjandb;
  }

  _initDb() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbname);
    return await openDatabase(path, version: dvversion, onCreate: _oncreate);
  }

  _oncreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tablename(
    $colid INTEGER PRIMARY KEY AUTOINCREMENT,
    $coltittle TEXT NOT NULL,
    $coldescription TEXT NOT NULL,
    $coldate TEXT NOT NULL
    )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database? db = await instance.db;
    return await db!.insert(tablename, row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database? db = await instance.db;
    return await db!.query(tablename);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database? db = await instance.db;
    int id = row[colid];
    return await db!
        .update(tablename, row, where: '$colid = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database? db = await instance.db;
    return await db!.delete(tablename, where: '$colid = ?', whereArgs: [id]);
  }

  Future close() async {
    Database? db = await instance.db;
    db!.close();
  }
}