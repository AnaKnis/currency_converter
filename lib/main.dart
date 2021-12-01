import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=b379af9b";

void main() async {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController();

  double? dolar;
  double? euro;
  double? libra;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
    libraController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real * dolar!).toStringAsFixed(2);
    euroController.text = (real * euro!).toStringAsFixed(2);
    libraController.text = (real * libra!).toStringAsFixed(2);
  }

  void _dolarChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar / this.dolar!).toStringAsFixed(2);
    euroController.text = (dolar / this.dolar! * euro!).toStringAsFixed(2);
    libraController.text = (dolar / this.dolar! * libra!).toStringAsFixed(2);
  }

  void _euroChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro / this.euro!).toStringAsFixed(2);
    dolarController.text = (euro / this.euro! * dolar!).toStringAsFixed(2);
    libraController.text = (euro / this.euro! * libra!).toStringAsFixed(2);
  }

  void _libraChanged(String text){
    if(text.isEmpty){
      _clearAll();
      return;
    }
    double libra = double.parse(text);
    realController.text = (libra / this.libra!).toStringAsFixed(2);
    dolarController.text = (libra / this.libra! * dolar!).toStringAsFixed(2);
    euroController.text = (libra / this.libra! * euro!).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          "Conversor de Moedas",
        ),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando Dados...",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                Center(
                  child: Text(
                    "Erro ao Carregar Dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }
          }
          dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
          euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
          libra = snapshot.data!["results"]["currencies"]["GBP"]["buy"];
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.monetization_on,
                    size: 150.0,
                    color: Colors.amber,
                  ),
                  buildTextField("Reais", "R\$", realController, _realChanged),
                  SizedBox(height: 15.0),
                  buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                  SizedBox(height: 15.0),
                  buildTextField("Euros", "€", euroController, _euroChanged),
                  SizedBox(height: 15.0),
                  buildTextField("Libras", "£", libraController, _libraChanged),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

buildTextField(String label, String prefix, TextEditingController controller,
    Function(String) function
    ) {
  return TextFormField(
    controller: controller,
    onChanged: function,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            fontSize: 15.0
        ),
        border: OutlineInputBorder(),
        prefixText: prefix
    ),
  );
}
