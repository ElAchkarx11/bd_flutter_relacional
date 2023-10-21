import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart ' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        "CREATE TABLE item(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, titulo TEXT, descricao TEXT, data TIMESTAMP NOT NULL DEFAULTCURRENT_TIMESTAMP)");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('banco.bd', version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  //insert
  static Future<int> createItem(String titulo, String? descricao) async {
    final db = await SQLHelper.db();
    final dados = {
      'titulo': titulo,
      'descricao': descricao,
    };
    final id = await db.insert('item', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //consulta - select
  static Future<List<Map<String, dynamic>>> getItem() async {
    final db = await SQLHelper.db();
    return db.query('item', orderBy: "id");
  }

  //update
  static Future<int> updateItem(
      int id, String titulo, String? descricao) async {
    final db = await SQLHelper.db();
    final data = {
      'titulo': titulo,
      'descricao': descricao,
      'data': DateTime.now().toString()
    };
    final resultado =
        await db.update('item', data, where: "id = ?", whereArgs: [id]);
    return resultado;
  }

  //Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete('item', where: 'id = ?', whereArgs: [id]);
    } catch (err) {
      debugPrint("Aconteceu algum erro ao deletrar o item: $err");
    }
  }
}
