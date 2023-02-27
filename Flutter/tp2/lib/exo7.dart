import 'dart:math';

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
  String txtstart = "Start";
  String URL = 'https://picsum.photos/512';
  String difficulte = "Easy";
  List listdifficulte;

  List initlist(int gridvalue) {
    List ti = [];
    for (var index = 0; index < gridvalue * gridvalue; index++) {
      TileWidget tw = TileWidget(
          tile: Tile(
              imageURL: URL,
              alignment: Alignment(
                  (2 / (gridvalue - 1)) * (index % gridvalue) - 1,
                  (2 / (gridvalue - 1)) * (index ~/ gridvalue) - 1),
              factor: gridvalue),
          index: index);
      ti.add([tw, index]);
    }
    ti.removeAt(indexEmpty);
    ti.insert(indexEmpty, emptytile);
    return ti;
  }

  List<Widget> tileslist(gridvalue) {
    return List.generate(
      gridvalue.round() * gridvalue.round(),
      (index) => InkWell(
          child: tiles[index][0],
          onTap: () {
            swaptiles(index);
            if (gagne()) {
              print(tiles);
              print("Gagné !");
            }
          }),
    );
  }

  void melanger(List tiles, String diff) {
    final random = Random();
    int index;
    int oldindex = indexEmpty;
    List listindex;
    int nbcoups = 0;

    if(diff=="Easy"){
      nbcoups = 20;
    }
    else if (diff == "Medium"){
      nbcoups = 50;
    }
    else if (diff == "Hard"){
      nbcoups = 100;
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
      bool ret = swaptiles(index);
      if (!ret) {
        i--;
        setState(() {
          indexEmpty = oldindex;
        });
        // print("swap impossible, case vide : $indexEmpty");
      }
    }
    print("Grille melangé ! A vous de jouer !");
  }

  @override
  void initState() {
    super.initState();
    tiles = initlist(_gridvalue.round());
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
          child: Text(txtstart),
          onPressed: () {
            setState(() {
              start = !start;
              txtstart = txtstart == "Start" ? "Stop" : "Start";
              if (start) {
                melanger(tiles, difficulte);
              }
              if (!start) {
                indexEmpty = 0;
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  const Text(
                    "Taille : ",
                    style: TextStyle(fontSize: 17),
                  ),
                  Expanded(
                    child: Slider(
                      value: _gridvalue,
                      min: 2,
                      max: 10,
                      divisions: 8,
                      label: _gridvalue.round().toString(),
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
                ],
              ),
            ),
            const SizedBox(height: 5.0),
          ],
        ),
        body: Column(
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
            Expanded(
              flex: 25,
              child: Row(
                children: [
                  DropdownButton<String>(
                    value: difficulte,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        difficulte = value!;
                      });
                    },
                    items: listdifficulte.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                  SizedBox(child: Image.network(URL, fit: BoxFit.contain)),
                ],
              ),
            ),
            const Expanded(flex: 5, child: SizedBox()),
          ],
        ),
      ),
    );
  }

  bool swaptiles(index) {
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
          List temp = tiles[index];
          tiles[index] = tiles[indexEmpty];
          tiles[indexEmpty] = temp;
          indexEmpty = index;
        });
        return true;
      } else {
        return false;
      }
    } else {
      print("Mouvement impossible ! ");
      return false;
    }
  }

  bool gagne() {
    for (var i = 0; i < _gridvalue.round(); i++) {
      if (i != tiles[i][1]) {
        return false;
      }
    }
    return true;
  }
}
