import 'package:flutter/material.dart';
import 'liste_medias.dart';

class Livres extends StatelessWidget {
  Livres({super.key});

  final List<String> titrelivres = <String>[];

  final List<String> imageslivres = <String>[];

  final List<String> infoslivres = <String>[];

  @override
  Widget build(BuildContext context) {
    return ListeOfMedias(
        intitule: 'Livres',
        titres: titrelivres,
        images: imageslivres,
        infos: infoslivres);
  }
}
