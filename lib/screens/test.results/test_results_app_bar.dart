import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestResultsAppBar extends StatelessWidget {
  const TestResultsAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // backgroundColor: Color.fromARGB(255, 233, 209, 237),
      backgroundColor: Colors.blue[100],
      centerTitle: true,
      pinned: true,
      floating: true,
      snap: true,
      stretch: true,
      expandedHeight: 180,

      flexibleSpace: FlexibleSpaceBar(
        background: Image(
          image: AssetImage("assets/images/logo.png"),
        ),
        stretchModes: [
          StretchMode.blurBackground,
          StretchMode.fadeTitle,
          StretchMode.zoomBackground
        ],
      ),
      leading: GestureDetector(
        onTap: () {
          print("Detect body!");
        },
        child: Image.asset(
          "assets/icons/detection.png",
        ),
      ),
      actions: [
        TextButton(
            // style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all(Colors.amber),
            //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(50)))),
            onPressed: () {
              Get.back();
            },
            child: Text(
              "ACC",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ))
      ],
    );
  }
}
