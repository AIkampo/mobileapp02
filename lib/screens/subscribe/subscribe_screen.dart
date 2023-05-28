import 'package:ai_kampo_app/common/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  List dataList = [
    {
      "title": "月付制",
      "subtitle": "首個月份\$50，優惠結束後將以\$150自動續費，可隨時取消。",
      "price": "\$150",
      "label": "首月現省\$100"
    },
    {
      "title": "季付制",
      "subtitle": "首個季份\$280，優惠結束後將以\$400自動續費，可隨時取消。",
      "price": "\$400",
      "label": "首月現省\$120"
    },
    {
      "title": "年付制",
      "subtitle": "首個年份\$1,300，優惠結束後將以\$1,800自動續費，可隨時取消。",
      "price": "\$1,800",
      "label": "首月現省\$500"
    },
  ];
  List serviceList = ["完整檢測報告", "無限個家庭帳號", "聯盟診所服務"];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF61496D), KampoColors.secondary])),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF61496D), KampoColors.secondary])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Transform.rotate(
                          angle: -0.14,
                          child: ClipOval(
                            clipper: _TitleClipper(),
                            child: Container(
                              width: 260,
                              height: 70,
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Color(0xFFE5A978), Color(0xFFCD8580)])),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          top: 8,
                          child: Text(
                            "Premium 會員",
                            style: TextStyle(color: Colors.white, fontSize: 36),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Text(
                      "立即訂閲可享有30天免費健康檢測。",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 28,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: KampoColors.secondary,
                      ),
                      child: Text(
                        "家人的健康，由您來守護！！",
                        style: TextStyle(color: Color(0xFF290A37), fontSize: 22),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Stack(
                      children: [
                        Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(8),
                            title: Text("${dataList[index]['title']}"),
                            subtitle: Text(
                              "${dataList[index]['subtitle']}",
                            ),
                            trailing: Text(
                              "${dataList[index]['price']}",
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Color(0xFF6E567A),
                                  fontSize: 22),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4), bottomLeft: Radius.circular(4)),
                                gradient: LinearGradient(
                                    colors: [Color(0xFFD89661), Color(0xFFCA6F68)],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: Text("${dataList[index]['label']}"),
                          ),
                        )
                      ],
                    );
                  }, childCount: dataList.length),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: serviceList.length,
                    (context, index) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 26,
                            color: Colors.lightGreenAccent,
                          ),
                          Text(
                            " ${serviceList[index]}",
                            style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 24),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    CupertinoButton(
                      color: Colors.amber,
                      onPressed: () {
                        Get.toNamed("/payment");
                      },
                      child: Text(
                        "立即訂閱",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "服務與隱私條款",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    return Rect.fromLTWH(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }
}
