import 'package:flutter/material.dart';

class KampoTitle extends StatelessWidget {
  const KampoTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 26,
        ),
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xFFAEE0DD), //Colors.blue[100],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01ACBD) //Colors.blue[700],
                ),
          ),
        ),
      ],
    );
  }
}

class KampoSliverTitle extends StatelessWidget {
  const KampoSliverTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: KampoTitle(title: title));
  }
}
