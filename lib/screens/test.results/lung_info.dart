//肺部健康指數

import 'package:flutter/material.dart';

class LungInfo extends StatelessWidget {
  LungInfo({
    Key? key,
  }) : super(key: key);

  final List lungList = [
    {"percent": 66.66, "title": "組織", "icon": "assets/icons/lung_tissue.png"},
    {"percent": 100, "title": "病理", "icon": "assets/icons/lung_pathology.png"},
    {"percent": 93.77, "title": "病菌", "icon": "assets/icons/lung_germs.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
        padding: EdgeInsets.all(12),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 170,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1),
          delegate: SliverChildBuilderDelegate((context, index) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
                color: Color.fromRGBO(206, 2236, 234, 0.8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "${lungList[index]["title"]}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(255, 255, 255, 0.6),
                        ),
                        child: Image(
                            width: 42,
                            height: 42,
                            image: AssetImage(lungList[index]["icon"])),
                      ),
                    ],
                  ),
                  Text(
                    "${lungList[index]["percent"]}%",
                    style: TextStyle(
                      color: Colors.purple[900],
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            );
          }, childCount: lungList.length),
        ));
  }
}
