import 'package:flutter/material.dart';
import 'liste_medias.dart';

class BDs extends StatelessWidget {
  BDs({super.key});

  final List<String> titrebds = <String>[
    "Watchmen (1986)",
    "Dragon Ball (1984)",
    "Maus : L'Intégrale (1996)",
    "One Piece (1997)",
    "Death Note (2003)",
  ];

  final List<String> imagesbds = <String>[
    "images/bds/watchmen.jpg",
    "images/bds/dragonball.jpg",
    "images/bds/maus.jpg",
    "images/bds/onepiece.jpg",
    "images/bds/deathnote.jpg",
  ];

  final List<String> infosbds = <String>[
    "Une guerre nucléaire entre les Etats-Unis et l'URSS menace. Les gardiens, des super héros à la retraite, refont surface sous la directive de Rorschach.",
    "Son Goku, un enfant étrange vivant seul dans la forêt, rencontre Bulma, et décide de la suivre à travers le monde à la recherche de 7 boules de cristal appelées Dragon Ball.",
    "Le père de l'auteur, rescapé d'Auschwitz, raconte sa vie de 1930-1944. Conté sous la forme d'une bande dessinée dont les personnages sont des animaux.",
    "Nous sommes à l'ère des pirates. Luffy, un garçon espiègle, rêve de devenir le roi des pirates en trouvant le “One Piece”, un fabuleux trésor. Seulement, Luffy a avalé un fruit du démon qui l'a transformé en homme élastique. Depuis, il est capable de contorsionner son corps dans tous les sens, mais il a perdu la faculté de nager. Avec l'aide de ses précieux amis, il va devoir affronter de redoutables pirates dans des aventures toujours plus rocambolesques.",
    "Light Yagami ramasse un étrange carnet. Selon les instructions, la personne dont le nom est écrit dans les pages meurt dans les 40 secondes !",
  ];

  @override
  Widget build(BuildContext context) {
    return ListeOfMedias(
        intitule: 'BDs', titres: titrebds, images: imagesbds, infos: infosbds);
  }
}
