import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBConnection {
  DBConnection._();

  ///singleton
  static DBConnection getInstance = DBConnection._();

  ///table history
  static final String TABLE_HISTORY = "history";
  static final String COLUMN_HISTORY_ID = "id";
  static final String COLUMN_HISTORY_TITLE = "title";
  static final String COLUMN_HISTORY_COST = "cost";
  static final String COLUMN_HISTORY_DATE = "date";
  static final String COLUMN_HISTORY_TIME = "time";
  static final String COLUMN_HISTORY_STATUS = "status";

  Database? movieDb;

  Future<Database> getDB() async {
    movieDb ??= await openDB();
    return movieDb!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "historyDb.db");

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        print("Database created with version : $version");
        db.execute(
          "CREATE TABLE $TABLE_HISTORY ("
              "$COLUMN_HISTORY_ID INTEGER PRIMARY KEY AUTOINCREMENT, "
              "$COLUMN_HISTORY_TITLE TEXT, "
              "$COLUMN_HISTORY_COST INTEGER, "
              "$COLUMN_HISTORY_DATE TEXT,"
              "$COLUMN_HISTORY_TIME TEXT,"
              "$COLUMN_HISTORY_STATUS TEXT,"
          ")"
        );
        print("Table $TABLE_HISTORY created successfully.");
      },
      version: 10,
    );
  }

  Future<bool> addTransaction({
    required String title,
    required String cost,
    required String date,
    required String time,
    required String status,
    }) async {
    var db = await getDB();
    int rowsEffected = await db.insert(
      TABLE_HISTORY,
      {
        COLUMN_HISTORY_TITLE : title,
        COLUMN_HISTORY_COST : cost,
        COLUMN_HISTORY_DATE : date,
        COLUMN_HISTORY_TIME : time,
        COLUMN_HISTORY_STATUS : status,
      }
    );
    print('Rows affected: $rowsEffected');
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final db = await getDB();
    final data = await db.query(TABLE_HISTORY);
    print("All transactions: $data");
    return data;
  }

  Future<void> deleteTransaction(int id) async {
    final db = await getDB();
    await db.delete(
      TABLE_HISTORY,
      where: '$COLUMN_HISTORY_ID = ?',
      whereArgs: [id],
    );
  }
}












