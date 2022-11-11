import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:navegacao/utilities/constants.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as path;



class Perfil extends StatefulWidget {
  String id_usuario;

  Perfil(this.id_usuario);
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override

  var email;
  var nome;
  var sobre;

  String profilePicLink = " ";

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  TextEditingController _textoDeEntradaSobre = TextEditingController();

  Future <void> _loaduserInfo() async {
    var db = FirebaseFirestore.instance;
    final userRef = db.collection("usuario");
    await userRef.doc(widget.id_usuario).get().then(
          (value) {
            print(value);
        nome = value.data()['nome_usuario'];
        email = value.data()["email_usuario"];
        sobre = value.data()["sobre_usuario"];
        profilePicLink = value.data()["url"];
         print("${value.id} => ${value.data()}");
        },
        onError: (e) => print("Error getting document: $e"),
    );
  }

  _atualizaFotousuario(String url_atualizada) {
    print("URL que será atualizad " + url_atualizada );
    var collection = FirebaseFirestore.instance.collection('usuario');
    collection
        .doc(widget.id_usuario) // <-- Doc ID where data should be updated.
        .update({'url' : url_atualizada}) // <-- Nested value
        .then((_) => print('Updated URL'))
        .catchError((error) => print('Update failed: $error'));

  }

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );

    Reference ref = FirebaseStorage.instance
        .ref().child("profilepic " + widget.id_usuario + ".jpg");

    await ref.putFile(File(image.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
        print(profilePicLink);
        _atualizaFotousuario(profilePicLink);
      });
    });
  }


  Widget buildAbout() => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sobre',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
            side: BorderSide(color: Colors.white, width: 1),
          ),
          elevation: 0,
          shadowColor: Colors.grey,
          color: Colors.transparent,
          child: Padding(
            padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
            child: Text(
              sobre.toString(),
              //style: TextStyle(fontSize: 16, height: 1.4, color: Colors.white),
              style: kLabelStyle,
            )
          ),
        ),
      ],
    ),
  );

  _displayTextInputDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Insira um breve texto sobre você'),
          content: TextField(
            controller: _textoDeEntradaSobre,
            decoration: InputDecoration(hintText: "Escreva aqui."),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('INSERIR'),
              onPressed: () {
                setState(() { sobre = _textoDeEntradaSobre.text; });
                print(_textoDeEntradaSobre.text);
                Navigator.pop(context);
                if(_textoDeEntradaSobre.text.isNotEmpty){
                  print("Entrou no if");
                  _updateSobre(_textoDeEntradaSobre.text);
                }
                else{
                  print("não entrou no if");
                }
              },
            ),
          ],
        );
      },
    );
  }

  _updateSobre(String sobre) {
    var collection = FirebaseFirestore.instance.collection('usuario');
    collection
        .doc(widget.id_usuario) // <-- Doc ID where data should be updated.
        .update({'sobre_usuario' : sobre}) // <-- Nested value
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
    _loaduserInfo();
  }

  Widget _buildSobreBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _displayTextInputDialog(this.context);
          buildAbout();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Edite seu sobre',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildEmailText() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          email.toString(),
          style: kLabelStyle,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Chegou o id de usuario:" + widget.id_usuario);
    _loaduserInfo();
    return FutureBuilder(
     future: _loaduserInfo(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()) ;
        }
        if (snapshot.hasData) {
          return Text(snapshot.data);
        }

        return Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF73AEF5),
                          Color(0xFF61A4F1),
                          Color(0xFF478DE0),
                          Color(0xFF398AE5),
                        ],
                        stops: [0.1, 0.4, 0.7, 0.9],
                      ),
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 40.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                pickUploadProfilePic();
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 40, bottom: 24),
                                height: 120,
                                width: 120,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),// color: primary,
                                ),
                                child: Center(
                                  child: profilePicLink == " " ? const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 80,
                                  ) : CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(profilePicLink),
                                      radius: 120,
                                      ),
                                ),
                              ),
                            ),
                          Text(
                            nome.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildEmailText(),
                          SizedBox(height: 30.0),
                          buildAbout(),
                          SizedBox(height: 30.0,),
                          _buildSobreBtn()
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}