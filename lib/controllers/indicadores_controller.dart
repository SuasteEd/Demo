import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:enermax/models/datos.dart';
import 'package:enermax/repository/indicadores_repository.dart';
import 'package:get/get.dart';
import '../models/indicador.dart';

class IndicadoresController extends GetxController {
  final loading = false.obs;
  final connection = false.obs;
  final indicador = <Indicador>[].obs;
  final datos = <Datos>[].obs;
  final indicadorL = <Indicador>[].obs;
  final datosL = <Datos>[].obs;
  final indicadorS = <Indicador>[].obs;
  final datosS = <Datos>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getIndicador() async {
    try {
      final newIndicador =
          await Get.find<IndicadoresRepository>().getIndicador();
      if (indicador.isEmpty) {
        newIndicador.forEach((element) {
          indicador.insert(0, element);
        });
      }
      loading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getDatos() async {
    try {
      final newIndicador = await Get.find<IndicadoresRepository>().getDatos();
      if (datos.isEmpty) {
        newIndicador.forEach((element) {
          datos.insert(0, element);
        });
      }
      loading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getIndicadorSegmentos() async {
    try {
      final newIndicador =
          await Get.find<IndicadoresRepository>().getIndicadorSegmentos();
      if (indicador.isEmpty) {
        newIndicador.forEach((element) {
          indicadorS.insert(0, element);
        });
      }
      loading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getDatosSegmentos() async {
    try {
      final newIndicador =
          await Get.find<IndicadoresRepository>().getDatosSegmentos();
      if (datos.isEmpty) {
        newIndicador.forEach((element) {
          datosS.insert(0, element);
        });
      }
      loading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getIndicadorLubricantes() async {
    try {
      final newIndicador =
          await Get.find<IndicadoresRepository>().getIndicadorLubricantes();
      if (indicador.isEmpty) {
        newIndicador.forEach((element) {
          indicadorL.insert(0, element);
        });
      }
      loading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getDatosLubricantes() async {
    try {
      final newIndicador =
          await Get.find<IndicadoresRepository>().getDatosLubricantes();
      if (datos.isEmpty) {
        newIndicador.forEach((element) {
          datosL.insert(0, element);
        });
      }
      loading.value = false;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> refreshIndicadores() async {
    indicador.clear();
    datos.clear();
    getAll();
  }

  Future<void> getAll() async {
    await internet();
    await getIndicador();
    await getDatos();
    await getDatosSegmentos();
    await getIndicadorSegmentos();
    await getIndicadorLubricantes();
    await getDatosLubricantes();
  }

  Future<void> internet() async {
    try {
      final resultado = await InternetAddress.lookup('google.com');
      if (resultado.isNotEmpty && resultado[0].rawAddress.isNotEmpty) {
        connection.value = true;
      } else {
        connection.value = false;
      }
    } catch (e) {
      print('Error: $e');
      connection.value = false;
    }
  }
}
