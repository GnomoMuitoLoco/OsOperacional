import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Getter do banco
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orders.db');
    return _database!;
  }

  // Inicializa o banco
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Criação da tabela
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clientName TEXT,
        description TEXT,
        status TEXT,
        materials TEXT,
        photos TEXT,
        signaturePath TEXT,
        createdAt TEXT
      )
    ''');
  }

  // Insert genérico
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await instance.database;
    return await db.insert(table, values);
  }

  // Query all
  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await instance.database;
    return await db.query(table, orderBy: "createdAt DESC");
  }

  // Query filtrando por status
  Future<List<Map<String, dynamic>>> queryByStatus(String status) async {
    final db = await instance.database;
    return await db.query(
      'orders',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: "createdAt DESC",
    );
  }

  // Update
  Future<int> update(String table, Map<String, dynamic> values, int id) async {
    final db = await instance.database;
    return await db.update(
      table,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete
  Future<int> delete(String table, int id) async {
    final db = await instance.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Fechar o banco
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}