import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:ui' as ui;
import '../Models/clientes.dart';
import '../data_source/db.dart';
import '../models/check_in.dart';
import '../models/clientesDiaMap.dart';
import '../repository/funciones.dart';
import 'home_page.dart';

class Maps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MapScreen> {
  late SharedPreferences logindata;
  late String token = "";
  final urlDetalle =
      Uri.parse("https://enersis.azurewebsites.net/api/Pedido/LibroDeRuta");
  final urlVisita =
      Uri.parse("https://enersis.azurewebsites.net/api/VisitaComercial/Nueva");
  late GoogleMapController mapController; //contrller for Google map
  late Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation = const LatLng(27.7089427, 85.3086209);
  Set<Circle> _circles = HashSet<Circle>();
  late Database _database;
  late AccionRepository _accionRepo;
  List<clientesDia> _clientes = List.empty();
  DateTime date = DateTime.now();
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("LUNES"), value: "1"),
      DropdownMenuItem(child: Text("MARTES"), value: "2"),
      DropdownMenuItem(child: Text("MIERCOLES"), value: "3"),
      DropdownMenuItem(child: Text("JUEVES"), value: "4"),
      DropdownMenuItem(child: Text("VIERNES"), value: "5"),
      DropdownMenuItem(child: Text("SABADO"), value: "6"),
      DropdownMenuItem(child: Text("DOMINGO"), value: "7")
    ];
    return menuItems;
  }

  String selectedValue = "";

  @override
  void initState() {
    initial();
    super.initState();
    initVariables();
    selectedValue = date.weekday.toString();
  }

  initVariables() async {
    _database = await DatabaseConnection.initiateDataBase();
    _accionRepo = AccionRepository(_database);
    refreshGrid();
    mostrarCheck();
    mostrarClientes(int.parse(selectedValue.toString()));
    getClientes();
    getToken();
    _determinePosition();
  }

  void getToken() async {
    final t = await SharedPreferences.getInstance();
    setState(() {
      token = t.getString('token') ?? 'vacío';
    });
  }

  void refreshGrid() async {
    var nuevosClientes =
        await _accionRepo.getAllAcciones(int.parse(selectedValue.toString()));
    setState(() {
      _clientes = nuevosClientes;
    });
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      token = logindata.getString('token')!;
    });
  }

  //Convertir imagen
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  //Permiso de ubicación
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.high);
  }
  //Fin permisos

  //Abrir maps
  static Future<void> openMap(double lat, double lng) async {
    Uri url = Uri.parse('geo:$lat,$lng?q=$lat,$lng');
    launchUrl(url);
  }

  //Mostrar clientes
  void mostrarClientes(int dia) async {
    List<clientesDia> _clientes = List.empty();
    _clientes = await _accionRepo.getAllAcciones(dia);
    _clientes.forEach((element) async {
      final Uint8List markerIcon = await getBytesFromAsset(
          'assets/iconos/ubicacion${element.orden}.png', 100);
      if (element.latitud != null) {
        setState(() {
          markers.add(Marker(
            markerId: MarkerId(element.id.toString()),
            position: LatLng(element.latitud, element.longitud),
            infoWindow: InfoWindow(
              title: element.domicilio,
              snippet: element.nombre,
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ));
          _circles.add(Circle(
            circleId: CircleId(element.id.toString()),
            center: LatLng(element.latitud, element.longitud),
            radius: 30,
            strokeColor: const Color.fromRGBO(3, 169, 244, .5),
            strokeWidth: 2,
            fillColor: const Color.fromRGBO(3, 169, 244, .5),
          ));
        });
      }
    });
  }

  //Mostrar clientes
  void mostrarCheck() async {
    List<check_inn> _checks = List.empty();
    _checks = await _accionRepo.getAllCheck();
    print(_checks);
    _checks.forEach((element) async {
      if (element.latitud != null) {
        setState(() {
          markers.add(Marker(
            markerId: MarkerId(element.latitud.toString()),
            position: LatLng(element.latitud, element.longitud),
            infoWindow: InfoWindow(
              title: element.title,
              snippet: element.snippet,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow),
          ));
        });
      }
    });
  }

  //Agregar marcador de check
  void AgregarCheck(int id) async {
    try {
      DateTime date = DateTime.now();
      Position position = await _determinePosition();
      await _accionRepo.update(id);
      refreshGrid();
      var modelo = check_inn(
          date.day,
          id,
          position.latitude == null ? 0.0 : position.latitude.toDouble(),
          position.longitude == null ? 0.0 : position.longitude.toDouble(),
          "Punto: ${id} Fecha: ${date.day}/${date.month}/${date.year}",
          "Hora: ${date.hour} : ${date.minute} : ${date.second}");
      await _accionRepo.registerCheck(modelo);
      setState(() {
        markers.add(Marker(
          markerId: MarkerId(position.latitude.toString()),
          position: LatLng(
              position.latitude, position.longitude), //position of marker
          infoWindow: InfoWindow(
            title: "Punto: ${id} Fecha: ${date.day}/${date.month}/${date.year}",
            snippet: "Hora: ${date.hour} : ${date.minute} : ${date.second}",
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueYellow), //Icon for Marker
        ));
      });
      final snackBar = SnackBar(
        content: const Text('Se realizó el check in exitosamente'),
        backgroundColor: Colors.green,
        elevation: 10,
        duration: new Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on SocketException catch (_) {
      print("error");
      final snackBar = SnackBar(
        content: const Text('No se pudo realizar el check in'),
        backgroundColor: Colors.red,
        elevation: 10,
        duration: new Duration(seconds: 1),
      );
    }
    Navigator.pop(context, '');
  }

  terminarRuta() async {
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token
    };
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        List<check_inn> _visitas = List.empty();
        _visitas = await _accionRepo.getAllCheck();
        _visitas.forEach((element) async {
          if (element.latitud != null) {
            try {
              final cliente = {
                "ClienteId": element.id,
                "Latitud": element.latitud,
                "Longitud": element.longitud
              };
              final String jsonString = jsonEncode(cliente);
              var response = await http.post(urlVisita,
                  headers: headers, body: jsonString);
              if (response.statusCode == 200) {
                _accionRepo.deleteCheck(element.id);
                _accionRepo.updateCheck(element.id);
              }
            } on SocketException catch (_) {}
          }
          setState(() {});
        });
      }
      final snackBar = SnackBar(
        content: const Text('Ruta terminada exitosamente!'),
        backgroundColor: Colors.green,
        elevation: 10,
        duration: new Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on SocketException catch (_) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Sin conexión a internet'),
          content: const Text(
              'Para terminar la ruta necesita tener conexión a internet'),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('Aceptar'),
              ),
            ),
          ],
        ),
      );
    }
    Navigator.pop(context, '');
    /* mostrarCheck(); */
  }

  getClientes() async {
    //Headers
    final headers = {HttpHeaders.authorizationHeader: token};
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http.get(urlDetalle, headers: headers);
        Map<String, dynamic> map = json.decode(response.body);
        final lista = map["Dias"];
        if (lista != null) {
          lista.forEach((element) {
            Map obj = element;
            List ll = obj['Clientes'];
            int dia = obj['Dia'];
            ll.forEach((element) async {
              try {
                var modelo = clientesDia(
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
                await _accionRepo.register(modelo);
              } on Exception catch (_) {
                print('Cliente duplicado');
              }
            });
          });
        } else {
          print("Lista vacia");
        }
      }
    } on SocketException catch (_) {
      print('sin conexion');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomePage()),
                    (route) => false);
              },
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 158),
              child: Text('Tus rutas'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: GoogleMap(
          //Widget del mapa
          zoomGesturesEnabled: true, //zoom del mapa
          initialCameraPosition: const CameraPosition(
            target: LatLng(
                21.146963839869848, -101.70971301771652), //initial position
            zoom: 10,
          ),
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          markers: getmarkers(),
          mapType: MapType.normal,
          circles: _circles,
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
          },
        ),
      ), //Muesta el modal con la lista de clientes
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            context: context,
            builder: (BuildContext context) => Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 0, top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'RESUMEN DE RUTA.',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: <Widget>[
                              Text(
                                'No.Clientes:  ${_clientes.length}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, top: 5),
                                child: Column(
                                  children: <Widget>[
                                    DropdownButton(
                                        value: selectedValue,
                                        icon:
                                            const Icon(Icons.view_day_outlined),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedValue = newValue!;
                                            markers = Set();
                                            refreshGrid();
                                            mostrarClientes(int.parse(
                                                selectedValue.toString()));
                                            mostrarCheck();
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        items: dropdownItems)
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, top: 5),
                                child: Column(
                                  children: <Widget>[
                                    ElevatedButton(
                                        onPressed: () {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text(
                                                  '¿Está seguro que quiere terminar la ruta?'),
                                              content: const Text(''),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, ''),
                                                  child: const Text('NO'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    terminarRuta();
                                                    Navigator.pop(context, '');
                                                  },
                                                  child: const Text('SÍ'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: const Text('Terminar'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: const <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(left: 60, top: 5),
                                    child: Text(
                                      "Cliente",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 65, top: 5),
                              child: Column(
                                children: const <Widget>[
                                  Text(
                                    "Domicilio",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: 370,
                            child: ListView.builder(
                              itemCount: _clientes.length,
                              itemBuilder: (context, index) {
                                final item = _clientes[index];
                                return GestureDetector(
                                    onTap: () {
                                      openMap(item.latitud, item.longitud);
                                    },
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(children: <Widget>[
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width: 60,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 5,
                                                                bottom: 5),
                                                        child: Text(item.orden
                                                            .toString()),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(
                                                  width: 115,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10,
                                                                bottom: 10),
                                                        child:
                                                            Text(item.nombre),
                                                      )
                                                    ],
                                                  )),
                                              SizedBox(
                                                  width: 170,
                                                  child: Column(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 10,
                                                                bottom: 10),
                                                        child: Text(
                                                            item.domicilio),
                                                      )
                                                    ],
                                                  )),
                                              SizedBox(
                                                width: 30,
                                                child: Column(
                                                  children: <Widget>[
                                                    IconButton(
                                                        onPressed:
                                                            item.checado != 1
                                                                ? () {
                                                                    setState(
                                                                        () {});
                                                                    showDialog<
                                                                            String>(
                                                                        context:
                                                                            context,
                                                                        builder: (BuildContext
                                                                                context) =>
                                                                            AlertDialog(
                                                                              title: const Text('Check In'),
                                                                              content: Text('¿Desea realizar un check in con el cliente ${item.nombre}?'),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed: () => Navigator.pop(context, ''),
                                                                                  child: const Text('NO'),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    AgregarCheck(item.id);
                                                                                    Navigator.pop(context, '');
                                                                                  },
                                                                                  child: const Text('SI'),
                                                                                ),
                                                                              ],
                                                                            ));
                                                                  }
                                                                : null,
                                                        icon: Icon(item
                                                                    .checado !=
                                                                1
                                                            ? Icons
                                                                .check_box_outline_blank_outlined
                                                            : Icons
                                                                .check_box_outlined))
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ])));
                              },
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        mini: false,
        child: const Icon(
          Icons.list_alt,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Set<Marker> getmarkers() {
    setState(() {});
    return markers;
  }
}
