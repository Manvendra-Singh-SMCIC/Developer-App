import 'package:path/path.dart' as paths;
import 'package:sqflite/sqflite.dart' as sqflite;

class MessageDatabaseHelper {
  static final MessageDatabaseHelper instance = MessageDatabaseHelper._();

  static sqflite.Database? _database;

  MessageDatabaseHelper._();

  Future<sqflite.Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<sqflite.Database> _initDatabase() async {
    final databasePath = await sqflite.getDatabasesPath();
    final path = paths.join(databasePath, 'message_database.db');

    return await sqflite.openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(sqflite.Database db, int version) async {
    await db.execute('''
      CREATE TABLE messages (
        id INTEGER PRIMARY KEY,
        search_id TEXT,
        last_time TEXT,
        date TEXT,
        time TEXT,
        type TEXT,
        doc_id TEXT,
        fileName TEXT,
        seen_by_other TEXT,
        message TEXT,
        sender_id TEXT,
        sendby TEXT,
        to_id TEXT,
        status TEXT,
        seen TEXT
      )
    ''');
  }

  Future<int> insertMessage(Map<String, dynamic> message) async {
    final db = await instance.database;
    return await db.insert('messages', message);
  }

  Future<List<Map<String, dynamic>>> getAllMessages() async {
    final db = await instance.database;
    return await db.query('messages');
  }

  Future<int> updateMessage(Map<String, dynamic> message) async {
    final db = await instance.database;
    final id = message['id'];
    return await db.update(
      'messages',
      message,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteMessage(int id) async {
    final db = await instance.database;
    return await db.delete(
      'messages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
