import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getwidget/getwidget.dart';

class FAQ_SCREEN extends StatefulWidget {
  const FAQ_SCREEN({super.key});

  @override
  State<FAQ_SCREEN> createState() => _FAQ_SCREENState();
}

class _FAQ_SCREENState extends State<FAQ_SCREEN> {
  List dataList = [
    {
      "title": "耳機連線問題",
      "content":
          "打開耳機開關和手機藍牙，再打開AIKAMPO APP，若有顯示連接畫面，代表連接成功。若藍牙耳機還是無法連接，請從新打開藍牙和AIKAMPO APP。"
    },
    {"title": "轉換帳號", "content": "1.在「設定」頁面中的「ACC」切換帳號。\n2.在登入畫面下方選擇切換帳號。"},
    {"title": "歷史報告", "content": "請到「報告中心」的「歷史報告」中看您的報告，您可以選擇以「日/月」的方式瀏覽。"},
    {"title": "忘記密碼", "content": "請於登入頁面右下方點選「忘記密碼」，透過手機簡訊驗證後，進行修改密碼即可。"},
    {"title": "注冊後無法成功登入", "content": "請您確保輸入的密碼是否正確，或者是否有成功驗證帳號。"},
    {"title": "收不到驗證碼", "content": "請確保在注冊時，您的手機訊號穩定狀態，以免導致收不到訊息。"},
    {"title": "獲得點數", "content": "您可以透過練習「八段錦」或「内八段錦」的方式來獲得點數。"},
    {
      "title": "聯盟診所",
      "content": "您可以透過「搜尋」方式尋找您指定的聯盟診所，或者也可以透過「定位」的方式提供您附近的聯盟診所。"
    },
    {
      "title": "客服服務",
      "content": "您可以透過「智能客服」尋找答案，若「智能客服」無法解決您的問題，可以輸入「真人客服」，將有專員爲您解答。"
    },
    // {"title": "", "content": ""},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 100,
        title: Text("常見問題"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              label: Text("搜尋"),
              suffix: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: ((context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GFAccordion(
                title: dataList[index]["title"],
                content: dataList[index]["content"],
              ),
            );
          })),
    );
  }
}
