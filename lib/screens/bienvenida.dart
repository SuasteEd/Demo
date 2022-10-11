import 'package:enermax/screens/home_page.dart';
import 'package:enermax/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';

class Bienvenida extends StatefulWidget {
  const Bienvenida({Key? key}) : super(key: key);

  @override
  _BienvenidaState createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.2, 0.8],
              colors: [
                Color(0xff5EEBC5),
                Color(0xff30BAD6),
              ],
            ),
          ),
          child: PageView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            children: const [Page1(), HomePage()],
          ),
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(),
        drawer: const DrawerWidget(),
        body: Stack(
          children: [const Background(), MainContent()],
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xff30BAD6),
        height: double.infinity,
        alignment: Alignment.topCenter,
        child: const Image(image: AssetImage('assets/logo.png')));
  }
}

class MainContent extends StatelessWidget {
  MainContent({Key? key}) : super(key: key);
  final dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];
  final dia = DateTime.now().weekday - 1;
  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
        fontSize: 50, fontWeight: FontWeight.bold, color: Colors.white);
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              '19°',
              style: textStyle,
            ),
          ),
          Text(
            dias[dia],
            style: textStyle,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 600),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 100,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
