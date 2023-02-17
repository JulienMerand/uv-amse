import 'package:flutter/material.dart';
import 'liste_medias.dart';

class Films extends StatelessWidget {
  Films({super.key});

  final List<String> titrefilms = <String>[
    "Les Murs du souvenirs (2019)",
    "Les Evadés (1994)",
    "Le Parrain (1972)",
    "The Dark Knight : Le Chevalier noir (2008)",
    "12 Hommes en colère (1957)",
    "La Liste de Schindler (1993)",
    "Le Seigneur des anneaux : Le Retour du roi (2003)",
    "Pulp Fiction (1994)",
    "Fight Club (1999)",
    "Inception (2010)",
  ];

  final List<String> imagesfilms = <String>[
    "images/films/mursdusouvenirs.jpg",
    "images/films/evades.jpg",
    "images/films/parrain.jpg",
    "images/films/batman.jpg",
    "images/films/hommescolere.jpg",
    "images/films/schindler.jpg",
    "images/films/seigneuranneaux.jpg",
    "images/films/pulpfiction.jpg",
    "images/films/fightclub.jpg",
    "images/films/inception.jpg",
  ];

  final List<String> infosfilms = <String>[
    "Les Murs du souvenir est un téléfilm franco-belge réalisé par Sylvie Ayme, faisant suite au téléfilm Les Brumes du souvenir et précédant Les Ondes du souvenir.\n\nLe corps d'un homme est retrouvé emmuré dans un immeuble du centre ville de Colmar. Clara Mérisi arrive sur la scène du crime et y retrouve François Gilbert, historien et anthropologue judiciaire, appelé par son adjoint pour examiner la victime : en effet, le cadavre, vêtu d'un uniforme SS, est mort assassiné 70 ans plus tôt. Comment est-il arrivé ici ? C'est la réponse à cette question que doit trouver Clara, sous pression à cause de son divorce qui se déroule mal, sur fond d'enquête à dimension historique. ",
    "Les Évadés ou À l'ombre de Shawshank au Québec et au Nouveau-Brunswick (The Shawshank Redemption) est un film américain écrit et réalisé par Frank Darabont, sorti en 1994.\nLe film s'inspire du novella Rita Hayworth et la Rédemption de Shawshank de l'écrivain Stephen King, paru dans le recueil Différentes Saisons. Il raconte l'histoire d'Andy Dufresne (Tim Robbins), un homme injustement condamné pour les meurtres de sa femme et de l'amant de celle-ci, et qui va passer près de vingt ans au pénitencier de Shawshank, endurant diverses épreuves mais se liant également d'amitié avec Red (Morgan Freeman), un autre détenu. ",
    "Le Parrain (The Godfather) est un film de gangsters américain réalisé par Francis Ford Coppola et sorti en 1972.\nProduit par les studios Paramount, le film est l'adaptation du roman du même nom (1969) écrit par le romancier Mario Puzo. L'histoire se déroule à New York sur une période allant de 1945 à 1955, et raconte les luttes de pouvoir au sein de la mafia américaine new-yorkaise, avec pour protagoniste principal la famille Corleone, l'une des cinq familles mafieuses de la ville, la famille Corleone étant menée par son patriarche, Don Vito Corleone dit le « Parrain » (Marlon Brando), un personnage puissant et influent. Son plus jeune fils, Michael Corleone (Al Pacino), qui initialement souhaitait rester en dehors des activités criminelles de sa famille, se voit contraint d'en devenir le membre le plus important et le plus impitoyable à la suite d'un enchaînement de circonstances tragiques, qui débutent quand son père est victime d'une attaque orchestrée par une famille mafieuse concurrente. ",
    "The Dark Knight, Le Chevalier Noir (The Dark Knight), ou simplement Le Chevalier Noir dans la francophonie, est un film américano-britannique réalisé par Christopher Nolan, sorti en 2008. Fondé sur le personnage de fiction DC Comics, Batman, il fait partie de ce qui sera appelé la trilogie The Dark Knight et est la suite de Batman Begins sorti en 2005.\nBatman aborde une phase décisive de sa guerre contre le crime à Gotham City. Avec l'aide du lieutenant de police Jim Gordon et du nouveau procureur Harvey Dent, il entreprend de démanteler les dernières organisations criminelles qui infestent les rues de la ville. L'association s'avère efficace, mais le trio se heurte bientôt à un nouveau génie du crime qui répand la terreur et le chaos dans Gotham : le Joker. On ne sait pas d'où il vient ni qui il est. Ce criminel possède une intelligence redoutable doublé d'un humour sordide et n'hésite pas à s'attaquer à la pègre locale dans le seul but de semer le chaos. ",
    "Douze Hommes en colère (12 Angry Men) est un drame américain de Sidney Lumet, sorti en 19571.\nFilm de procès se déroulant aux États-Unis dans les années 1950, l'intrigue montre un jury populaire de 12 hommes qui doivent délibérer sur le sort d'un homme âgé de 18 ans accusé de parricide. En fonction de leur verdict, le jeune homme peut être condamné à mort, ou acquitté sur la base d'un doute raisonnable. Au cours de leur délibération, cette affaire force les jurés à remettre en question leur moralité et leurs valeurs.\nLe film explore de nombreuses techniques de recherche de consensus et montre les difficultés rencontrées dans le processus parmi ce groupe d'hommes, dont l'éventail de personnalités ajoute à l'intensité et au conflit pour juger cette affaire. Le film explore également le pouvoir que possède une personne à provoquer un changement d'avis chez d'autres individus. Au cours du film, les membres du jury ne sont identifiés que par un numéro ; aucun nom n'est révélé, jusqu'à un échange de dialogue tout à la fin.\nLe film oblige les personnages et les spectateurs à évaluer leur propre image de soi en observant la personnalité, les expériences et les actions des jurés. Il se distingue également par l'utilisation presque exclusive d'un seul lieu où se déroulent les scènes du film (sauf les trois dernières minutes qui sont à l'extérieur du tribunal). ",
    "La Liste de Schindler (Schindler's List) est un film américain réalisé par Steven Spielberg et sorti en 1993. Il s'agit d'une adaptation du roman La Liste de Schindler (Schindler's Ark) de Thomas Keneally.\nAvec dans les rôles principaux les acteurs Liam Neeson, Ben Kingsley et Ralph Fiennes, le film, inspiré du roman homonyme paru en 1982 de Thomas Keneally, décrit comment Oskar Schindler, un industriel allemand, réussit pendant la Seconde Guerre mondiale à sauver environ 1 200 Juifs promis à la mort dans le camp de concentration de Płaszów, sans pour autant occulter les travers et ambiguïtés d’un espion de l’Abwehr et membre du parti nazi. ",
    "Le Seigneur des anneaux : Le Retour du roi (The Lord of the Rings: The Return of the King) est un film américano-néo-zélandais réalisé par Peter Jackson, sorti en 2003. Adapté du livre Le Retour du roi de J. R. R. Tolkien, il incorpore également des événements du livre précédent, Les Deux Tours. C'est le troisième volet de la trilogie Le Seigneur des anneaux, après La Communauté de l'anneau et Les Deux Tours.\nAlors que Sauron lance ses armées à l'assaut de la Terre du Milieu, le magicien Gandalf et le roi Théoden réunissent leurs forces pour défendre la capitale du Gondor, Minas Tirith. Aragorn réclame son trône et fait appel à l'armée des Morts pour remporter la bataille des Champs du Pelennor. Pendant ce temps, les hobbits Frodon Sacquet et Samsagace Gamegie traversent le Mordor guidés par Gollum pour aller détruire l'Anneau unique à la montagne du Destin. ",
    "Pulp Fiction, ou Fiction pulpeuse au Québec, est un film de gangsters américain réalisé par Quentin Tarantino et sorti en 1994. Le scénario est coécrit par Tarantino et Roger Avary. Utilisant la technique de narration non linéaire, il entremêle plusieurs histoires ayant pour protagonistes des membres de la pègre de Los Angeles et se distingue par ses dialogues stylisés, son mélange de violence et d'humour et ses nombreuses références à la culture populaire. Sa distribution principale se compose notamment de John Travolta, dont la carrière est relancée par ce film, Samuel L. Jackson, Bruce Willis et Uma Thurman. ",
    "Fight Club est un film américano-allemand réalisé par David Fincher et sorti en 1999. Il est adapté du roman du même nom de Chuck Palahniuk publié en 1996. Le narrateur est un homme qui, trouvant peu de satisfaction dans son activité professionnelle et sa vie en général, crée avec l'énigmatique Tyler Durden, personnage anticonformiste, un club de combats clandestins permettant à ses membres d'évacuer leur mal-être par la violence. Le film a pour interprètes principaux Edward Norton, Brad Pitt et Helena Bonham Carter. ",
    "Inception, ou Origine au Québec, est un thriller de science-fiction américano-britannique écrit, réalisé et produit par Christopher Nolan, sorti en 2010.\nDom Cobb est un voleur expérimenté dans l'art périlleux de `l'extraction' : sa spécialité consiste à s'approprier les secrets les plus précieux d'un individu, enfouis au plus profond de son subconscient, pendant qu'il rêve et que son esprit est particulièrement vulnérable. Très recherché pour ses talents dans l'univers trouble de l'espionnage industriel, Cobb est aussi devenu un fugitif traqué dans le monde entier. Cependant, une ultime mission pourrait lui permettre de retrouver sa vie d'avant.",
  ];

  @override
  Widget build(BuildContext context) {
    return ListeOfMedias(
        intitule: 'Films',
        titres: titrefilms,
        images: imagesfilms,
        infos: infosfilms);
  }
}
