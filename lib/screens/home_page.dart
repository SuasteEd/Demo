import 'package:enermax/screens/login_page.dart';
import 'package:enermax/screens/map_page.dart';
import 'package:enermax/widgets/drawer_widget.dart';
import 'package:enermax/widgets/indicadores_list.dart';
import 'package:enermax/widgets/lubricantes.dart';
import 'package:enermax/widgets/segmentos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/indicadores_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final controller = Get.put(IndicadoresController());
final meses = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];
List<String> items = <String>['General', 'Segmentos', 'Lubricantes'];
String dropdownValue = 'General';
final date = DateTime.now();
String e = '';

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Indicadores',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final login = await SharedPreferences.getInstance();
                            setState(() {
                              login.clear();
                            });
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                          child: Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Text(
                      '${meses[date.month - 1]} ${date.day}',
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SizedBox(
                        height: 50,
                        child: Container(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: Colors.grey, width: 2.0)),
                          child: DropdownButton(
                            hint: const Text('Seleccione el indicador'),
                            isExpanded: true,
                            dropdownColor: Colors.grey,
                            elevation: 5,
                            iconSize: 36,
                            onChanged: (value) {
                              setState(() {
                                dropdownValue = value!;
                                e = value;
                              });
                            },
                            value: dropdownValue,
                            items: items.map((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 200,
                        child: lista(e),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Center(
              child: Icon(
            Icons.assistant_navigation,
            color: Colors.black,
            size: 56,
          )),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Maps()),
                (route) => false);
          },
        ),
      ),
    );
  }

  Widget lista(e) {
    if (e == 'General') {
      return const IndicadoresList();
    }
    if (e == 'Segmentos') {
      return const Segmentos();
    }
    if (e == 'Lubricantes') {
      return const Lubricantes();
    }
    return const IndicadoresList();
  }
}
