import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Board.dart';

class BoardHelper {
  late Database _database;

  Future<Database?> get database async {
    _database = await _openDB();
    return _database;
  }

  _openInitDB() async {
    String path = join(await getDatabasesPath(), 'InitBoard.db');
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) => {},
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS InitBoard (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              initializedDate VARCHAR(255) NOT NULL
            )
          ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );
  }

  Future readInitDB() async {
    final db = await _openInitDB();
    final List<Map<String, dynamic>> maps = await db!.query('InitBoard');
    if (maps.isEmpty) return [];
    return maps;
  }

  Future<void> createInitDB() async {
    final db = await _openInitDB();
    await db.insert(
      'InitBoard', // table name
      {
        'initializedDate': DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  _openDB() async {
    String path = join(await getDatabasesPath(), 'Board.db');
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (Database db) => {},
      onCreate: (db, version) async {
        await db.execute('''
            CREATE TABLE IF NOT EXISTS Board (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username VARCHAR(255) NOT NULL,
              title VARCHAR(255) NOT NULL,
              content VARCHAR(255) NOT NULL,
              newsLink VARCHAR(255),
              dateTime VARCHAR(255) NOT NULL,
              company VARCHAR(255),
              category VARCHAR(255),
              imageUrl VARCHAR(255),
              subscribeCount INTEGER 
            )
          ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) => {},
    );
  }

  Future<List<Board>> read() async {
    final db = await _openDB();
    final List<Map<String, dynamic>> maps = await db!.query('Board');
    if (maps.isEmpty) return [];
    List<Board> list = List.generate(maps.length, (index) {
      return Board(
        id: maps[index]["id"],
        username: maps[index]["username"],
        title: maps[index]["title"],
        content: maps[index]["content"],
        newsLink: maps[index]["newsLink"],
        dateTime: maps[index]["dateTime"],
        company: maps[index]["company"],
        category: maps[index]["category"],
        imageUrl: maps[index]["imageUrl"],
        subscribeCount: maps[index]["subscribeCount"],
      );
    });
    return list;
  }

  Future<Board> readDetail(int id) async {
    final db = await _openDB();
    final Map<String, dynamic> data = await db!.query('Board');
    return Board(
      id: data["id"],
      username: data["username"],
      title: data["title"],
      content: data["content"],
      newsLink: data["newsLink"],
      dateTime: data["dateTime"],
      company: data["company"],
      category: data["category"],
      imageUrl: data["imageUrl"],
      subscribeCount: data["subscribeCount"],
    );
  }

  Future<void> createInit(Board board) async {
    final db = await _openDB();
    await db.insert(
      'Board', // table name
      {
        'username': board.username,
        'title': board.title,
        'content': board.content,
        'newsLink': board.newsLink,
        'dateTime': board.dateTime,
        'company': board.company,
        'category': board.category,
        'imageUrl': board.imageUrl,
        'subscribeCount': board.subscribeCount,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> create(title, content, category) async {
    final db = await _openDB();
    await db.insert(
      'Board', // table name
      {
        'username': '김더즌',
        'title': title,
        'content': content,
        'newsLink': 'https://www.dozn.co.kr',
        'dateTime': DateFormat("yyyy-MM-dd HH:mm").format(DateTime.now()),
        'company': 'Dozn',
        'category': category,
        'imageUrl':
            'https://raw.githubusercontent.com/doznAvokado/flutter_web_task/master/2h-media-EP6vP1i_l5I-unsplash.jpg',
        'subscribeCount': 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSubscribeCount(Board board) async {
    final db = await _openDB();
    await db.update(
      'Board',
      {
        'username': board.username,
        'title': board.title,
        'content': board.content,
        'newsLink': board.newsLink,
        'dateTime': board.dateTime,
        'company': board.company,
        'category': board.category,
        'imageUrl': board.imageUrl,
        'subscribeCount': board.subscribeCount! + 1,
      },
      where: "id = ?",
      whereArgs: [board.id],
    );
  }

  Future<void> delete(Board board) async {
    final db = await _openDB();
    await db.delete(
      'Board',
      where: "id = ?",
      whereArgs: [board.id],
    );
  }
}
