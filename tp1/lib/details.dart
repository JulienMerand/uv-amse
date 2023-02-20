import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class Details extends StatelessWidget {
  const Details(
      {super.key,
      required this.titre,
      required this.image,
      required this.info});

  final String titre;
  final Image image;
  final String info;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    IconData icon;
    if (appState.favtitre.contains(titre)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 40, 72),
        leading: const BackButton(),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: image,
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Center(
                      child: Text(
                        titre,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      icon: Icon(icon),
                      // icon: const Icon(Icons.favorite),
                      label: const Text('Like'),
                      onPressed: () {
                        appState.toggleFavTitre(titre);
                        var current = {};
                        current["titre"] = titre;
                        current["image"] = image;
                        current["info"] = info;
                        appState.toggleFavorite(current);
                      },
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Text(info),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
