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
  double gridvalue = 3.0;
  int indexEmpty = 0;
  Widget emptytile = Container(
    color: Colors.white,
  );
  List<Widget> tiles = [];

  List<Widget> initlist(int gridvalue) {
    List<Widget> tiles = List.generate(
        gridvalue * gridvalue,
        (index) => TileWidget(
            tile: Tile(
                imageURL: 'https://picsum.photos/512',
                alignment: Alignment(
                    (2 / (gridvalue - 1)) * (index % gridvalue) - 1,
                    (2 / (gridvalue - 1)) * (index ~/ gridvalue) - 1),
                factor: gridvalue),
            index: index));
    tiles.removeAt(indexEmpty);
    tiles.insert(indexEmpty, emptytile);
    print("Liste initialisé");
    return tiles;
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
        indexEmpty - gridvalue.round(),
        indexEmpty + gridvalue.round()
      ];
      index = listindex[random.nextInt(listindex.length)];
      while ((index < 0) |
          (index >= gridvalue.round() * gridvalue.round()) |
          (index == oldindex)) {
        index = listindex[random.nextInt(listindex.length)];
      }
      swaptiles(index);
      oldindex = index;
    }
    return tiles;
  }

  @override
  void initState() {
    super.initState();
    tiles = initlist(gridvalue.round());
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
          child: const Text("Start"),
          onPressed: () {
            setState(() {
              tiles = initlist(gridvalue.round());
              tiles = melanger(tiles, 10);
            });
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              const Text(
                "Taille : ",
                style: TextStyle(fontSize: 20),
              ),
              Slider(
                value: gridvalue,
                min: 2,
                max: 10,
                divisions: 8,
                label: gridvalue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    gridvalue = value;
                  });
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: gridvalue.round(),
                children: List.generate(
                  gridvalue.round() * gridvalue.round(),
                  (index) => InkWell(
                      child: tiles[index],
                      onTap: () {
                        if (index != indexEmpty) {
                          swaptiles(index);
                        } else {
                          print("Mouvement impossible !");
                        }
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  swaptiles(index) {
    if ((index != indexEmpty - 1) &
        (index != indexEmpty + 1) &
        (index != indexEmpty + gridvalue.round()) &
        (index != indexEmpty - gridvalue.round())) {
      print("Mouvement impossible");
    } else {
      setState(() {
        Widget temp = tiles[index];
        tiles[index] = tiles[indexEmpty];
        tiles[indexEmpty] = temp;
        indexEmpty = index;
      });
    }
  }
}
