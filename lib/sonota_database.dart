import 'package:sqflite/sqflite.dart';

Future<Database> initSonotaDB() async {
  var databasesPath = await getDatabasesPath();
  return openDatabase(
    '$databasesPath/sonotaDB.db',
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE schedule (id INTEGER PRIMARY KEY, title TEXT, memo TEXT, year INT, month INT, day INT, hour INT, minute INT)',
      );
    },
  );
}

Future<void> insertSonota(Database db, Map<String, dynamic> sonota) async {
  await db.insert('schedule', {
    'id': sonota['id'],
    'title': sonota['title'],
    'memo': sonota['memo'],
    'year': sonota['year'],
    'month': sonota['month'],
    'day': sonota['day'],
    'hour': sonota['hour'],
    'minute': sonota['minute'],
  });
}

Future<List<Map<String, dynamic>>> getSonota(Database db) async {
  return await db.query('schedule', orderBy: 'id');
}

Future<void> deleteSonota(Database db, int id) async {
  await db.delete('schedule', where: 'id = ?', whereArgs: [id]);
}
