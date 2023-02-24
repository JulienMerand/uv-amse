import 'package:flutter/material.dart';
import 'liste_medias.dart';

class Livres extends StatelessWidget {
  Livres({super.key});

  final List<String> titrelivres = <String>[
    "1984 (1949)",
    "L'Étranger (1942)",
    "La Horde du contrevent (2004)",
    "Le Petit Prince (1943)",
    "Les Fleurs du mal (1857)",
  ];

  final List<String> imageslivres = <String>[
    "images/livres/1984.jpg",
    "images/livres/l_etranger.jpg",
    "images/livres/la_horde_du_contrevent.jpg",
    "images/livres/le_petit_prince.jpg",
    "images/livres/les_fleurs_du_mal.jpg",
  ];

  final List<String> infoslivres = <String>[
    "De tous les carrefours importants, le visage à la moustache noire vous fixait du regard. Il y en a un sur le mur d'en face. Big brother vous regarde.",
    "Sur une plage algérienne, Meursault a tué un Arabe. À cause du soleil, dira-t-il, parce qu'il faisait chaud. Comment peut-il être si indifférent ?",
    "Imaginez une Terre poncée, avec en son centre une bande de cinq mille kilomètres de large et sur ses franges un miroir de glace à peine rayable, inhabité. Imaginez qu’un vent féroce en rince la surface. Que les villages qui s’y sont accrochés, avec leurs maisons en goutte d’eau, les chars à voile qui la strient, les airpailleurs debout en plein flot, tous résistent. Imaginez qu’en Extrême-Aval ait été formé un bloc d’élite d’une vingtaine d’enfants aptes à remonter au cran, rafale en gueule, leur vie durant, le vent jusqu’à sa source, à ce jour jamais atteinte : l’Extrême-Amont. Mon nom est Sov Strochnis, scribe. Mon nom est Caracole le troubadour et Oroshi Melicerte, aéromaître. Je m’appelle aussi Golgoth, traceur de la Horde, Arval l’éclaireur et parfois même Larco lorsque je braconne l’azur à la cage volante. Ensemble, nous formons la Horde du Contrevent. Il en a existé trente-trois en huit siècles, toutes infructueuses. Je vous parle au nom de la trente-quatrième : sans doute l’ultime.",
    "Le narrateur, un pilote qui est tombé en panne d'essence dans le Sahara, fait la connaissance d’un prince extraordinaire venant d’une autre planète.",
    "Une oeuvre sous forme de recueil de poèmes divisé en six parties : Spleen et idéal, Tableaux parisiens, le Vin, les Fleurs du mal, Révolte et la Mort.",
  ];

  @override
  Widget build(BuildContext context) {
    return ListeOfMedias(
        intitule: 'Livres',
        titres: titrelivres,
        images: imageslivres,
        infos: infoslivres);
  }
}
