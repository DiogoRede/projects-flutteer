import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'dart:async';

import 'dart:convert';

const request = "http://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL";

void main() {
  runApp(
    MaterialApp(
      home: const Home(),
      theme: ThemeData(
        hintColor: Colors.yellow,
        primaryColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
          hintStyle: TextStyle(color: Colors.yellow),
        ),
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late double dolar;
  late double euro;

  final realController = TextEditingController();
  final euroController = TextEditingController();
  final dolarController = TextEditingController();

  void _realChanged(String text) {
    print(text);
  }

  void _euroChanged(String text) {
    print(text);
  }

  void _dolarChanged(String text) {
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          '\$ Conversor \$',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  'Carregando dados...',
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text('Erro ao carregar os dados'),
                );
              } else {
                dolar = double.parse(snapshot.data!['USDBRL']['high']);
                euro = double.parse(snapshot.data!['EURBRL']['high']);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.yellow,
                      ),
                      buildTextField(
                          'Reais', 'R\$ ', realController, _realChanged),
                      const Divider(),
                      buildTextField(
                          'Dolares', 'US\$ ', dolarController, _dolarChanged),
                      const Divider(),
                      buildTextField(
                          'Euros', '€ ', euroController, _euroChanged),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function func) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.yellow),
      prefixText: prefix,
    ),
    onChanged: (text) {
      func(text);
    },
    style: const TextStyle(color: Colors.yellow),
    keyboardType: TextInputType.number,
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}
