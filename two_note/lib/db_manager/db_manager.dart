import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:two_note/model/note_model.dart';



class DbManager {
  // await database.close();
  Database database;
  final dbName = "notes";
  final tableName = "Note";

  createDatabase() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, '$dbName.db');

    database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: populateDb,
    );
  }

  DbManager();

  void populateDb(Database database, int version) async {
    await database.execute("CREATE TABLE $tableName ("
        "id INTEGER PRIMARY KEY,"
        "title TEXT,"
        "details TEXT,"
        "createdDate TEXT,"
        "updatedDate TEXT"
        ")");
  }

  Future<int> createNote(Note note) async {
    var result = await database.insert(tableName, note.toJson());
    return result;
  }

  Future<List<Note>> getNotes({String orderBy}) async {
    var sortBy = "By Title";
    if (orderBy == "By Title") {
      sortBy = "title";
    } else if (orderBy == "By Created Date") {
      sortBy = "createdDate";
    } else {
      sortBy = "updatedDate";
    }
    await createDatabase();
    var result =
        await database.rawQuery('SELECT * FROM $tableName ORDER BY $sortBy');
    //return result.toList();
    return result.map((noteJson) {
      return Note.fromJson(noteJson);
    }).toList();
  }

  Future<Note> getNote(int id) async {
    var results =
        await database.rawQuery('SELECT * FROM Customer WHERE id = $id');

    if (results.length > 0) {
      return new Note.fromJson(results.first);
    }
    return null;
  }

  Future<int> updateNote(Note note) async {
    return await database.update(tableName, note.toJson(),
        where: "id = ?", whereArgs: [note.id]);
  }

  Future<int> deleteNote(int id) async {
    return await database.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
