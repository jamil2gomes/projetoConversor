import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://economia.awesomeapi.com.br/all";

void main() async {

  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _dolar, _euro;
  final _realController  = TextEditingController();
  final _dolarController = TextEditingController();
  final _euroController  = TextEditingController();

  void _clearAll(){
     _realController.text = '';
     _dolarController.text = '';
     _euroController.text = '';
  }
  void _realChanged(String text){
    if(text.isEmpty){
    _clearAll();
    }
    double dolar = double.parse(_dolar);
    double euro = double.parse(_euro);
    double valor = double.parse(text);
    _dolarController.text = (valor*dolar).toStringAsFixed(2);
    _euroController.text = (valor*euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
    }
    double dolar = double.parse(_dolar);
    double euro = double.parse(_euro);
    double valor = double.parse(text);
    _realController.text = (valor  * dolar).toStringAsFixed(2);
    _euroController.text = ((valor * dolar)/euro).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
    }
    double dolar = double.parse(_dolar);
    double euro = double.parse(_euro);
    double valor = double.parse(text);

    _realController.text = (euro * valor).toStringAsFixed(2);
    _dolarController.text = (valor * euro/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversor de Moedas'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return _mensagem(context, 'Carregando Dados');
              default:
                if (snapshot.hasError) {
                  return _mensagem(context, 'Erro ao carregar dados');
                } else {
                  _dolar = snapshot.data["USD"]["high"];
                  _euro = snapshot.data["EUR"]["high"];
                  return _formPrincipal(context);
                }
            }
          }),
    );
  }


  Widget _formPrincipal(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Icon(
            Icons.monetization_on,
            size: 150.0,
            color: Colors.amber,
          ),
          _buildTextField('Reais', "R\$", _realController, _realChanged),
          Divider(),
          _buildTextField('Dolar', "US\$", _dolarController, _dolarChanged),
          Divider(),
          _buildTextField('Euro', "€",_euroController, _euroChanged),
        ],
      ),
    );
  }
}

Widget _mensagem(BuildContext context, String texto) {
  return Center(
      child: Text(
    texto,
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    textAlign: TextAlign.center,
  ));
}


Widget _buildTextField(String label, String prefix, TextEditingController tec, Function function) {
  return TextField(
    keyboardType: TextInputType.number,
    controller: tec,
    decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder()),
    style: TextStyle(color: Colors.amber, fontSize: 25.0),
    onChanged: function,
  );
}


