import 'package:flutter/material.dart';

class Medias extends StatelessWidget {
  Medias({super.key});

  final List<String> noms = <String>[
    "Films",
    "Séries",
    "Livres",
    "BDs",
    "Sports"
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisCount: 2,
        children: [
          for (var n in noms)
            ListTile(
              //leading: ,
              title: Text(n),
            ),
        ]);
  }
}
