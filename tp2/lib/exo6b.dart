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

class BoardSwape extends StatefulWidget {
  const BoardSwape({super.key});

  @override
  State<BoardSwape> createState() => _BoardSwape();
}

class _BoardSwape extends State<BoardSwape> {
  double currentSliderValue = 3.0;
  int indexEmpty = 0;
  Widget emptytile = Container(
    color: Colors.white,
  );
  late List<Widget> tiles;

  // List<Widget> listoftiles(sliderValue) {
  //   return List.generate(sliderValue.round() * sliderValue.round(), (index) =>
  //     TileWidget(
  //       tile: Tile(
  //         imageURL: 'https://picsum.photos/512',
  //         alignment: Alignment(
  //             (2 / (sliderValue.round() - 1)) * (index % sliderValue.round()) -
  //                 1,
  //             (2 / (sliderValue.round() - 1)) * (index ~/ sliderValue.round()) -
  //                 1),
  //         factor: sliderValue.round()),
  //         index: index)
  //   );
  // }

  List<Widget> initlist() {
    List<Widget> tiles = List.generate(
        currentSliderValue.round() * currentSliderValue.round(),
        (index) => TileWidget(
            tile: Tile(
                imageURL: 'https://picsum.photos/512',
                alignment: Alignment(
                    (2 / (currentSliderValue.round() - 1)) *
                            (index % currentSliderValue.round()) -
                        1,
                    (2 / (currentSliderValue.round() - 1)) *
                            (index ~/ currentSliderValue.round()) -
                        1),
                factor: currentSliderValue.round()),
            index: index));
    tiles.removeAt(indexEmpty);
    tiles.insert(indexEmpty, emptytile);
    print("Liste initialisé");
    return tiles;
  }

  @override
  void initState() {
    super.initState();
    tiles = initlist();
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
        body: Column(
          children: [
            Expanded(
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: currentSliderValue.round(),
                children: List.generate(
                  currentSliderValue.round() * currentSliderValue.round(),
                  (index) => InkWell(
                      child: tiles[index],
                      onTap: () {
                        if (index != indexEmpty) {
                          swaptiles(index);
                        } else {
                          print("case vide sélectionné !");
                        }
                      }),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                const Text(
                  "Taille : ",
                  style: TextStyle(fontSize: 20),
                ),
                Slider(
                  value: currentSliderValue,
                  min: 2,
                  max: 10,
                  divisions: 8,
                  label: currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      currentSliderValue = value;
                      tiles = initlist();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  swaptiles(index) {
    if ((index != indexEmpty - 1) &
        (index != indexEmpty + 1) &
        (index != indexEmpty + currentSliderValue) &
        (index != indexEmpty - currentSliderValue)) {
      print("Mouvement impossible");
    } else {
      setState(() {
        print("clicked on $index");
        Widget temp = tiles[index];
        tiles[index] = tiles[indexEmpty];
        tiles[indexEmpty] = temp;

        indexEmpty = index;
      });
    }
  }
}
