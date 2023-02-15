import 'dart:core';
import 'package:flutter/material.dart';

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
        leading: const BackButton(),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: List.generate(titres.length, (index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(image: AssetImage(images[index])),
              Text(titres[index]),
            ],
          );
        }),
      ),
    ));
  }
}
