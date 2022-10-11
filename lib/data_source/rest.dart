import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:enermax/models/datos.dart';
import 'package:enermax/models/indicador.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Rest {
  final url = Uri.parse(
      "https://enersis.azurewebsites.net/api/ComercialAnalisis/ScorecardGeneralPorAgente");
  late List<Indicador> lis = [];
  late List<Datos> lisD = [];
  late List<Indicador> lisSeg = [];
  late List<Datos> lisDSeg = [];
  late List<Indicador> lisLub = [];
  late List<Datos> lisDLub = [];

  Future<List<Indicador>> getIndicator() async {
    final t = await SharedPreferences.getInstance();
    var token = t.getString('token') ?? 'null';
    final headers = {HttpHeaders.authorizationHeader: token};
    final response = await http.get(url, headers: headers);
    Map<String, dynamic> map = json.decode(response.body);
    var model;
    var lista = map['General'];
    if (lis.isEmpty) {
      lista.forEach((element) async {
        try {
          model = Indicador.fromJson(element);
          lis.insert(0, model);
        } catch (e) {
          log('error');
        }
      });
    }
    return lis;
  }

  Future<List<Datos>> getDatos() async {
    final t = await SharedPreferences.getInstance();
    var token = t.getString('token') ?? 'null';
    final headers = {HttpHeaders.authorizationHeader: token};
    final response = await http.get(url, headers: headers);
    Map<String, dynamic> map = json.decode(response.body);
    var model;
    var lista = map['General'];
    if (lisD.isEmpty) {
      lista.forEach((element) async {
        Map obj = element;
        List datos = obj['Datos'];
        datos.forEach((element) {
          try {
            model = Datos.fromJson(element);
            lisD.insert(0, model);
          } catch (e) {
            log(e.toString());
          }
        });
      });
    }
    return lisD;
  }

  Future<List<Indicador>> getIndicatorSegmentos() async {
    final t = await SharedPreferences.getInstance();
    var token = t.getString('token') ?? 'null';
    final headers = {HttpHeaders.authorizationHeader: token};
    final response = await http.get(url, headers: headers);
    Map<String, dynamic> map = json.decode(response.body);
    var model;
    var lista = map['Segmentos'];
    if (lisSeg.isEmpty) {
      lista.forEach((element) async {
        try {
          model = Indicador.fromJson(element);
          lisSeg.insert(0, model);
        } catch (e) {
          log('error');
        }
      });
    }
    return lisSeg;
  }

  Future<List<Datos>> getDatosSegmentos() async {
    final t = await SharedPreferences.getInstance();
    var token = t.getString('token') ?? 'null';
    final headers = {HttpHeaders.authorizationHeader: token};
    final response = await http.get(url, headers: headers);
    Map<String, dynamic> map = json.decode(response.body);
    var model;
    var lista = map['Segmentos'];
    if (lisDSeg.isEmpty) {
      lista.forEach((element) async {
        Map obj = element;
        List datos = obj['Datos'];
        datos.forEach((element) {
          try {
            model = Datos.fromJson(element);
            lisDSeg.insert(0, model);
          } catch (e) {
            log(e.toString());
          }
        });
      });
    }
    return lisDSeg;
  }

  Future<List<Indicador>> getIndicatorLubricantes() async {
    final t = await SharedPreferences.getInstance();
    var token = t.getString('token') ?? 'null';
    final headers = {HttpHeaders.authorizationHeader: token};
    final response = await http.get(url, headers: headers);
    Map<String, dynamic> map = json.decode(response.body);
    var model;
    var lista = map['Segmentos'];
    if (lisLub.isEmpty) {
      lista.forEach((element) async {
        try {
          model = Indicador.fromJson(element);
          lisLub.insert(0, model);
        } catch (e) {
          log('error');
        }
      });
    }
    return lisLub;
  }

  Future<List<Datos>> getDatosLubricantes() async {
    final t = await SharedPreferences.getInstance();
    var token = t.getString('token') ?? 'null';
    final headers = {HttpHeaders.authorizationHeader: token};
    final response = await http.get(url, headers: headers);
    Map<String, dynamic> map = json.decode(response.body);
    var model;
    var lista = map['Segmentos'];
    if (lisDLub.isEmpty) {
      lista.forEach((element) async {
        Map obj = element;
        List datos = obj['Datos'];
        datos.forEach((element) {
          try {
            model = Datos.fromJson(element);
            lisDLub.insert(0, model);
          } catch (e) {
            log(e.toString());
          }
        });
      });
    }
    return lisDLub;
  }
}
