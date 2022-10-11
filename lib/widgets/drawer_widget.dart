import 'dart:io';

import 'package:enermax/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String username = '';
  String roles = '';
  bool newUser = false;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    final user = await SharedPreferences.getInstance();
    setState(() {
      username = user.getString('username') ?? 'vacío';
    });
    final rol = await SharedPreferences.getInstance();
    setState(() {
      roles = rol.getString('rol') ?? 'vacío';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Stack(
                children: <Widget>[
                  const Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/logo.png"),
                      backgroundColor: Colors.white,
                      radius: 40.0,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center + const Alignment(0.0, 0.6),
                    child: Text(
                      roles,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 28.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      username,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12.0),
                    ),
                  )
                ],
              ),
            ),
            // ListTile(
            //   onTap: () {},
            //   leading: const Icon(
            //     Icons.person,
            //     color: Colors.black54,
            //   ),
            //   title: const Text(
            //     "Perfil",
            //     style: TextStyle(color: Color.fromARGB(199, 109, 109, 109)),
            //   ),
            // ),
            // ListTile(
            //   onTap: () {},
            //   leading: const Icon(
            //     Icons.settings,
            //     color: Colors.black54,
            //   ),
            //   title: const Text(
            //     "Configuración",
            //     style: TextStyle(color: Color.fromARGB(199, 109, 109, 109)),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 600),
              child: ListTile(
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
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black54,
                ),
                title: const Text(
                  "Log out",
                  style: TextStyle(color: Color.fromARGB(199, 109, 109, 109)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
