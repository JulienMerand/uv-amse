import 'package:flutter/material.dart';
import 'liste_medias.dart';

class BDs extends StatelessWidget {
  BDs({super.key});

  final List<String> titrebds = <String>[];

  final List<String> imagesbds = <String>[];

  final List<String> infosbds = <String>[];

  @override
  Widget build(BuildContext context) {
    return ListeOfMedias(
        intitule: 'BDs', titres: titrebds, images: imagesbds, infos: infosbds);
  }
}
