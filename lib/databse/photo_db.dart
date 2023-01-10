import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'dart:io' as io;

import '../models/photo_model.dart';

class DBHelper {
  static Database? _db;
  int photoCount = 0;
  static const _databaseName = 'MyPhotos.db';
  static const photoTable = 'Photo';
  static const _databaseVersion = 1;
  static const photoId = 'photoId';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
  }

  Future<Database> initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, 'photos.db');

    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE photos (id INTEGER PRIMARY KEY AUTOINCREMENT , title TEXT NOT NULL , photo TEXT NOT NULL)",
    );
  }

  Future<PhotoModel> insert(PhotoModel? photoModel) async {
    var dbClient = await db;
    try {
      await dbClient!.insert(
        'photos',
        photoModel!.toMap(),
      );
    } catch (e) {
      print(e.toString());
    }
    return photoModel!;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return dbClient!.delete('photos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<PhotoModel>> getAllPhotos() async {
    var dbClient = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('photos');
    return queryResult.map((e) => PhotoModel.fromMap(e)).toList();
  }
}
