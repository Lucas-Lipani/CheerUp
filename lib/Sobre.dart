import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:navegacao/utilities/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  Widget buildAbout() => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                "Plataforma interativa para divulgação de eventos e avaliação dos mesmos pelos usuários. O aplicativo tem de a conectar mais os clientes e os donos de eventos, podendo receber um feedback e ajudar na divulgação.\nO aplicativo faz parte do ensino prático da matéria de Laboratório de Desenvolvimento de Dispositivos Móveis do curso de Engenharai de Computação 2022 1º Semestre.",
                //style: TextStyle(fontSize: 16, height: 1.4, color: Colors.white),
                style: kLabelStyle,

              )
          ),

        ),
      ],
    ),
  );

  Widget _buildVersionText() {
    return Column(
      children: <Widget>[
        SizedBox(height: 20.0),
        Text(
          'Versão 1.0.0',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocial1Btn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  _openFacebook() async{
    const url = "https://pt-br.facebook.com";
    if (await canLaunch(url)){
    await launch(url);
    } else {
    // can't launch url
    }
  }

  _openGoogle() async{
    const url = "https://www.pucminas.br/unidade/coracao-eucaristico/ensino/graduacao/Paginas/Engenharia-da-Computacao.aspx";
    if (await canLaunch(url)){
      await launch(url);
    } else {
      // can't launch url
    }
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocial1Btn(
                () => _openFacebook(),
            AssetImage(
              'assets/logos/facebook.jpg',
            ),
          ),
          _buildSocial1Btn(
                () =>  _openGoogle(),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),
        ],
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
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'CheerUp',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildVersionText(),
                      SizedBox(height: 30.0),
                      buildAbout(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildSocialBtnRow(),
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