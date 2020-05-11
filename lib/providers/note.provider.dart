import 'package:notes/interfaces/note.dart';
import 'package:notes/providers/database.dart';
import 'package:sqflite/sqlite_api.dart';

class NoteProvider extends DatabaseApp {
  Database database;
  static final tableName = 'notes';

  Future<void> startApplication() async {
    this.database = await super.openDatabaseApp();
  }

  Future<void> closeApplication() async {
    if (this.database != null) {
      await super.closeDatabaseApp(database);
      this.database = null;
    }
  }

  Future<bool> saveNote(INote note) async {
    await this.startApplication();
    if (this.database != null) {
      int helper = await this.database.insert(
        tableName,
        note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace
      );
      return helper > 0;
    }
    return false;
  }

  Future<int> deleteNote(String id) async {
    await this.startApplication();
    if (this.database != null) {
      int deletedCount = await this.database.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id]
      );
      return deletedCount;
    }
    return -1;
  }

  Future<List<INote>> retrieveNotes() async {
    await this.startApplication();
    if (this.database != null) {
      List<Map<String, dynamic>> maps = await this.database.query(tableName);
      this.closeApplication();
      return maps.map<INote>((map) => INote.fromJson(map)).toList();
    }
    return null;
  }

  Future<int> updateNote(INote note) async {
    await this.startApplication();
    if (this.database != null) {
      int updatedCount = await this.database.update(
        tableName,
        note.toJson(),
        where: 'id = ?',
        whereArgs: [note.id]
      );
      return updatedCount;
    }
    return -1;
  }
}
