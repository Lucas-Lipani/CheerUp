import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:navegacao/utilities/constants.dart';
import 'package:date_time_picker/date_time_picker.dart';


/*class Cadastro extends StatelessWidget {
  final String texto;

  Cadastro(this.texto);
}*/

class Cadastro extends StatefulWidget {
  String id_usuario;

  Cadastro(this.id_usuario);

  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllernomeEvento = TextEditingController();
  TextEditingController _controllerdescrEvento = TextEditingController();
  TextEditingController _controllerlocalEvento = TextEditingController();
  String hora_evento;

  _salvarDados2(String nome, String desc, String local, String data) async {
    var db = FirebaseFirestore.instance;
    final evento_infos = <String, dynamic>{
      "nome_evento" : nome,
      "descricao_evento" : desc,
      "local_evento" : local,
      "data_evento" : data,
      "voto_evento" : 0.toInt(),
      "data_cadastro" : DateTime.now(),
      "id_usuario" : widget.id_usuario
    };
    db.collection('evento').add(evento_infos);

    ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
      content: Text("Evento salvo"),
    ));
  }

  Widget _buildNomeTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Nome do Evento:',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 7.0),
              //hintText: 'Insira seu email',
              hintStyle: kHintTextStyle,
            ),
            controller: _controllernomeEvento,
          ),
        ),
      ],
    );
  }

  Widget _buildDescTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Descrição do Evento:',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 7.0),
              //hintText: 'Insira sua senha',
              hintStyle: kHintTextStyle,
            ),
            controller: _controllerdescrEvento,
          ),
        ),
      ],
    );
  }

  Widget _buildLocalTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Local do Evento:',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 7.0),
              //hintText: 'Insira sua senha',
              hintStyle: kHintTextStyle,
            ),
            controller: _controllerlocalEvento,
          ),
        ),
      ],
    );
  }

  Widget _buildDataTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Data e Hora do Evento:',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,

          child: DateTimePicker(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 7.0),
              hintStyle: kHintTextStyle,
            ),
            type: DateTimePickerType.dateTimeSeparate,
            dateMask: 'dd/MM/yyyy',
            //initialValue: DateTime.now().toString(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
            //icon: Icon(Icons.event),
            //dateLabelText: 'Data',
            style: TextStyle(color: Colors.white),
            //controller: _controllerhoraEvento,
            //timeLabelText: "Hora",
            //onChanged: (val) => print(val),

            onChanged: (val) {
              print(val);
              setState(() { hora_evento = val;});
            },
            validator: (val) {
              print(val);
              return null;
            },
            onSaved: (val) => print(val),
          ),
        ),
      ],
    );
  }

  Widget _buildCadastrarBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          if(_controllernomeEvento.text.isNotEmpty && _controllerdescrEvento.text.isNotEmpty && _controllerlocalEvento.text.isNotEmpty && hora_evento.isNotEmpty){
            _salvarDados2(_controllernomeEvento.text, _controllerdescrEvento.text, _controllerlocalEvento.text, hora_evento);
          }else{
            ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
              content: Text("Preencha todos os campos"),
            ));
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Cadastrar',
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
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
                    Color(0xFF63A2F5),
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
                  vertical: 10.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Cadastro de Evento',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    _buildNomeTF(),
                    SizedBox(height: 10.0,),
                    _buildDescTF(),
                    SizedBox(height: 10.0,),
                    _buildLocalTF(),
                    SizedBox(height: 10.0,),
                    _buildDataTF(),
                    SizedBox(height: 10.0,),
                    _buildCadastrarBtn(),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}