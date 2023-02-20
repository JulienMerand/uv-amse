import 'package:flutter/material.dart';
import 'exo4.dart';

class BoardConfig extends StatefulWidget {
  const BoardConfig({super.key});

  @override
  State<BoardConfig> createState() => _BoardConfigState();
}

class _BoardConfigState extends State<BoardConfig> {
  double _currentSliderValue = 3.0;

  Tile tile = Tile(
      imageURL: 'https://picsum.photos/512', alignment: const Alignment(0, 0));

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
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: _currentSliderValue.round(),
                children: List.generate(
                    _currentSliderValue.round() * _currentSliderValue.round(),
                    (index) {
                  return Container(
                    color: Colors.teal,
                  );
                }),
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
                  value: _currentSliderValue,
                  min: 2,
                  max: 10,
                  divisions: 8,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
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
}
