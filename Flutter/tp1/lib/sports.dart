import 'package:flutter/material.dart';
import 'liste_medias.dart';

class Sports extends StatelessWidget {
  Sports({super.key});

  final List<String> titresports = <String>[
    'Athlétisme',
    'Football',
    'Rugby',
    'Basketball',
    'Judo',
    'Boxe',
    'Tennis',
    'Badminton',
    'Natation',
  ];

  final List<String> imagessports = <String>[
    'images/sports/athletisme.jpg',
    'images/sports/football.jpg',
    'images/sports/rugby.jpg',
    'images/sports/basketball.jpg',
    'images/sports/judo.jpg',
    'images/sports/boxe.jpg',
    'images/sports/tennis.jpg',
    'images/sports/badminton.jpg',
    'images/sports/natation.jpg',
  ];

  final List<String> infossports = <String>[
    'Ce sport réunit une trentaine de disciplines : courses, marche, marathon, sauts, lancers, épreuves combinées (heptathlon, décathlon).',
    'Sport opposant deux équipes de 11 joueurs qui tentent d’envoyer un ballon dans le but adverse en le propulsant des pieds ou d’une autre partie du corps, sauf des bras ou des mains.',
    'Sport opposant deux équipes de 15 joueurs qui tentent de marquer des points en portant le ballon jusqu’à un en-but ou en le bottant entre les poteaux d’un but.',
    'Sport opposant deux équipes de cinq joueurs qui tentent de marquer des points en lançant un ballon à la main dans le panier du but adverse.',
    'Sport d’origine japonaise se pratiquant à mains nues, sans donner de coups et consistant à déséquilibrer l’adversaire à l’aide de prises. Judo signifie la voie de la souplesse.',
    'Sport au cours duquel deux adversaires portant des gants s’affrontent à coups de poing (boxe anglaise) ou à coups de poing et de pied (boxe française), selon des règles précises.',
    'Sport opposant deux ou quatre joueurs munis de raquettes qui se renvoient une balle de part et d’autre d’un filet divisant un court en deux parties.',
    'Sport s’apparentant au tennis, opposant deux ou quatre joueurs munis de raquettes qui se renvoient un volant de part et d’autre d’un filet divisant un terrain en deux parties.',
    'Sport consistant à nager sur une distance définie le plus rapidement possible, selon un des quatre types de nages reconnus.',
  ];

  @override
  Widget build(BuildContext context) {
    return ListeOfMedias(
        intitule: 'Sports',
        titres: titresports,
        images: imagessports,
        infos: infossports);
  }
}
