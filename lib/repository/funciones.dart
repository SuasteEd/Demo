import 'package:sqflite/sqflite.dart';
import 'dart:async';
import '../models/check_in.dart';
import '../models/clientesDiaMap.dart';

class AccionRepository {
  late Database _database;
  AccionRepository(Database pdatabase) {
    _database = pdatabase;
  }

  Future<List<clientesDia>> getAllAcciones(int dia) async {
    List result =
        await _database.rawQuery('SELECT * FROM clientes WHERE dia = ?', [dia]);
    var lista = result
        .map((item) => clientesDia(
            int.parse(item['dia'].toString()),
            int.parse(item['id'].toString()),
            int.parse(item['orden'].toString()),
            item['nombre'],
            int.parse(item['agenteId'].toString()),
            item['domicilio'],
            double.parse(item['latitud'].toString()),
            double.parse(item['longitud'].toString()),
            int.parse(item['checado'].toString())))
        .toList();
    return lista;
  }

  Future<List<clientesDia>> getAllAccionesN() async {
    List result = await _database.rawQuery('SELECT * FROM clientes');
    var lista = result
        .map((item) => clientesDia(
            int.parse(item['dia'].toString()),
            int.parse(item['id'].toString()),
            int.parse(item['orden'].toString()),
            item['nombre'],
            int.parse(item['agenteId'].toString()),
            item['domicilio'],
            double.parse(item['latitud'].toString()),
            double.parse(item['longitud'].toString()),
            int.parse(item['checado'].toString())))
        .toList();
    return lista;
  }

  Future<List<check_inn>> getAllCheck() async {
    List result = await _database.rawQuery('SELECT * FROM check_inn');
/*     print(result);
 */
    var lista = result
        .map((item) => check_inn(
            int.parse(item['dia'].toString()),
            int.parse(item['id'].toString()),
            double.parse(item['latitud'].toString()),
            double.parse(item['longitud'].toString()),
            item['title'],
            item['snippet']))
        .toList();
    return lista;
  }

  register(clientesDia accion) async {
    var map = accion.mapForInsert();
    await _database.insert("clientes", map);
  }

  registerCheck(check_inn check) async {
    var map = check.mapForInsert();
    await _database.insert("check_inn", map);
  }

  delete(int id) async {
    var count = await _database.rawDelete('DELETE FROM clientes');
  }

  deleteCheck(int id) async {
    var count =
        await _database.rawDelete('DELETE FROM check_inn WHERE id = ?', [id]);
  }

  update(int id) async {
    var count = await _database
        .rawUpdate('UPDATE clientes SET  checado = ? WHERE id = ?', [1, id]);
  }

  updateCheck(int id) async {
    var count = await _database
        .rawUpdate('UPDATE clientes SET  checado = ? WHERE id = ?', [0, id]);
  }
}
