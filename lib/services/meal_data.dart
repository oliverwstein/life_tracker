import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('meals.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB, onOpen: (db) async {
      // Ensure foreign key constraints are enabled.
      await db.execute('PRAGMA foreign_keys = ON');
    });
  }

  Future _createDB(Database db, int version) async {
    // Definition for ID types
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // Creating the meals table
    await db.execute('''
CREATE TABLE meals (
  id $idType,
  dateTime $textType,
  totalCalories $integerType,
  totalProtein $integerType
);
''');

    // Creating the foodItems table with a foreign key that links to the meals table
    await db.execute('''
CREATE TABLE foodItems (
  id $idType,
  mealId INTEGER NOT NULL,
  name $textType,
  calories $integerType,
  protein $integerType,
  quantity $integerType,
  FOREIGN KEY (mealId) REFERENCES meals(id) ON DELETE CASCADE
);
''');
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
