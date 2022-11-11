import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:navegacao/firebase_options.dart';
import 'Perfil.dart';
import 'Home.dart';
import 'Sobre.dart';
import 'Cadastro.dart';
import 'Login.dart';


Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Cheers Up',
    home: Login(),
  ));

}

class Inicio extends StatefulWidget {
  String id_usuario;

  Inicio(this.id_usuario);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  String titulo = "Cheer UP";


  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String id_usuario = widget.id_usuario;
    final List<Widget> _telas = [
      Home(id_usuario),
      Cadastro(id_usuario),
      Perfil(id_usuario),
      Sobre()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Início",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: "Cadastro",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Perfil",
              backgroundColor: Colors.black),
          BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: "Sobre",
              backgroundColor: Colors.black),
        ],
      ),
    );
  }
}



