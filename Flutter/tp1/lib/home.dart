import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'details.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 40, 72),
          title: const Text("Accueil")),
      body: const Favorites(),
    ));
  }
}

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    List fav = appState.favorites;
    List favTitres = appState.favtitre;

    return ListView(
      primary: false,
      padding: const EdgeInsets.all(10),
      children: List.generate(favTitres.length, (index) {
        String titre = favTitres[index];
        Image image = fav[index]["image"];
        String info = fav[index]["info"];

        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: const EdgeInsets.only(right: 12.0),
            decoration: const BoxDecoration(
                border:
                    Border(right: BorderSide(width: 1.0, color: Colors.blue))),
            child: image,
          ),
          title: Text(titre),
          trailing: const Icon(Icons.keyboard_arrow_right,
              color: Colors.black, size: 30.0),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Details(
                          titre: titre,
                          image: image,
                          info: info,
                        )));
          },
        );
      }),
    );

    // return const Text("A propos");
  }
}
