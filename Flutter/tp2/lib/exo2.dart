import 'package:flutter/material.dart';

class Transformation extends StatefulWidget {
  const Transformation({super.key});

  @override
  State<Transformation> createState() => _TransformationState();
}

class _TransformationState extends State<Transformation> {
  double pi = 3.1415926535897932;

  double _currentSizeValue = 100;
  double _currentRotXValue = 0;
  double _currentRotZValue = 50;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Rotate/Resize image"),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
                child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.skewY(0.0)
                ..rotateZ(-pi * (_currentRotZValue - 50) / 50)
                ..rotateX(-pi * (_currentRotXValue) / 100),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  'https://picsum.photos/512',
                  height: 400 * _currentSizeValue / 100,
                ),
              ),
            )),
            SizedBox(height: 400 * (1 - _currentSizeValue / 100)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                const Text(
                  "Size : ",
                  style: TextStyle(fontSize: 20),
                ),
                Slider(
                  value: _currentSizeValue,
                  min: 5,
                  max: 100,
                  divisions: 100,
                  label: _currentSizeValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSizeValue = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                const Text(
                  "Rotate X : ",
                  style: TextStyle(fontSize: 20),
                ),
                Slider(
                  value: _currentRotXValue,
                  max: 100,
                  divisions: 100,
                  label: _currentRotXValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentRotXValue = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                const Text(
                  "Rotate Z : ",
                  style: TextStyle(fontSize: 20),
                ),
                Slider(
                  value: _currentRotZValue,
                  max: 100,
                  divisions: 100,
                  label: _currentRotZValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentRotZValue = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
