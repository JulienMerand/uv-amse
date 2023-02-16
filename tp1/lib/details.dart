import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  const Details(
      {super.key,
      required this.titre,
      required this.image,
      required this.info});

  final String titre;
  final Image image;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: const Color.fromARGB(255, 161, 211, 252),
            child: Container(
              margin: const EdgeInsets.all(50.0),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    child: image,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      titre,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
                left: 50.0, right: 50.0, top: 20.0, bottom: 20.0),
            padding: const EdgeInsets.all(10.0),
            child: Text(info),
          ),
        ],
      ),
    );
  }
}
