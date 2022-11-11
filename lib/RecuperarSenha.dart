import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navegacao/utilities/constants.dart';
import 'Login.dart';

class RecuperarSenha extends StatefulWidget {
  @override
  _RecuperarSenhaState createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  String email_recuperado;
  TextEditingController _controlleremailUsuario = TextEditingController();

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Insira seu email',
              hintStyle: kHintTextStyle,
            ),
            controller: _controlleremailUsuario,
          ),
        ),
      ],
    );
  }

  Future <void>  _procuraEmail() async{
    var db = FirebaseFirestore.instance;
    final userRef = db.collection("usuario");
    userRef.where("email_usuario", isEqualTo: _controlleremailUsuario.text).get().then(
          (res) => {
            for (var doc in res.docs) {
              email_recuperado = doc.data()['email_usuario'],
            },
            print(email_recuperado),
        if (email_recuperado != null) {
          ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text("Você receberá um email para redefinir sua senha"),
          )),
          email_recuperado = null,
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          )
        }
        else {
          ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
            content: Text("O email não consta na base de dados"),
          )),
          email_recuperado = null,
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          )
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  Widget _buildCadastroBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if(_controlleremailUsuario.text.isNotEmpty){
            _procuraEmail();
          }else{
            ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
              content: Text("Preencha o campo de email"),
            ));
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Enviar Email de Confirmação',
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

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Lembrou sua senha? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Entre',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,

              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Cheer UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 10.0,),
                      _buildEmailTF(),
                      SizedBox(height: 10.0,),
                      _buildCadastroBtn(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}