import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text("Accueil")),
      body: const infoHome(),
    ));
  }
}

class infoHome extends StatelessWidget {
  const infoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("Page d'accueil");
  }
}
