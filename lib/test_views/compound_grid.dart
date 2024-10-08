import 'package:flutter/material.dart';

import '../util/intf.dart';

class TestView_CompoundGrid extends TestView {
  const TestView_CompoundGrid(
      {super.key, super.testViewName = "Compound Grid"});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ZoomableGrid(),
    );
  }
}

class ZoomableGrid extends StatefulWidget {
  const ZoomableGrid({super.key});

  @override
  State<ZoomableGrid> createState() => _ZoomableGridState();
}

class _ZoomableGridState extends State<ZoomableGrid> {
  double _zoomLevel = 1.0;
  final int _totalSquares = 1000;

  @override
  Widget build(BuildContext context) {
    int squaresPerRow = (_zoomLevel * 3).toInt();

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.zoom_out),
                onPressed: () {
                  setState(() {
                    _zoomLevel = (_zoomLevel - 0.1).clamp(0.5, 2.0);
                  });
                },
              ),
              Text("Zoom Level: ${_zoomLevel.toStringAsFixed(1)}"),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                onPressed: () {
                  setState(() {
                    _zoomLevel = (_zoomLevel + 0.1)
                        .clamp(0.5, 4000); // Maximum zoom level is 2.0
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: squaresPerRow,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _totalSquares,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Colors.blue,
                child: Center(
                  child: Text(
                    '$index',
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
