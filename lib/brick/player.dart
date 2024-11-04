import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  final double playerX;
  final double playerWidth; // out of 2
  MyPlayer({this.playerX = 0.0, this.playerWidth = 1.0});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2*playerX+playerWidth)/(2-playerWidth), 0.9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 10,
          width: MediaQuery.of(context).size.width * playerWidth / 2,
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
