import 'dart:core';
import 'package:flutter/material.dart';
import 'details.dart';

class ListeOfMedias extends StatelessWidget {
  const ListeOfMedias(
      {super.key, this.intitule, this.titres, this.images, this.infos});

  final intitule;
  final titres;
  final images;
  final infos;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text(intitule),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        primary: false,
        padding: const EdgeInsets.all(10),
        children: List.generate(titres.length, (index) {
          return ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: const EdgeInsets.only(right: 12.0),
              decoration: const BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.blue))),
              child: Image(image: AssetImage(images[index])),
            ),
            title: Text(titres[index]),
            trailing: const Icon(Icons.keyboard_arrow_right,
                color: Colors.black, size: 30.0),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Details(
                            titre: titres[index],
                            image: Image(image: AssetImage(images[index])),
                            info: infos[index],
                          )));
            },
          );
        }),
      ),
    ));
  }
}
