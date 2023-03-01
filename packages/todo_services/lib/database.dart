import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_services/data_models/dbtodo.dart';

class DBProvider {
  static final DBProvider db = DBProvider();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = p.join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute("""CREATE TABLE MY_LIST(
            id INTEGER PRIMARY KEY, 
            title TEXT, 
            description TEXT
            )""");
      },
    );
  }

  addTodo(DBTodo todo) async {
    final db = await database;
    final raw = await db.rawInsert(
      "INSERT INTO MY_LIST (id, title, description)"
      " VALUES(?, ?, ?)",
      [todo.id, todo.title, todo.description],
    );

    return raw;
  }

  Future<List<DBTodo>> getAllTodo() async {
    final db = await database;
    final res = await db.query("MY_LIST");
    List<DBTodo> list =
        res.isNotEmpty ? res.map((e) => DBTodo.fromMap(e)).toList() : [];
    return list;
  }

  Future<int> deleteTodoId(int id) async {
    final db = await database;
    return db.delete("MY_LIST", where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteAllTasks() async {
    final db = await database;
    return db.rawDelete("DELETE FROM MY_LIST");
  }

  Future<int> updateTodo(DBTodo todo) async {
    final db = await database;
    final res = await db.update(
      "MY_LIST",
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id],
    );
    return res;
  }

  Future<List<DBTodo>> searchTodo(String keyword) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT * FROM MY_LIST WHERE title = ?",
      [keyword],
    );
    List<DBTodo> todo = result.map((e) => DBTodo.fromMap(e)).toList();
    return todo;
  }
}
