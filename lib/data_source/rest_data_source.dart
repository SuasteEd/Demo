import 'dart:convert';
import 'dart:io';
import 'package:enermax/models/clientes_dia.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RestDataSource {
  final url =
      Uri.parse("https://enersisuat.azurewebsites.net/api/Pedido/LibroDeRuta/");
  final http.Client _httpClient;
  late String nombreRuta = '';
  late List<ClienteDia> lis = [];
  RestDataSource({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  Future<List<ClienteDia>> getClient() async {
    final t = await SharedPreferences.getInstance();
    var token = t.getString('token') ?? 'null';
    print(token);
    final headers = {HttpHeaders.authorizationHeader: token};
    final response = await _httpClient.get(url, headers: headers);
    DateTime date = DateTime.now();
    Map<String, dynamic> map = json.decode(response.body);
    final lista = map['Dias'];
    var model;
    if (lista != null) {
      lista.forEach((element) {
        Map obj = element;
        List cliente = obj['Clientes'];
        int dia = obj['Dia'];
        nombreRuta = element['Nombre'];
        cliente.forEach((element) async {
          try {
            model = ClienteDia(
                dia,
                element['Id'],
                element['Orden'],
                element['Nombre'],
                element['AgenteId'],
                element['Domicilio'],
                element['Latitud'] == null
                    ? 0.0
                    : element["Latitud"].toDouble(),
                element['Longitud'] == null
                    ? 0.0
                    : element["Longitud"].toDouble(),
                0);
            lis.insert(0, model);
          } catch (e) {
            print('error ${e.toString()}');
          }
        });
      });
    }
    return lis;
  }
}
