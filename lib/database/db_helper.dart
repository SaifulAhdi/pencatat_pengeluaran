import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/expense.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._(); // singleton
  static Database? _db;
  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pengeluaran.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE expenses (
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT NOT NULL,
amount INTEGER NOT NULL,
category TEXT NOT NULL,
date TEXT NOT NULL,
note TEXT
)
''');
      },
    );
  }

  Future<int> insert(Expense e) async {
    final db = await database;
    return db.insert('expenses', e.toMap());
  }

  Future<List<Expense>> getAll() async {
    final db = await database;
    final rows = await db.query('expenses', orderBy: 'date DESC, id DESC');
    return rows.map((r) => Expense.fromMap(r)).toList();
  }

  Future<int> update(Expense e) async {
    final db = await database;
    return db.update('expenses', e.toMap(), where: 'id = ?', whereArgs: [e.id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
