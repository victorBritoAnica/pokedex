import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/pokemon.dart';

class DatabaseService {
  static const _dbName = 'pokemon_database.db';
  static const _dbVersion = 1;
  static const _tableName = 'pokemons';
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getDatabasesPath();
    final path = join(documentsDirectory, _dbName);

    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
         description TEXT,
        lastUpdated TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertOrUpdatePokemon(Pokemon pokemon) async {
    final db = await instance.database;
    return await db.insert(
      _tableName,
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Pokemon>> getPokemons(int offset, int limit) async {
    final db = await instance.database;
    final maps = await db.query(
      _tableName,
      orderBy: 'id ASC',
      limit: limit,
      offset: offset,
    );
    return maps.map((map) => Pokemon.fromMap(map)).toList();
  }

  // Limpieza de caché antiguo
  Future<void> clearOldCache({int days = 7}) async {
    final db = await instance.database;
    final threshold = DateTime.now().subtract(Duration(days: days));
    await db.delete(
      _tableName,
      where: 'lastUpdated < ?',
      whereArgs: [threshold.toIso8601String()],
    );
  }
}
