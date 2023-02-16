import 'package:flutter/material.dart';
// import 'package:tmdb_api/tmdb_api.dart';
import 'liste_medias.dart';

// final tmdb = TMDB(
//     ApiKeys('cca2a1be4278b1e64e219874701ad6b7',
//           'apiReadAccessTokenv4'),
//     defaultLanguage: 'fr',
//     );

class Films extends StatelessWidget {
  Films({super.key});

  final List<String> titrefilms = <String>[];

  final List<String> imagesfilms = <String>[];

  final List<String> infosfilms = <String>[];

  @override
  Widget build(BuildContext context) {
    return ListeOfMedias(
        intitule: 'Films',
        titres: titrefilms,
        images: imagesfilms,
        infos: infosfilms);
  }
}
