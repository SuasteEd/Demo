import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/indicadores_controller.dart';

class Segmentos extends StatefulWidget {
  const Segmentos({Key? key}) : super(key: key);

  @override
  _SegmentosState createState() => _SegmentosState();
}

class _SegmentosState extends State<Segmentos> {
  var time = 5;
  final controller = Get.put(IndicadoresController());
  final date = DateTime.now();
  String act = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Get.put(IndicadoresController()).getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var itemCount = controller.datosS.length;
      return itemCount == 0
          ? data()
          : RefreshIndicator(
              color: Colors.black,
              onRefresh: () {
                setState(() {
                  act =
                      '${date.day}/${date.month}/${date.year}  ${date.hour}:${date.minute}:${date.second}';
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    'Última actualización $act',
                  ),
                  backgroundColor: Colors.grey,
                  elevation: 10,
                  duration: const Duration(seconds: 1),
                ));
                return controller.refreshIndicadores();
              },
              child: ListView.separated(
                separatorBuilder: ((context, index) {
                  return Divider(
                    color: Colors.grey[400],
                  );
                }),
                itemCount: controller.datosS.length,
                itemBuilder: (context, index) {
                  final indicador = controller.indicadorS[index];
                  final datos = controller.datosS[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          indicador.titulo,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${datos.etiqueta}   ${datos.valor}',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 20),
                        ),
                      ],
                    ),
                    trailing: Column(
                      children: <Widget>[
                        Text(
                          indicador.valor.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          width: 75,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red,
                          ),
                          child: Text(
                            datos.kpi.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
    });
  }

  Widget data() {
    if (controller.connection.isFalse) {
      return GestureDetector(
        onTap: () {
          setState(() {
            time = 1;
          });
          controller.getAll();
        },
        child: const Center(
            child: Text('No hay conexión a internet',
                style: TextStyle(color: Colors.white))),
      );
    }
    if (controller.datosS.isEmpty && controller.indicadorS.isEmpty) {
      return GestureDetector(
        onTap: () {
          setState(() {
            time = 1;
          });
          controller.getAll();
        },
        child: const Center(
            child: Text(
          'No hay datos qué mostrar',
          style: TextStyle(color: Colors.white),
        )),
      );
    }
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }
}
