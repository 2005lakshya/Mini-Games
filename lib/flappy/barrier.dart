import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class Mybarrier extends StatelessWidget {
  final double size;

  const Mybarrier({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: size,
      decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(width: 10, color: Colors.green),
          borderRadius: BorderRadius.circular(15)
      ),
    );
  }
}