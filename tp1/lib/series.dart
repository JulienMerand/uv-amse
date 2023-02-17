import 'package:flutter/material.dart';
import 'liste_medias.dart';

class Series extends StatelessWidget {
  Series({super.key});

  final List<String> titreseries = <String>[
    "Breaking Bad (2008)",
    "Game of Thrones (2011)",
    "Twin Peaks (1990)",
    "Kaamelott (2005)",
    "Dexter (2006)",
  ];

  final List<String> imagesseries = <String>[
    "images/series/breaking_bad.jpg",
    "images/series/game_of_thrones.jpg",
    "images/series/twin_peaks.jpg",
    "images/series/kaamelott.jpg",
    "images/series/dexter.jpg",
  ];

  final List<String> infosseries = <String>[
    "Walter White, 50 ans, est professeur de chimie dans un lycée du Nouveau-Mexique. Pour subvenir aux besoins de Skyler, sa femme enceinte, et de Walt Junior, son fils handicapé, il est obligé de travailler doublement. Son quotidien déjà morose devient carrément noir lorsqu'il apprend qu'il est atteint d'un incurable cancer des poumons. Les médecins ne lui donnent pas plus de deux ans à vivre. Pour réunir rapidement beaucoup d'argent afin de mettre sa famille à l'abri, Walter ne voit plus qu'une solution : mettre ses connaissances en chimie à profit pour fabriquer et vendre de la méthamphétamine. Il propose à Jesse, un de ses anciens élèves devenu un petit dealer de seconde zone, de faire équipe avec lui.",
    "Sur le continent de Westeros en proie au retour de l'Hiver, les grands Seigneurs et la fille du roi déchu se disputent le Trône de Fer.",
    "Un meurtre a été commis à Twin Peaks, une petite bourgade en apparence tranquille. La jeune Laura Palmer est retrouvée morte nue au bord d'un lac.",
    "Ve siècle après Jésus-Christ. Au Royaume de Kaamelott, le Roi Arthur, investi d'une mission divine, tente de guider son peuple vers la lumière.",
    "Spécialiste en hématologie le jour, Dexter se transforme la nuit venue en un tueur sanguinaire, froid, méticuleux et imperturbable.",
  ];

  @override
  Widget build(BuildContext context) {
    return ListeOfMedias(
        intitule: 'Séries',
        titres: titreseries,
        images: imagesseries,
        infos: infosseries);
  }
}
