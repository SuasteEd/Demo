import 'package:enermax/data_source/rest.dart';
import 'package:enermax/repository/indicadores_repository.dart';
import 'package:enermax/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize DataSource
  final indicadorDataSource = Rest();
  //Create the repository and pass it the DataSource and the database.
  final indicadorRepository = IndicadoresRepository(indicadorDataSource);
  //ClienteRepository inyection.
  Get.put(indicadorRepository);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}
