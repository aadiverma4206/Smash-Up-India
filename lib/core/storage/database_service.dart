import 'local_database_helper.dart';

class DatabaseService {
  final LocalDatabaseHelper db = LocalDatabaseHelper.instance;

  Future<void> init() async {
    await db.database;
  }

  Future<void> clearAllData() async {
    // clear local db tables
  }
}
