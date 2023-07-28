import 'package:sqflite/sqflite.dart';
import './deutsch_word.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class WordsDataBase {
  static List<String> tables = [];
  static final WordsDataBase instance = WordsDataBase._init();
  static int version = 1;

  static Database? _database;

  WordsDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('words.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: version, onCreate: _createDB);
  }

  Future _createDB(Database db, int versoin) async {
    // const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    // const stringType = 'TEXT NOT NULL';

    // await db.execute(
    //     "CREATE TABLE $tableWords(${DeutschWordFields.id} $idType,${DeutschWordFields.artikel} $stringType,${DeutschWordFields.word} $stringType)");
  }

  Future addTable(String tableName) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const stringType = 'TEXT NOT NULL';
    tableName = tableName.replaceAll(' ', "_");
    final db = await instance.database;

    await db.execute(
        "CREATE TABLE $tableName (${DeutschWordFields.id} $idType,${DeutschWordFields.artikel} $stringType,${DeutschWordFields.word} $stringType)");
  }

  Future deleteTable(String tableName) async {
    final db = await instance.database;
    tableName = tableName.replaceAll(' ', "_");
    await db.execute('DROP TABLE IF EXISTS $tableName');
  }

  Future alterTableName(String oldName, String newName) async {
    final db = await instance.database;
    oldName = oldName.replaceAll(' ', "_");
    newName = newName.replaceAll(' ', "_");

    await db.execute("ALTER TABLE $oldName RENAME TO $newName");
  }

  Future<List<String>> getTableNames() async {
    final db = await instance.database;

    var newTables = (await db
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: true);
    newTables.removeAt(0);
    newTables.removeWhere((element) => element.startsWith('sqlite'));
    tables = newTables;

    for (int i = 0; i < newTables.length; i++) {
      newTables[i] = newTables[i].replaceAll('_', ' ');
    }
    return newTables;
  }

  Future<DeutschWord> create(DeutschWord word, String tableName) async {
    tableName = tableName.replaceAll(' ', "_");
    final db = await instance.database;

    final id = await db.insert(tableName, word.toJson());
    return word.copy(id, null, null);
  }

  Future<DeutschWord> readWord(int id, String tableName) async {
    tableName = tableName.replaceAll(" ", "_");

    final db = await instance.database;

    final maps = await db.query(tableName,
        columns: DeutschWordFields.values,
        where: '${DeutschWordFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return DeutschWord.fromJson(maps.first);
    } else {
      throw Exception("IF $id not found");
    }
  }

  Future<List<DeutschWord>> readAllWords(String tableName) async {
    tableName = tableName.replaceAll(" ", "_");

    final db = await instance.database;

    final result = await db.query(tableName);

    return result.map((json) => DeutschWord.fromJson(json)).toList();
  }

  Future<int> update(DeutschWord word, String tableName) async {
    final db = await instance.database;
    tableName = tableName.replaceAll(" ", "_");

    return db.update(
      tableName,
      word.toJson(),
      where: '${DeutschWordFields.id}= ?',
      whereArgs: [word.id],
    );
  }

  Future<int> delete(int id, String tableName) async {
    tableName = tableName.replaceAll(" ", "_");

    final db = await instance.database;

    return await db.delete(
      tableName,
      where: '${DeutschWordFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll(String tableName) async {
    tableName = tableName.replaceAll(" ", "_");

    final db = await instance.database;

    return await db.delete(tableName);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
