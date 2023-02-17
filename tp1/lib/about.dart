import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 40, 72),
          title: const Text("Infos")),
      body: const infoAbout(),
    ));
  }
}

class infoAbout extends StatelessWidget {
  const infoAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text("A propos");
  }
}
