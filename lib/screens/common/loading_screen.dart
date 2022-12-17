import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  int _current = 1;
  final CarouselController _controller = CarouselController();
  List tipsList = [
    {
      "title": "「健康指引」提供許多適合您體質的東西。",
      "img": "assets/demo/loading/1.png",
      "tips": "你知道嗎？ \n 您可以隨時到「報告中心」練習八段錦。"
    },
    {
      "title": "「健康指引」提供許多適合您體質的東西。",
      "img": "assets/demo/loading/2.png",
      "tips": "你知道嗎？ \n 「健康指引」提供許多適合您體質的東西。"
    },
    {
      "title": "「健康指引」提供許多適合您體質的東西。",
      "img": "assets/demo/loading/3.png",
      "tips": "你知道嗎？ \n 健康檢測可以讓您暸解您的身體狀況。"
    }
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      Get.offAndToNamed("/main");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/logo.with.bg.png"),
          CarouselSlider(
            items: tipsList.map((tips) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(tips['img']),
                          SizedBox(
                            height: 20,
                          ),
                          Stack(
                            children: [
                              Image.asset("assets/images/tips.frame.png"),
                              Positioned(
                                child: Text(tips["tips"]),
                                top: 38,
                                left: 38,
                              )
                            ],
                          )
                        ],
                      ));
                },
              );
            }).toList(),
            carouselController: _controller,
            options: CarouselOptions(
                height: 410,
                autoPlay: false,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: tipsList.asMap().entries.map((tip) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(tip.key),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == tip.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "系統正在讀取最新需端資料…",
                      style: TextStyle(height: 3),
                    ),
                    Text("80%")
                  ],
                ),
                GFProgressBar(
                  percentage: 0.8,
                  progressBarColor: Color(0xFF725F7C),
                  lineHeight: 16,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
