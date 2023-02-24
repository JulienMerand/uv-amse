import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  const DisplayImage({super.key});

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
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              'https://picsum.photos/512',
              height: 400,
            ),
          ),
        ),
      ),
    );
  }
}
