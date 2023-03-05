import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'exo4.dart';

class TileWidget extends StatelessWidget {
  final Tile tile;
  final int index;

  const TileWidget({super.key, required this.tile, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: tile.croppedImageTile(),
    );
  }
}

class Taquin extends StatefulWidget {
  const Taquin({super.key});

  @override
  State<Taquin> createState() => _Taquin();
}

class _Taquin extends State<Taquin> {
  double _gridvalue = 3.0;
  int indexEmpty = 0;
  List emptytile = [
    Container(
      color: Colors.white,
    ),
    0
  ];
  List tiles = [];
  bool start = false;
  int nombrecoups = 0;
  List oldempty = [];
  IconData iconstart = Icons.play_arrow;
  String difficulte = "Easy";
  List listdifficulte = ["Easy", "Medium", "Hard"];
  String urlimg = "";
  late ConfettiController _controllerCenter;
  List historique = [];

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Easy", child: Text("Easy")),
      const DropdownMenuItem(value: "Medium", child: Text("Medium")),
      const DropdownMenuItem(value: "Hard", child: Text("Hard")),
    ];
    return menuItems;
  }

  String url() {
    Random random = Random();
    int id = random.nextInt(1001);
    String res = "https://picsum.photos/id/${id}/512/";
    return res;
  }

  List initlist(int gridvalue) {
    List ti = [];
    for (var index = 0; index < gridvalue * gridvalue; index++) {
      TileWidget tw = TileWidget(
          tile: Tile(
              imageURL: urlimg,
              alignment: Alignment(
                  (2 / (gridvalue - 1)) * (index % gridvalue) - 1,
                  (2 / (gridvalue - 1)) * (index ~/ gridvalue) - 1),
              factor: gridvalue),
          index: index);
      ti.add([tw, index]);
    }
    ti.removeAt(indexEmpty);
    ti.insert(indexEmpty, emptytile);
    setState(() {
      print("Clear history");
      historique.clear();
      historique.add(ti);
    });
    return ti;
  }

  List<Widget> tileslist(int gridvalue) {
    print("Historique : ${historique.length} | Empty : $indexEmpty");
    List<Widget> cur = List.generate(
      gridvalue * gridvalue,
      (index) => InkWell(
          child: historique[historique.length - 1][index][0],
          onTap: () {
            if (start) {
              setState(() {
                gagne() ? iconstart = Icons.replay : swaptiles(index);
              });
            }
          }),
    );
    return cur;
  }

  void melanger(String diff) {
    final random = Random();
    int index;
    int oldindex = indexEmpty;
    List listindex;
    int nbcoups = 0;

    switch (diff) {
      case "Easy":
        nbcoups = 10;
        break;
      case "Medium":
        nbcoups = 50;
        break;
      case "Hard":
        nbcoups = 500;
        break;
      default:
        throw UnimplementedError('no widget for $diff');
    }

    for (var i = 0; i < nbcoups; i++) {
      listindex = [
        indexEmpty - 1,
        indexEmpty + 1,
        indexEmpty - _gridvalue.round(),
        indexEmpty + _gridvalue.round()
      ];
      index = listindex[random.nextInt(listindex.length)];
      while ((index == oldindex) |
          (index < 0) |
          (index >= _gridvalue * _gridvalue)) {
        index = listindex[random.nextInt(listindex.length)];
      }
      oldindex = indexEmpty;
      // print("je swap $index avec la case vide $indexEmpty, oldindex = $oldindex");
      bool ret = swaptiles(index, save: false);
      if (!ret) {
        i--;
        setState(() {
          indexEmpty = oldindex;
        });
        // print("swap impossible, case vide : $indexEmpty");
      }
    }
    setState(() {
      historique.add(tiles);
    });
    print("Grille melangé ! A vous de jouer !");
  }

  @override
  void initState() {
    super.initState();
    urlimg = url();
    tiles = initlist(_gridvalue.round());
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Jeu du Taquin"),
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(Icons.keyboard_arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(iconstart),
          onPressed: () {
            setState(() {
              start = !start;
              if (start) {
                melanger(difficulte);
                iconstart = gagne() ? Icons.replay : Icons.stop;
                nombrecoups = 1;
              }
              if (!start) {
                iconstart = Icons.play_arrow;
                indexEmpty = 0;
                nombrecoups = 0;
                tiles = initlist(_gridvalue.round());
                tileslist(_gridvalue.round());
              }
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15.0),
            BottomAppBar(
              height: 50.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: start
                    ? (gagne()
                        ? [
                            Expanded(
                                child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Text(
                                      "Nombre de coups : ${nombrecoups - 1}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                const Expanded(child: SizedBox()),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: const Text(
                                    "Victoire !!",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 69, 249, 96),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                          ]
                        : [
                            Expanded(
                                child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  color: Colors.white,
                                  child: Text(
                                      "Nombre de coups : ${nombrecoups - 1}",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                const Expanded(child: SizedBox()),
                                (nombrecoups <= 1)
                                    ? const SizedBox()
                                    : TextButton(
                                        onPressed: () {
                                          setState(() {
                                            if (nombrecoups > 1) {
                                              historique.removeLast();
                                              nombrecoups--;
                                              indexEmpty =
                                                  oldempty.removeLast();
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: const [
                                            Icon(
                                              Icons.replay,
                                              color: Colors.black,
                                            ),
                                            Text(" Annuler",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        ),
                                      ),
                              ],
                            ))
                          ])
                    : [
                        const SizedBox(width: 20),
                        const Text(
                          "Size : ",
                          style: TextStyle(fontSize: 17),
                        ),
                        Expanded(
                          child: Slider(
                            value: _gridvalue,
                            min: 2,
                            max: 10,
                            divisions: 8,
                            label: _gridvalue.round().toString(),
                            activeColor: Colors.teal,
                            inactiveColor: Colors.teal[100],
                            thumbColor: Colors.teal,
                            onChanged: (double value) {
                              setState(() {
                                if (!start) {
                                  _gridvalue = value;
                                  tiles = initlist(_gridvalue.round());
                                  tileslist(_gridvalue.round());
                                }
                              });
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (!start) {
                              setState(() {
                                urlimg = url();
                                tiles = initlist(_gridvalue.round());
                              });
                            }
                          },
                          child: Row(
                            children: const [
                              Icon(
                                Icons.replay,
                                color: Colors.black,
                              ),
                              Text(" Reload",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        ),
                      ],
              ),
            ),
          ],
        ),
        body: Stack(children: [
          Column(
            children: [
              Expanded(
                flex: 70,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  crossAxisCount: _gridvalue.round(),
                  children: tileslist(_gridvalue.round()),
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
              start
                  ? Expanded(
                      flex: 24,
                      child: Center(
                        child: SizedBox(
                            child: Image.network(
                          urlimg,
                          fit: BoxFit.contain,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.network('https://picsum.photos/512');
                          },
                        )),
                      ))
                  : Expanded(
                      flex: 23,
                      child: Row(
                        children: [
                          const Expanded(flex: 10, child: SizedBox()),
                          Expanded(
                            flex: 25,
                            child: Column(
                              children: [
                                DropdownButton<String>(
                                  value: difficulte,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 8,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: start
                                      ? null
                                      : (String? value) {
                                          // This is called when the user selects an item.
                                          setState(() {
                                            difficulte = value!;
                                          });
                                        },
                                  items: dropdownItems,
                                ),
                              ],
                            ),
                          ),
                          const Expanded(flex: 5, child: SizedBox()),
                          Expanded(
                              flex: 60,
                              child: SizedBox(
                                  child: Image.network(
                                urlimg,
                                fit: BoxFit.contain,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.network(
                                      'https://picsum.photos/512');
                                },
                              ))),
                        ],
                      ),
                    ),
              const Expanded(flex: 5, child: SizedBox()),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 50,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ]),
      ),
    );
  }

  bool swaptiles(int index, {bool save = true}) {
    if (start) {
      List indexpossible = [
        indexEmpty - 1,
        indexEmpty + 1,
        indexEmpty - _gridvalue.round(),
        indexEmpty + _gridvalue.round()
      ];

      if (((index + 1) % _gridvalue == 0) & ((indexEmpty % _gridvalue == 0))) {
        indexpossible = [
          indexEmpty + 1,
          indexEmpty - _gridvalue.round(),
          indexEmpty + _gridvalue.round()
        ];
      }
      if (((index) % _gridvalue == 0) &
          (((indexEmpty + 1) % _gridvalue == 0))) {
        indexpossible = [
          indexEmpty - 1,
          indexEmpty - _gridvalue.round(),
          indexEmpty + _gridvalue.round()
        ];
      }
      if (indexpossible.contains(index)) {
        setState(() {
          if (save) {
            List copy = List.from(historique[historique.length - 1]);
            List temp = copy[index];
            copy[index] = copy[indexEmpty];
            copy[indexEmpty] = temp;
            historique.add(copy);
            oldempty.add(indexEmpty);
            nombrecoups += 1;
          } else {
            List temp = tiles[index];
            tiles[index] = tiles[indexEmpty];
            tiles[indexEmpty] = temp;
          }
          indexEmpty = index;
        });
        return true;
      } else {
        print("Mouvement impossible ! ");
        return false;
      }
    } else {
      print("Mouvement impossible ! ");
      return false;
    }
  }

  bool gagne() {
    for (var i = 0; i < _gridvalue.round() * _gridvalue.round(); i++) {
      if (i != historique[historique.length - 1][i][1]) {
        return false;
      }
    }
    _controllerCenter.play();
    return true;
  }
}
