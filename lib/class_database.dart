//ローカルdb（デバイス内db）を使った処理
import 'package:sqflite/sqflite.dart';

Future<Database> initSubjectDB() async {
  var databasesPath = getDatabasesPath();
  final path1 = '$databasesPath/subjectDB.db';
  return await openDatabase(
    path1,
    version: 1,

    onCreate: (Database db, int version) async {
      await db.execute(
        'CREATE TABLE subject (id INTEGER PRIMARY KEY, title TEXT, place TEXT, classroom TEXT, day TEXT, period INT, hour INT, minute INT)',
      );
    },
  );
}

Future<void> insertSubject(Database db, Map<String, dynamic> subject) async {
  await db.insert('subject', {
    'id': subject['id'],
    'title': subject['title'],
    'place': subject['place'],
    'classroom': subject['classroom'],
    'day': subject['day'],
    'period': subject['period'],
    'hour': subject['hour'],
    'minute': subject['minute'],
  });
}

Future<List<Map<String, dynamic>>> getSubject(Database db, String day) async {
  return await db.query('subject', where: 'day = ?', whereArgs: [day], orderBy: 'period');
}

//データを削除
Future<void> deleteSubject(Database db, int id) async {
  await db.delete('subject', where: 'id = ?', whereArgs: [id]);
}
