import 'dart:async';
import 'package:path/path.dart';
import 'package:sms/constants/message.dart';
import 'package:sms/constants/responses.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "settings.db";
  static const _databaseVersion = 4; // Increase this on +1 on each update

  static const _tableSettings = 'settings';
  static const _chats = "chats";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  // Open the database and create it if it doesn't exist.
  initDatabase() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $_tableSettings (
      id INTEGER PRIMARY KEY,
      menuButton TEXT,
      theme TEXT,
      language TEXT
      )''');

    await db.execute('''CREATE TABLE $_chats (
      id INTEGER PRIMARY KEY,
      chatsNames TEXT
       )''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion != newVersion) {
      // Fetch the list of table names (excluding system tables)
      List<Map> tables = await db.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'");

      // Drop each table
      for (var table in tables) {
        String? tableName = table['name'];
        if (tableName != null) {
          await db.execute("DROP TABLE $tableName");
        }
      }

      // If you have schema changes for newer versions, handle them here.
      // For example, you can call your database creation method to recreate the tables.
    }
  }

  Future createChat(String chatName) async {
    Database? db = await instance.database;
    final validChatName = 'chat$chatName';
    var tableExists = await db!.rawQuery(
        'SELECT * FROM sqlite_master WHERE type="table" AND name="$validChatName"');

    if (tableExists.isEmpty) {
      await db.insert(_chats, {'chatsNames': validChatName});
      await db.execute('''CREATE TABLE $validChatName (
      id INTEGER PRIMARY KEY,
      name ТEXT,
      chatMessages TEXT,
      isSent INTEGER,
      time TEXT
       )''');
    }
  }

  Future<List<Map<String, String>>> fetchAllChatNamesWithLastMessage() async {
    Database? db = await instance.database;

    // 1. Fetch all chatNames
    final chatNamesResult = await db!.query(_chats, columns: ['chatsNames']);

    List<Map<String, String>> chatNamesWithLastMessages = [];

    for (var row in chatNamesResult) {
      String chatName = row['chatsNames'] as String;

      final lastMessageResult = await db.query(chatName,
          orderBy: 'id DESC', limit: 1, columns: ['chatMessages']);

      String lastMessage = lastMessageResult.isNotEmpty
          ? lastMessageResult.first['chatMessages'] as String
          : '';

      chatNamesWithLastMessages
          .add({'chatName': chatName, 'lastMessage': lastMessage});
    }

    return chatNamesWithLastMessages;
  }

  Future<void> sendMessage(String chatName, Message message) async {
    Database? db = await instance.database;
    db!.insert(chatName, {
      'chatMessages': message.text,
      'isSent': message.isSent ? 1 : 0,
      'time': message.time
    });

    db.insert(chatName, {
      'chatMessages': generateResponse(message.text),
      'isSent': 0,
      'time': message.time
    });
  }

  Future<List<Map<String, Object?>>> getMassagesFromOneChat(
      String chatName) async {
    Database? db = await instance.database;

    final messageHistory = await db!.query(
      chatName,
      columns: ['chatMessages', 'isSent', 'time'],
    );

    return messageHistory;
  }
}

  // Future<void> _createTableIfNotExists(
  //     Database db, String tableName, String tableDefinition) async {
  //   // Check if the table already exists
  //   var tableExists = await db.rawQuery(
  //       'SELECT * FROM sqlite_master WHERE type="table" AND name="$tableName"');
  //   // If the table doesn't exist, create it.
  //   if (tableExists.isEmpty) {
  //     await db.execute(tableDefinition);
  //   }
  // }

  //////////////

  // Handle upgrades (like adding new columns)
 

  // Future<void> _addColumnIfNotExists(
  //     Database db, String table, String column, String type) async {
  //   try {
  //     await db.execute('ALTER TABLE $table ADD COLUMN $column $type;');
  //   } catch (e) {
  //     // If there's an exception, check if it's due to the column already existing.
  //     if (e.toString().contains("duplicate column name")) {
  //     } else {
  //       // If it's some other exception, rethrow it.
  //       rethrow;
  //     }
  //   }
  // }



  // Future<void> insertMagazine(MagazineModelForDB magazines) async {
  //   try {
  //     final db = await database;
  //     await db?.insert(
  //       table,
  //       magazines.toMap(),
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //     // ignore: empty_catches
  //   } catch (e) {
  //     // print(e);
  //   }
  // }

  // Future<void> rememberLastUsedEmail(String email) async {
  //   try {
  //     final db = await database;
  //     await db?.insert(
  //       _,
  //       {'lastLoggedEmail': email},
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   } catch (e) {}
  // }

  // Future<void> deleteMagazine(String name) async {
  //   final db = await database;
  //   if (db != null) {
  //     await db.delete(table, where: 'name = ?', whereArgs: [name]);
  //   }
  // }

  // Future<bool> doesMagazineExist(String magazineName) async {
  //   final db = await database;
  //   final result = await db!
  //       .query('savedMagazines', where: 'name = ?', whereArgs: [magazineName]);

  //   return result.isNotEmpty;
  // }

  // Future<List<Map<String, Object?>>?> getMagazines() async {
  //   final db = await database;
  //   if (db != null) {
  //     return db.query(
  //       table,
  //     );
  //   }
  //   return null;
  // }

  // Future<void> _createTableIfNotExists(
  //     Database db, String tableName, String tableDefinition) async {
  //   // Check if the table already exists
  //   var tableExists = await db.rawQuery(
  //       'SELECT * FROM sqlite_master WHERE type="table" AND name="$tableName"');
  //   // If the table doesn't exist, create it.
  //   if (tableExists.isEmpty) {
  //     await db.execute(tableDefinition);
  //   }
  // }

  // Future<String?> getLoggedLastEmail() async {
  //   final db = await database;
  //   if (db != null) {
  //     List<Map<String, dynamic>> result = await db.query(
  //       'lastLoggedUser', // Adjust this to the correct table name
  //       columns: ['lastLoggedEmail'],
  //       orderBy: 'id DESC', // Order by ID descending to get the latest entry
  //       limit: 1, // Limit the result to 1 entry
  //     );

  //     if (result.isNotEmpty && result[0]['lastLoggedEmail'] != null) {
  //       return result[0]['lastLoggedEmail'] as String;
  //     }
  //   }
  //   return null;
  // }

  // Future<int> getMagazineCount() async {
  //   final db = await database;
  //   if (db != null) {
  //     return Sqflite.firstIntValue(
  //             await db.rawQuery('SELECT COUNT(*) FROM savedMagazines')) ??
  //         0;
  //   }

  //   return 0;
  // }

