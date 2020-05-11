import 'package:notes/providers/note.provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseApp {
  final String databaseName = 'notesapp';

  Future<Database> openDatabaseApp() async {
    return await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (db, version) {
        return db.execute("""
          CREATE TABLE ${NoteProvider.tableName} (
            id varchar(64) PRIMARY KEY,
            note TEXT,
            createdAt TEXT
          )
        """);
      }
    );
  }

  Future<void> closeDatabaseApp(Database database) async {
    await database.close();
  }

}