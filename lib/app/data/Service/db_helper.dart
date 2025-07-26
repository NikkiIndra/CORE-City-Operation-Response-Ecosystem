import 'package:core/app/data/models/notification_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import '../models/profile_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal();

  DatabaseHelper.internal();

  static Database? _db;

  // initialize database
  Future<Database> get db async {
    return _db ??= await initDB();
  }

  // get user name
  Future<String?> getUserName() async {
    final dbClient = await db;
    final result = await dbClient.query(
      'profile',
      columns: ['fullname'],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['fullname'] as String;
    } else {
      return null;
    }
  }

  // initialize database
  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'profile.db');

    return await openDatabase(
      path,
      version: 3, // Naikkan versi karena ada perubahan schema
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullname TEXT,
            email TEXT,
            pass TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE notifications (
            id TEXT PRIMARY KEY,
            title TEXT,
            body TEXT,
            timestamp TEXT,
            isRead INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE user (
            id TEXT PRIMARY KEY,
            fullname TEXT,
            rt TEXT,
            rw TEXT,
            blok INTEGER
          )
        ''');
      },
      // onUpgrade: (db, oldVersion, newVersion) async {
      //   if (oldVersion < 2) {
      //     await db.execute('ALTER TABLE profile ADD COLUMN rt TEXT');
      //     await db.execute('ALTER TABLE profile ADD COLUMN rw TEXT');
      //     await db.execute('ALTER TABLE profile ADD COLUMN blok TEXT');
      //   }
      // },
    );
  }

  // Tambahkan method untuk mendapatkan data profil lengkap
  Future<ProfileModel?> getProfile() async {
    final dbClient = await db;
    final result = await dbClient.query('profile', limit: 1);
    if (result.isNotEmpty) {
      return ProfileModel.fromMap(result.first);
    }
    return null;
  }

  // update profile
  Future<void> updateProfile(ProfileModel profile) async {
    final dbClient = await db;
    await dbClient.update(
      'profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  // save profile
  Future<int> saveProfile(ProfileModel profile) async {
    final dbClient = await db;
    final map = profile.toMap();
    map.remove('id'); // biarkan database yang generate id
    return await dbClient.insert('profile', map);
  }

  // get all profiles
  Future<List> getProfiles() async {
    final dbClient = await db;
    print("getProfiles ${dbClient.toString()}");
    final List<Map<String, dynamic>> maps = await dbClient.query('profile');
    return maps.map((e) => ProfileModel.fromMap(e)).toList();
  }

  // login
  Future<ProfileModel?> login(String email, String pass) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'profile',
      where: 'email = ? AND pass = ?',
      whereArgs: [email, pass],
    );
    if (res.isNotEmpty) return ProfileModel.fromMap(res.first);
    return null;
  }

  // insert notification
  Future<void> insertNotification(NotificationItem notif) async {
    final dbClient = await db;
    await dbClient.insert(
      'notifications',
      notif.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // get all notifications
  Future<List<NotificationItem>> getAllNotifications() async {
    final dbClient = await db;
    final result = await dbClient.query(
      'notifications',
      orderBy: 'timestamp DESC',
    );
    return result.map((e) => NotificationItem.fromJson(e)).toList();
  }

  // delete notification
  Future<void> deleteNotification(String id) async {
    final dbClient = await db;
    await dbClient.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  // mark as read
  Future<void> markAsRead(String id) async {
    final dbClient = await db;
    await dbClient.update(
      'notifications',
      {'isRead': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // mark all as read
  Future<void> markAllAsRead() async {
    final dbClient = await db;
    await dbClient.update(
      'notifications',
      {'isRead': 1},
      where: 'isRead = 0', // hanya update yang belum dibaca
    );
  }

  // clear all notifications
  Future<void> clearAllNotifications() async {
    final dbClient = await db;
    await dbClient.delete('notifications');
  }

  // delete database
  Future<void> deleteDatabaseFile() async {
    final path = join(await getDatabasesPath(), 'profile.db');
    await deleteDatabase(path);
  }
}
