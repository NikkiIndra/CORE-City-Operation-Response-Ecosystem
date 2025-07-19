import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/profile_model.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get db async {
    return _db ??= await initDB();
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'profile.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fullname TEXT,
            email TEXT,
            pass TEXT
          )
        ''');
      },
    );
  }

  Future<void> updateProfile(ProfileModel profile) async {
    final dbClient = await db;
    await dbClient.update(
      'profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [profile.id],
    );
  }

  Future<int> saveProfile(ProfileModel profile) async {
    final dbClient = await db;
    return await dbClient.insert('profile', profile.toMap());
  }

  Future<List> getProfiles() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query('profile');
    return maps.map((e) => ProfileModel.fromMap(e)).toList();
  }

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
}
