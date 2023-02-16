import 'package:flutter/material.dart';
import 'liste_medias.dart';

class Series extends StatelessWidget {
  Series({super.key});

  final List<String> titreseries = <String>[];

  final List<String> imagesseries = <String>[];

  final List<String> infosseries = <String>[];

  @override
  Widget build(BuildContext context) {
    return ListeOfMedias(
        intitule: 'Séries',
        titres: titreseries,
        images: imagesseries,
        infos: infosseries);
  }
}
