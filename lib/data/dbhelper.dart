import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:themoviedb/model/favorite.dart';

class DBprovider {
  DBprovider._();
  static final DBprovider db = DBprovider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDir = await getApplicationDocumentsDirectory();
    String path = join(documentDir.path, "Movies.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Movies ("
          "id INTEGER PRIMARY KEY,"
          "title TEXT,"
          "poster TEXT,"
          // "genre TEXT,"
          "overview TEXT,"
          "vote INT"
          ")");
    });
  }

  newFavorite(Favorite newFavorite) async {
    final db = await database;
    var res = await db.insert("Movies", newFavorite.toMap());
    return res;
  }

  getAllFavorite() async {
    print('udah sampe sini');
    final db = await database;
    var res = await db.query("Movies");
    List<Favorite> list =
        res.isNotEmpty ? res.map((c) => Favorite.fromMap(c)).toList() : [];
    return list;
  }

  deleteFavorite(int id) async {
    final db = await database;
    db.delete("Movies", where: "id = ?", whereArgs: [id]);
  }
}
