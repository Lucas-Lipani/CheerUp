import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class Home extends StatefulWidget {

  String id_usuario;

  Home(this.id_usuario);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('evento').orderBy('voto_evento', descending: true).snapshots();


  _upVoteEvento(String id_evento) async{
    print('Cheguei no upvote com o id ' + id_evento);

    var collection = FirebaseFirestore.instance.collection('evento');
    collection
        .doc(id_evento).
    update({'voto_evento' : FieldValue.increment(1)}) // <-- Nested value
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  _downVoteEvento(String id_evento) async{
    print('Cheguei no downvote com o id ' + id_evento);
    var collection = FirebaseFirestore.instance.collection('evento');
    collection
        .doc(id_evento).
        update({'voto_evento' : FieldValue.increment(-1)}) // <-- Nested value
        .then((_) => print('Updated'))
        .catchError((error) => print('Update failed: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Algo errado');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Carregando");
        }

        return ListView(
          children: snapshot.data.docs
              .map((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),

              ),
              elevation: 10,
              shadowColor: Colors.grey,

              child: ListTile(
                onTap: () {
                  //print("Clique com onTap ${indice}");
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(data["nome_evento"], style: TextStyle(fontWeight: FontWeight.bold)),
                          titleTextStyle: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                          ),

                          content: Text('Decrição do evento: \n' + data["descricao_evento"] +
                          '\n\nLocal do evento: \n' + data["local_evento"] +
                          '\n\nData do evento: \n' + data["data_evento"]),
                          actions: <Widget>[ //definir widgets
                            TextButton(
                                onPressed: () {
                                  _downVoteEvento(document.id);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => Inicio(widget.id_usuario)),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  primary: Colors.white,
                                ),
                                child: Text("Down")
                            ),
                            TextButton(
                                onPressed: () {
                                  _upVoteEvento(document.id);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => Inicio(widget.id_usuario)),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  primary: Colors.white,
                                ),
                                child: Text("Up")
                            ),
                          ],
                        );
                      }
                  );
                },
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                  child: Text(data["nome_evento"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),),
                subtitle: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
                  child:Text(data["descricao_evento"]),
              ),)
            );
          }).toList().cast(),
        );
      },
    );
  }
}