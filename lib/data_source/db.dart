import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  late Database _database;

  static initiateDataBase() async {
    return await openDatabase('db_crud.db', version: 1,
        onCreate: (Database db, int version) {
      var sqlCreate = sqlCreateDatabase();
      db.execute(sqlCreate);
      var sqlCreate1 = sqlCreateDatabase1();
      db.execute(sqlCreate1);
    });
  }

  static String sqlCreateDatabase() {
    return 'CREATE TABLE IF NOT EXISTS clientes(dia INT, id INT UNIQUE, orden INT, nombre TEXT, agenteId INT, domicilio TEXT, latitud FLOAT, longitud FLOAT, checado INT)';
  }

  static String sqlCreateDatabase1() {
    return 'CREATE TABLE IF NOT EXISTS check_inn(dia INT, id INT, latitud FLOAT, longitud FLOAT, title TEXT, snippet TEXT)';
  }

  void close() {
    _database.close();
  }
}
