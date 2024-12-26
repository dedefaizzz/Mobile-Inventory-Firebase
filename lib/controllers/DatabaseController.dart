import 'package:intl/intl.dart';
import 'package:mobile_inventory_firebase/models/item_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
  static final DatabaseController instance = DatabaseController._init();
  static Database? _database;

  DatabaseController._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('inventory.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const itemTable = '''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        category TEXT,
        price DOUBLE,
        stock INTEGER DEFAULT 0,
        imagePath TEXT
      );
    ''';

    const historyTable = '''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itemId INTEGER NOT NULL,
        type TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (itemId) REFERENCES items (id)
      );
    ''';

    await db.execute(itemTable);
    await db.execute(historyTable);
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(dateTime);
  }

  Future<int> insertItem(Item item) async {
    final db = await database;
    return await db.insert('items', item.toJson());
  }

  Future<List<Map<String, dynamic>>> fetchHistory(int itemId) async {
    final db = await database;
    return await db.query(
      'history',
      where: 'itemId = ?',
      whereArgs: [itemId],
      orderBy: 'date DESC',
    );
  }

  Future<int> updateItem(Item item) async {
    final db = await database;
    return await db
        .update('items', item.toJson(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<void> insertHistory({
    required String itemId,
    required String type,
    required int quantity,
    required DateTime dateTime,
  }) async {
    final db = await database;
    final formattedDate = formatDateTime(dateTime);

    await db.insert('history', {
      'itemId': itemId,
      'type': type,
      'quantity': quantity,
      'date': formattedDate,
    });
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
