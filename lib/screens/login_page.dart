import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:enermax/screens/bienvenida.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Variables
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late String user = '';
  late String password = '';
  late bool newUser;
  late SharedPreferences loginData;
  final uri =
      Uri.parse("https://enersis.azurewebsites.net/api/Auth/Authenticate");
  bool isLoading = false;
//initState
  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    log("${date.year}/${date.month}/${date.day}");
    checkIfAlreadyLogin();
  }

//Check if already login
  void checkIfAlreadyLogin() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('login') ?? true);
    log(newUser.toString());
    if (newUser == false) {
      getToken();
      _openPage();
    }
  }

//Clean up controller when the widget is disposed.
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

//Login logic
  void login() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      var res = await http.post(uri,
          body: ({
            "username": usernameController.text,
            "password": passwordController.text
          }));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        loginData.setBool('login', false);
        loginData.setString('username', usernameController.text);
        loginData.setString('password', passwordController.text);
        final token = body['access_token'];
        final rol = body['Roles'][0];
        loginData.setString('rol', rol);
        loginData.setString('token', token);
        _openPage();
      } else {
        setState(() {
          isLoading = false;
        });
        log('Unsuccessfull');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('El usuario o contraseña son incorrectos'),
          backgroundColor: Colors.red,
          elevation: 10,
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(5, 5),
                    spreadRadius: 5,
                  )
                ],
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 252, 21, 21),
                    Color.fromARGB(255, 1, 134, 146)
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(9.0),
              child: Image.asset("assets/logo.png"),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -20),
            child: Center(
              child: SingleChildScrollView(
                child: Card(
                  elevation: 18,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 420, bottom: 2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 30),
                              child: Text(
                                "Iniciar sesión",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: usernameController,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Usuario",
                            labelStyle: const TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: primaryColor, width: 2),
                            ),
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: primaryColor, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        TextFormField(
                          controller: passwordController,
                          autocorrect: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            labelStyle: const TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: primaryColor, width: 2),
                            ),
                            hintText: passwordController.text,
                            isDense: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: primaryColor, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          style: raisedButtonStyle,
                          onPressed: () async {
                            if (usernameController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              const snackBar = SnackBar(
                                content: Text('Complete todos los campos'),
                                backgroundColor: Colors.red,
                                elevation: 10,
                                duration: Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              if (!isLoading) {
                                setState(() {
                                  isLoading = true;
                                  login();
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text(
                                "Iniciar sesión",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (isLoading)
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: const EdgeInsets.only(left: 20),
                                  child: const CircularProgressIndicator(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  validate() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete todos los campos'),
          backgroundColor: Colors.red,
          elevation: 10,
          duration: Duration(seconds: 1),
        ),
      );
    } else {
      if (!isLoading) {
        setState(() {
          isLoading = true;
          login();
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _openPage() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false);
  }

  void getToken() async {
    setState(() {
      user = loginData.getString('username')!;
      password = loginData.getString('password')!;
    });
    if (await internet()) {
      try {
        var res = await http.post(uri,
            body: ({"username": user, "password": password}));
        if (res.statusCode == 200) {
          final body = jsonDecode(res.body);
          final token = body['access_token'];
          loginData.setString('token', token);
        }
      } catch (e) {
        log('error: $e');
      }
    } else {
      log('No internet connection');
    }
  }

  Future<bool> internet() async {
    try {
      final connection = await InternetAddress.lookup('google.com');
      if (connection.isNotEmpty && connection[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
