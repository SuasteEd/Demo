import 'package:enermax/data_source/rest.dart';
import 'package:enermax/models/datos.dart';
import 'package:enermax/models/indicador.dart';

class IndicadoresRepository {
  final Rest _rest;
  IndicadoresRepository(this._rest);

  Future<List<Indicador>> getIndicador() async {
    List<Indicador> indicador = await _rest.getIndicator();
    return indicador;
  }

  Future<List<Datos>> getDatos() async {
    List<Datos> datos = await _rest.getDatos();
    return datos;
  }

  Future<List<Indicador>> getIndicadorSegmentos() async {
    List<Indicador> indicador = await _rest.getIndicator();
    return indicador;
  }

  Future<List<Datos>> getDatosSegmentos() async {
    List<Datos> datos = await _rest.getDatos();
    return datos;
  }

  Future<List<Indicador>> getIndicadorLubricantes() async {
    List<Indicador> indicador = await _rest.getIndicator();
    return indicador;
  }

  Future<List<Datos>> getDatosLubricantes() async {
    List<Datos> datos = await _rest.getDatos();
    return datos;
  }
}
