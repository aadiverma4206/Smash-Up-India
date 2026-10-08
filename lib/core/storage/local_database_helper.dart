import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class LocalDatabaseHelper {
  static final LocalDatabaseHelper instance = LocalDatabaseHelper._init();
  static Database? _database;

  LocalDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('smash_up_india.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        await _createAdditionalTables(db);
        await _insertDefaultUsers(db);
        await _insertDummyFootballGames(db);
      },
    );
  }

  Future<void> _createAdditionalTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS football_games (
        id TEXT PRIMARY KEY,
        name TEXT,
        category TEXT,
        format TEXT,
        sport TEXT,
        isActive INTEGER
      )
    ''');
  }

  Future<void> _insertDummyFootballGames(Database db) async {
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM football_games'));
    if (count == 0) {
      final games = [
        // Indoor
        {'id': 'indoor_futsal', 'name': 'Futsal', 'category': 'indoor', 'format': '5v5', 'sport': 'Football', 'isActive': 1},
        {'id': 'indoor_football', 'name': 'Indoor Football', 'category': 'indoor', 'format': '5v5', 'sport': 'Football', 'isActive': 1},
        {'id': 'box_football', 'name': 'Box Football', 'category': 'indoor', 'format': '5v5', 'sport': 'Football', 'isActive': 1},
        {'id': 'indoor_6_a_side', 'name': 'Indoor 6-a-side Football', 'category': 'indoor', 'format': '6v6', 'sport': 'Football', 'isActive': 1},
        // Outdoor
        {'id': 'outdoor_5_a_side', 'name': '5-a-side Football', 'category': 'outdoor', 'format': '5v5', 'sport': 'Football', 'isActive': 1},
        {'id': 'outdoor_7_a_side', 'name': '7-a-side Football', 'category': 'outdoor', 'format': '7v7', 'sport': 'Football', 'isActive': 1},
        {'id': 'outdoor_9_a_side', 'name': '9-a-side Football', 'category': 'outdoor', 'format': '9v9', 'sport': 'Football', 'isActive': 1},
        {'id': 'outdoor_11_a_side', 'name': '11-a-side Football', 'category': 'outdoor', 'format': '11v11', 'sport': 'Football', 'isActive': 1},
      ];
      for (var game in games) {
        await db.insert('football_games', game, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        roleId INTEGER,
        city TEXT,
        status TEXT,
        avatar TEXT,
        token TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE key_value_store (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bookings (
        id TEXT PRIMARY KEY,
        title TEXT,
        courtName TEXT,
        date TEXT,
        time TEXT,
        amount REAL,
        status TEXT,
        data TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        title TEXT,
        amount REAL,
        type TEXT,
        date TEXT,
        status TEXT
      )
    ''');

    await _insertDefaultUsers(db);

    // Initial wallet balance
    await db.insert('key_value_store', {
      'key': 'wallet_balance',
      'value': '5500.0',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> _insertDefaultUsers(Database db) async {
    await db.insert('users', {
      'id': 1,
      'name': 'Aadi Verma (Admin)',
      'email': 'aadiverma4206@gmail.com',
      'phone': '9876543210',
      'roleId': 1,
      'city': 'Raipur',
      'status': 'ACTIVE',
      'avatar': '',
      'token': 'mock_admin_token_123',
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    await db.insert('users', {
      'id': 2,
      'name': 'Roshan Sharma (Manager)',
      'email': 'roshan12@gmail.com',
      'phone': '9123456789',
      'roleId': 2,
      'city': 'Raipur',
      'status': 'ACTIVE',
      'avatar': '',
      'token': 'mock_manager_token_123',
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    await db.insert('users', {
      'id': 3,
      'name': 'Rahul Player',
      'email': 'player@gmail.com',
      'phone': '9988776655',
      'roleId': 3,
      'city': 'Raipur',
      'status': 'ACTIVE',
      'avatar': '',
      'token': 'mock_player_token_123',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserByEmailOrPhone(String identifier) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'email = ? OR phone = ?',
      whereArgs: [identifier, identifier],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<void> saveUser(Map<String, dynamic> userMap) async {
    final db = await database;
    await db.insert('users', userMap, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<double> getWalletBalance() async {
    final db = await database;
    final res = await db.query('key_value_store', where: 'key = ?', whereArgs: ['wallet_balance']);
    if (res.isNotEmpty) {
      return double.tryParse(res.first['value'].toString()) ?? 5000.0;
    }
    return 5000.0;
  }

  Future<void> setWalletBalance(double balance) async {
    final db = await database;
    await db.insert('key_value_store', {
      'key': 'wallet_balance',
      'value': balance.toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> addTransaction(Map<String, dynamic> tx) async {
    final db = await database;
    await db.insert('transactions', tx, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query('transactions', orderBy: 'date DESC');
  }

  Future<void> saveBooking(Map<String, dynamic> booking) async {
    final db = await database;
    await db.insert('bookings', booking, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getBookings() async {
    final db = await database;
    return await db.query('bookings', orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> getFootballGamesByCategory(String category) async {
    final db = await database;
    
    // Safety check to ensure table exists in case the database was already created
    // before we added the table to the creation script.
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table' AND name='football_games'");
    if (tables.isEmpty) {
      await _createAdditionalTables(db);
      await _insertDummyFootballGames(db);
    }
    
    return await db.query(
      'football_games',
      where: 'category = ? AND isActive = 1',
      whereArgs: [category],
    );
  }
}
