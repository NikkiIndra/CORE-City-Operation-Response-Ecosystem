import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../models/notification_model.dart';

class NotificationService {
  static Database? _database;

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notifications.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE notifications(
            id TEXT PRIMARY KEY,
            title TEXT,
            body TEXT,
            timestamp TEXT,
            isRead INTEGER
          )
        ''');
      },
    );
  }

  static Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  static Future<void> insertNotification(NotificationItem item) async {
    final db = await database;
    await db.insert(
      'notifications',
      item.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<NotificationItem>> getNotifications() async {
    final db = await database;
    final result = await db.query('notifications', orderBy: 'timestamp DESC');
    return result.map((json) => NotificationItem.fromJson(json)).toList();
  }

  static Future<void> deleteNotification(String id) async {
    final db = await database;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('notifications');
  }
}
