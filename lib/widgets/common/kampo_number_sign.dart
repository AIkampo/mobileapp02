import 'package:flutter/material.dart';

class KampoNumberSign extends StatelessWidget {
  const KampoNumberSign({
    Key? key,
    required this.number,
  }) : super(key: key);

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        number.toString(),
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
