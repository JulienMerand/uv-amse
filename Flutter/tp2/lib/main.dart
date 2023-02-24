import 'package:flutter/material.dart';
import 'exo1.dart';
import 'exo2.dart';
import 'exo4.dart';
import 'exo5.dart';
import 'exo6.dart';
import 'exo7.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TP2',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Mon Taquin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        primary: false,
        padding: const EdgeInsets.all(10),
        children: List.generate(exos.length, (index) {
          return Card(
            margin: const EdgeInsets.all(5.0),
            child: ListTile(
              // contentPadding:
              //     const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text(exos[index].titre),
              subtitle: Text(exos[index].soustitre),
              trailing: const Icon(Icons.keyboard_arrow_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: exos[index].buildfnct,
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class Exos {
  final String titre;
  final String soustitre;
  final WidgetBuilder buildfnct;

  const Exos(this.titre, this.soustitre, this.buildfnct);
}

List exos = [
  Exos("Exercice 1", "Affichage de l'image", (context) => const DisplayImage()),
  Exos("Exercice 2", "Resize / Rotation", (context) => const Transformation()),
  Exos("Exercice 4", "Affichage d'une tuile",
      (context) => const DisplayTileWidget()),
  Exos("Exercice 5", "Génération du plateau de tuiles",
      (context) => const BoardConfig()),
  Exos("Exercice 6", "Echange entre 2 tuiles",
      (context) => const PositionedTiles()),
  Exos("Exercice 7", "Jeu du Taquin", (context) => const Taquin()),
];
