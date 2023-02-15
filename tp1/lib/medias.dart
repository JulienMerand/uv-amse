import 'package:flutter/material.dart';

class Medias extends StatelessWidget {
  const Medias({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text("Liste des Médias")),
      body: ListeMedias(),
    ));
  }
}

class ListeMedias extends StatelessWidget {
  ListeMedias({super.key});

  final List<Text> noms = <Text>[
    const Text("Films"),
    const Text("Séries"),
    const Text("Livres"),
    const Text("BDs"),
    const Text("Sports"),
  ];

  final List<Icon> icons = <Icon>[
    const Icon(Icons.local_movies),
    const Icon(Icons.live_tv),
    const Icon(Icons.menu_book),
    const Icon(Icons.agriculture),
    const Icon(Icons.sports),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
        padding: const EdgeInsets.all(20),
        children: List.generate(noms.length, (index) {
          return Card(
            child: ListTile(
              leading: icons[index],
              title: noms[index],
              onTap: () {
                print(noms[index]);
              },
            ),
          );
        }));
  }
}
