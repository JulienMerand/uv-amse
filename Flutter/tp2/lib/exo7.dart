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
      // onTap: () {
      //   print("tapped on tile $index");
      // },
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
  Widget emptytile = Container(
    color: Colors.white,
  );
  List<Widget> tiles = [];
  bool start = false;
  String txtstart = "Start";

  List<Widget> initlist(int gridvalue) {
    List<Widget> ti = List.generate(
        gridvalue * gridvalue,
        (index) => TileWidget(
            tile: Tile(
                imageURL: 'https://picsum.photos/512',
                alignment: Alignment(
                    (2 / (gridvalue - 1)) * (index % gridvalue) - 1,
                    (2 / (gridvalue - 1)) * (index ~/ gridvalue) - 1),
                factor: gridvalue),
            index: index));
    ti.removeAt(indexEmpty);
    ti.insert(indexEmpty, emptytile);
    return ti;
  }

  List<Widget> tileslist(gridvalue) {
    return List.generate(
      gridvalue.round() * gridvalue.round(),
      (index) => InkWell(
          child: tiles[index],
          onTap: () {
            swaptiles(index);
          }),
    );
  }

  List<Widget> melanger(List<Widget> tiles, int nbcoups) {
    final random = Random();
    int index;
    int oldindex = indexEmpty;
    List listindex;
    for (var i = 0; i < nbcoups; i++) {
      listindex = [
        indexEmpty - 1,
        indexEmpty + 1,
        indexEmpty - _gridvalue.round(),
        indexEmpty + _gridvalue.round()
      ];
      index = listindex[random.nextInt(listindex.length)];
      while ((index == oldindex) | (index < 0) | (index >= _gridvalue)) {
        index = listindex[random.nextInt(listindex.length)];
      }
      bool ret = swaptiles(index);
      if (!ret) {
        i--;
      }
      oldindex = index;
    }
    return tiles;
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
          title: const Text("Génération du plateau de tuiles "),
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
              start = start == false ? true : false;
              txtstart = txtstart == "Start" ? "Stop" : "Start";
              if (start) {
                //tiles = melanger(tiles, 10);
              }
              if (!start) {
                indexEmpty = 0;
              }
              tiles = initlist(_gridvalue.round());
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10.0),
            BottomAppBar(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 20),
                  const Text(
                    "Taille : ",
                    style: TextStyle(fontSize: 17),
                  ),
                  Slider(
                    value: _gridvalue,
                    min: 2,
                    max: 10,
                    divisions: 8,
                    label: _gridvalue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        if (!start) {
                          _gridvalue = value;
                        }
                      });
                    },
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
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: _gridvalue.round(),
                children: tileslist(_gridvalue.round()),
              ),
            ),
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
          Widget temp = tiles[index];
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
}
